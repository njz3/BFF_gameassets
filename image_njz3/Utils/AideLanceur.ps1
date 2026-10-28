# Aide d'un lanceur Run*.cmd appele sans argument : la syntaxe et les noms
# de jeu qu'il accepte.
#   - un lanceur qui traduit lui-meme les noms (lignes if /I "%ROM%"=="X")
#     : ces noms-la ;
#   - sinon : les jeux des listes AttractPlus qui passent par ce lanceur
#     (definition d'emulateur dont les arguments citent le lanceur, dans son
#     dossier, ou entree dont l'AltRomname vise le lanceur), avec leur titre.
# Les options en deuxieme argument (lignes if /I "%~2"=="X") sont listees.
#
# Appel, depuis le lanceur :
#   powershell -NoProfile -ExecutionPolicy Bypass -File "...\Utils\AideLanceur.ps1" "%~f0"
param([Parameter(Mandatory)] [string]$Lanceur)

$nom = Split-Path -Leaf $Lanceur
$dossier = (Split-Path -Parent $Lanceur).TrimEnd('\')
$texte = [IO.File]::ReadAllLines($Lanceur)

Write-Host ''
Write-Host "Usage : $nom <nom du jeu>"
$options = @($texte | ForEach-Object { if ($_ -match '(?i)if /I "%~2"=="([^"]+)"') { $Matches[1] } } | Select-Object -Unique)
if ($options) { Write-Host ('        ' + $nom + ' <nom du jeu> [' + ($options -join '|') + ']') }
if ($texte -match '(?i)%ROM:~-5%"=="_link"') { Write-Host "        $nom <nom du jeu>_link   (le jeu en link)" }
Write-Host ''

# 1. les noms que le lanceur traduit lui-meme
$propres = @($texte | ForEach-Object { if ($_ -match '(?i)^\s*if /I "%ROM%"=="([^"]+)"') { $Matches[1] } } | Select-Object -Unique)
if ($propres) {
    Write-Host "Noms acceptes ($($propres.Count)) :"
    $propres | ForEach-Object { Write-Host "  $_" }
    Write-Host ''
    exit 0
}

# 2. sinon, les jeux des listes AttractPlus qui passent par ce lanceur
$ap = Join-Path $PSScriptRoot '..\AttractPlus'
$emus = @{}
Get-ChildItem (Join-Path $ap 'emulators') -Filter *.cfg -ErrorAction SilentlyContinue | ForEach-Object {
    $c = Get-Content $_.FullName
    $args_ = (($c | Where-Object { $_ -match '^args\s' }) -replace '^args\s+', '') -join ' '
    $wd = ((($c | Where-Object { $_ -match '^workdir\s' }) -replace '^workdir\s+', '') -join '') -replace '/', '\'
    $emus[$_.BaseName] = @{ Args = $args_; Dossier = $wd.TrimEnd('\') }
}
$jeux = New-Object System.Collections.Generic.List[object]
Get-ChildItem (Join-Path $ap 'romlists') -Filter *.txt -ErrorAction SilentlyContinue |
    Where-Object { $_.BaseName -notmatch '_\d+x\d+$' } | ForEach-Object {
    $liste = $_.BaseName
    Get-Content $_.FullName | Select-Object -Skip 1 | Where-Object { $_ -and -not $_.StartsWith('#') } | ForEach-Object {
        $c = $_ -split ';'
        if ($c.Count -lt 14) { return }
        $e = $emus[$c[2]]
        if (-not $e) { return }
        $arg = $null
        if ($e.Args -match '^/c start "\[name\]" /WAIT \[AltRomname\]') {
            # le lanceur est l'AltRomname de l'entree, relatif au dossier de travail
            $cible = Join-Path $e.Dossier $c[13]
            if ($cible -ieq $Lanceur) { $arg = $c[0] }
        } elseif ($e.Args -match [regex]::Escape($nom) -and $e.Dossier -ieq $dossier) {
            $arg = if ($e.Args -match '\[AltRomname\]' -and $c[13]) { $c[13] -replace '(?i)\.bat$', '' } else { $c[0] }
        }
        if ($arg) { $jeux.Add([pscustomobject]@{ Nom = $arg; Titre = $c[1]; Liste = $liste }) }
    }
}
if ($jeux.Count -eq 0) {
    Write-Host "Aucune liste AttractPlus ne passe par ce lanceur."
    Write-Host ''
    exit 0
}
$u = $jeux | Group-Object Nom | ForEach-Object {
    [pscustomobject]@{ Nom = $_.Name; Titre = $_.Group[0].Titre; Listes = (($_.Group.Liste | Select-Object -Unique) -join ', ') } } | Sort-Object Nom
Write-Host "Jeux des listes AttractPlus qui passent par ce lanceur ($(@($u).Count)) :"
$l = ($u | ForEach-Object { $_.Nom.Length } | Measure-Object -Maximum).Maximum
$u | ForEach-Object { Write-Host ('  {0}  {1}  [{2}]' -f $_.Nom.PadRight($l), $_.Titre, $_.Listes) }
Write-Host ''
