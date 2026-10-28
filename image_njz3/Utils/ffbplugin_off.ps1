# Ecarte (ou remet) les fichiers du FFB Plugin et de TeknoParrot des jeux que
# linuxloader et windowsloader font tourner eux-memes.
#
# Pourquoi : le jeu charge ces fichiers meme sous le nouveau chargeur. Un
# opengl32.dll pose a cote d un jeu passe AVANT celui du chargeur, un
# dinput8.dll de crochet s injecte dans tout processus qui ouvre DirectInput,
# et le plugin double le retour de force que le chargeur donne deja.
#
# RIEN N EST EFFACE. Chaque fichier est DEPLACE dans un sous-dossier
# _teknoparrot_off a cote de lui, et chaque deplacement est note dans un
# manifeste. -Remettre relit ce manifeste et remet tout en place. TeknoParrot
# retrouve alors son retour de force pour ces jeux.
#
#   ffbplugin_off.ps1 -WhatIf      ce qui serait deplace, sans rien toucher
#   ffbplugin_off.ps1              deplace
#   ffbplugin_off.ps1 -Remettre    remet tout en place
#
# Deux familles de jeux, deux regles :
#  - les jeux LINUX (linuxloader) : aucune DLL Windows ne peut etre celle du
#    jeu, on ecarte donc toute la liste. Ne jamais toucher aux bibliotheques
#    du jeu lui-meme : nsAdrv.dll de Dead Heat est une bibliotheque LINUX,
#    malgre son nom, et n est pas dans la liste.
#  - les jeux WINDOWS (windowsloader) : dinput8.dll, winmm.dll, d3d9.dll ou
#    opengl32.dll ou xinput1_3.dll peuvent etre a la fois le plugin et une DLL du jeu. On n en
#    ecarte une que si elle CONTIENT la chaine "FFBPlugin" (le plugin lit son
#    FFBPlugin.ini), et SDL2.dll seulement si aucun executable du jeu dans le
#    meme dossier ne l importe.
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [switch]$Remettre,
    [string]$Manifeste = (Join-Path $PSScriptRoot 'ffbplugin_off_manifeste.csv')
)
$ErrorActionPreference = 'Stop'
$JEUX = 'C:\Racecab\Games'
$RANGEMENT = '_teknoparrot_off'

$linux = @(
    'Dead Heat - Namco ES1',
    'Dead Heat Riders - Namco N2',
    'Gaelco Championship Tuning Race - Gaelco PC Based',
    'Hummer Extreme - SEGA Lindbergh',
    'Initial D 4 Export (Fr Traduction) - SEGA Lindbergh',
    'Initial D 4 - SEGA Lindbergh',
    'Initial D 5 Export - SEGA Lindbergh',
    'Maximum Heat 3D - Namco ES1',
    'Nirin - Namco ES1',
    'Outrun 2 SP SDX - SEGA Lindbergh',
    'Ring Riders - Gaelco PC Based',
    'R-Tuned Ultimate Street Racing - SEGA Lindbergh',
    'Sega Race TV - SEGA Lindbergh',
    'Tokyo Cop - Gaelko PC Based',
    'Wangan Midnight Maximum Tune 3 (Export) - Namco N2',
    'Wangan Midnight Maximum Tune 3DX+ (Japan) - Namco N2'
) | ForEach-Object { Join-Path $JEUX $_ }

$windows = @(
    'Sega Rally 3 - SEGA Europa R - Original',
    'Sega Rally 3 - SEGA Europa R - StandardEdition',
    'Sega Rally 3 - SEGA Europa R - AlpineEdition',
    'Sega Rally 3 - SEGA Europa R - ArticEdition',
    'Sega Rally 3 - SEGA Europa R - CanyonEdition',
    'Sega Rally 3 - SEGA Europa R - MasterEdition',
    'Sega Rally 3 - SEGA Europa R - SafariEdition',
    'Sega Rally 3 - SEGA Europa R - TropicalEdition',
    'Sega Rally 3 - SEGA Europa R - TropicalEdition478',
    'Daytona Championship USA',
    'Daytona Championship USA New Season Edition',
    'Ford Racing Full Blown - SEGA Arcade PC Based',
    'Wasteland Racers 2071 - Trio Tech PC Based',
    # windowsloader release 4 (24/10/2026), accord du proprietaire
    'Storm Racer G - SEGA Arcade PC Based',
    'Wacky Races - Taito Type X 2'
) | ForEach-Object { Join-Path $JEUX $_ }
# GRID n est pas sous C:\Racecab\Games (voir README)
$windows += 'C:\Sega\Grid'
# Sega Racing Classic non plus n est pas sous C:\Racecab\Games
$windows += 'C:\Sega Racing Classic'

# Cherche un texte dans un binaire, en ASCII et en UTF-16 (les deux formes
# qu un nom de fichier prend dans un executable Windows), sans tenir compte
# de la casse. Le Latin-1 fait correspondre un octet a un caractere.
function Contient($chemin, $texte) {
    $latin1 = [Text.Encoding]::GetEncoding(28591)
    $s = $latin1.GetString([IO.File]::ReadAllBytes($chemin))
    foreach ($motif in @([Text.Encoding]::ASCII.GetBytes($texte), [Text.Encoding]::Unicode.GetBytes($texte))) {
        if ($s.IndexOf($latin1.GetString($motif), [StringComparison]::OrdinalIgnoreCase) -ge 0) { return $true }
    }
    $false
}

function ACarter($racine, $famille) {
    $sortie = @()
    if (-not (Test-Path -LiteralPath $racine)) { return , @() }
    $tout = @(Get-ChildItem -LiteralPath $racine -Recurse -Force -ErrorAction SilentlyContinue |
              Where-Object { $_.FullName -notmatch [regex]::Escape("\$RANGEMENT") })
    foreach ($f in $tout) {
        $n = $f.Name
        $garder = $true
        $raison = ''
        if ($f.PSIsContainer) {
            if ($famille -eq 'linux' -and $n -ieq 'TeknoParrot') { $garder = $false; $raison = 'dossier TeknoParrot' }
        } elseif ($n -like 'FFBPlugin*') {
            $garder = $false; $raison = 'FFB Plugin'
        } elseif ($famille -eq 'linux') {
            if ($n -like 'OutputBlaster*')                            { $garder = $false; $raison = 'OutputBlaster' }
            elseif ($n -in @('dinput8.dll', 'opengl32.dll', 'SDL2.dll', 'MetroFramework.dll')) { $garder = $false; $raison = 'DLL Windows pres d un jeu Linux' }
            elseif ($n -in @('teknoparrot.ini', 'teknoparrot.ini.bak')) { $garder = $false; $raison = 'reglage TeknoParrot' }
            elseif ($n -like 'BudgieLoader*.stackdump')               { $garder = $false; $raison = 'trace de plantage TeknoParrot' }
        } else {
            $dossier = $f.DirectoryName
            $plugin = Test-Path -LiteralPath (Join-Path $dossier 'FFBPlugin.ini')
            if ($plugin -and $n -in @('dinput8.dll', 'winmm.dll', 'd3d9.dll', 'opengl32.dll', 'xinput1_3.dll')) {
                if (Contient $f.FullName 'FFBPlugin') { $garder = $false; $raison = 'DLL du FFB Plugin' }
            } elseif ($plugin -and $n -eq 'MetroFramework.dll') {
                $garder = $false; $raison = 'interface du FFB Plugin'
            } elseif ($plugin -and $n -eq 'SDL2.dll') {
                $importe = @(Get-ChildItem -LiteralPath $dossier -Filter '*.exe' -File |
                             Where-Object { $_.Name -notlike 'FFBPlugin*' } |
                             Where-Object { Contient $_.FullName 'SDL2.dll' })
                if ($importe.Count -eq 0) { $garder = $false; $raison = 'SDL2 du FFB Plugin (aucun exe du jeu ne l importe)' }
            }
        }
        if (-not $garder) { $sortie += [pscustomobject]@{ Chemin = $f.FullName; Raison = $raison; Dossier = $f.PSIsContainer } }
    }
    # un dossier TeknoParrot ecarte emporte son contenu : on ne liste pas ce qu il contient
    $dossiers = @($sortie | Where-Object Dossier | ForEach-Object { $_.Chemin + '\' })
    , @($sortie | Where-Object { $c = $_.Chemin; -not ($dossiers | Where-Object { $c.StartsWith($_) }) })
}

if ($Remettre) {
    if (-not (Test-Path $Manifeste)) { throw "pas de manifeste : $Manifeste" }
    $lignes = @(Import-Csv $Manifeste)
    $remis = 0; $saute = 0
    foreach ($l in ($lignes | Sort-Object { $_.Deplace.Length } -Descending)) {
        if (-not (Test-Path -LiteralPath $l.Deplace)) { "  absent, saute : $($l.Deplace)"; $saute++; continue }
        if (Test-Path -LiteralPath $l.Original) { "  deja en place, saute : $($l.Original)"; $saute++; continue }
        if ($PSCmdlet.ShouldProcess($l.Original, 'remettre')) {
            Move-Item -LiteralPath $l.Deplace -Destination $l.Original
            $vide = Split-Path $l.Deplace -Parent
            if ((Split-Path $vide -Leaf) -eq $RANGEMENT -and -not (Get-ChildItem -LiteralPath $vide -Force)) {
                Remove-Item -LiteralPath $vide
            }
        }
        $remis++
    }
    if (-not $WhatIfPreference) {
        Move-Item $Manifeste ($Manifeste + '.remis-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
    }
    "{0} remis en place, {1} sautes" -f $remis, $saute
    return
}

$plan = @()
foreach ($r in $linux)   { foreach ($x in (ACarter $r 'linux'))   { $plan += $x | Add-Member -PassThru NoteProperty Famille 'linux' } }
foreach ($r in $windows) { foreach ($x in (ACarter $r 'windows')) { $plan += $x | Add-Member -PassThru NoteProperty Famille 'windows' } }

$faits = @()
foreach ($p in $plan) {
    $dest = Join-Path (Join-Path (Split-Path $p.Chemin -Parent) $RANGEMENT) (Split-Path $p.Chemin -Leaf)
    if (Test-Path -LiteralPath $dest) { "  destination deja prise, saute : $dest"; continue }
    if ($PSCmdlet.ShouldProcess($p.Chemin, "ecarter ($($p.Raison))")) {
        New-Item -ItemType Directory -Force -Path (Split-Path $dest -Parent) | Out-Null
        Move-Item -LiteralPath $p.Chemin -Destination $dest
        $faits += [pscustomobject]@{ Original = $p.Chemin; Deplace = $dest; Raison = $p.Raison; Famille = $p.Famille }
    }
}
if ($faits.Count) {
    # on AJOUTE au manifeste : un second passage ne doit pas effacer la trace du premier
    $faits | Export-Csv $Manifeste -NoTypeInformation -Encoding UTF8 -Append
}
"{0} element(s) prevu(s), {1} deplace(s){2}" -f $plan.Count, $faits.Count, $(if ($WhatIfPreference) { ' (simulation)' } else { " ; manifeste : $Manifeste" })
$plan | Group-Object Famille, Raison | ForEach-Object { "    {0,4}  {1}" -f $_.Count, $_.Name }
