<#
.SYNOPSIS
  Amorce les dossiers d'ecriture uniques (-write-dir) de Supermodel.

.DESCRIPTION
  Supermodel, au premier lancement avec -write-dir=, recopie tout seul le
  Config\Supermodel.ini du dossier de l'emulateur et lit la NVRAM dans le
  dossier NVRAM\ en place. Sur cette image on NE s'appuie PAS sur cette
  recopie, pour deux raisons :

    1. Le Config\Supermodel.ini en place est celui d UNE identite (celle de
       la machine). Les write-dir partiraient donc du meme .ini, et toutes
       les cabines auraient la meme adresse reseau. Le .ini de chaque
       identite est produit ici depuis le gabarit Supermodel.ini.template,
       avec les memes tables que Build-Config (cabinets.csv, et la
       resolution en place dans resolutions.csv).
       Limite : un write-dir amorce garde la resolution du moment ; si on
       change de resolution, il faut le reamorcer (-Force), ce qui reecrit
       aussi ses NVRAM.

    2. Le NVRAM\ en place de "Supermodel LINK" ne correspond a aucune des
       trois variantes enregistrees : il diverge de NVRAM_link_cab1 sur 6
       fichiers, de NVRAM_link_cab2 sur 10, de NVRAM_single sur 11. Des
       parties ont ete jouees en link et l'ont reecrit sur place sans que
       les variantes soient rafraichies. L'amorcage lit donc les variantes,
       jamais le dossier en place.

  Attention : les NVRAM de Supermodel sont protegees par une somme de
  controle, ce script les copie telles quelles et n'en modifie aucun octet.

.EXAMPLE
  .\seed_writedir.ps1 -WhatIf
  .\seed_writedir.ps1 -Verifier
  .\seed_writedir.ps1 -Racine C:\Racecab
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  # racine de l'image : contient Emulators\ et Saves\
  [string]$Racine = 'C:\Racecab',
  # ou amorcer ; par defaut <Racine>\Saves
  [string]$WriteDirRoot,
  # ne rien ecrire, seulement dire ce qui est en place
  [switch]$Verifier,
  # reecrire un write-dir deja amorce
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
if (-not $WriteDirRoot) { $WriteDirRoot = Join-Path $Racine 'Saves' }

$SINGLE = Join-Path $Racine 'Emulators\Supermodel'
$LINK   = Join-Path $Racine 'Emulators\Supermodel LINK'

# --- le .ini de chaque identite, depuis le gabarit ---------------------------
# Memes regles que Build-Config : commentaires retires avant la lecture des
# tables, un mot-cle {{AINSI}} reste = erreur.
$VALEURS = Join-Path $Racine 'Utils\config\valeurs'
function LireCsv([string]$chemin) {
  if (-not (Test-Path -LiteralPath $chemin)) { throw "table absente : $chemin" }
  @(Get-Content -LiteralPath $chemin | Where-Object { $_.Trim() -and -not $_.TrimStart().StartsWith('#') }) |
    ConvertFrom-Csv -Delimiter ';'
}
$temoin = Get-ChildItem -LiteralPath $Racine -Filter 'Configured_for*.txt' -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $temoin -or $temoin.BaseName -notmatch '^Configured_for(.+)$') { throw 'aucune resolution en place (Configured_for*.txt absent)' }
$RES = $Matches[1]
$ligneRes = LireCsv (Join-Path $VALEURS 'resolutions.csv') | Where-Object { $_.RES -eq $RES }
if (-not $ligneRes) { throw "resolution inconnue : $RES" }
$GABARIT = Join-Path $SINGLE 'Config\Supermodel.ini.template'
function IniPour($ligneCab) {
  $t = [IO.File]::ReadAllText($GABARIT, [Text.Encoding]::UTF8)
  foreach ($o in @($ligneRes, $ligneCab)) {
    foreach ($p in $o.PSObject.Properties) {
      if ($p.Name -in 'RES', 'CAB') { continue }
      $t = $t.Replace('{{' + $p.Name + '}}', [string]$p.Value)
    }
  }
  if ($t -match '\{\{([A-Z_0-9]+)\}\}') { throw "$($ligneCab.CAB) : mot-cle sans valeur : $($Matches[1])" }
  $t
}

# une identite par ligne de cabinets.csv -> (.ini produit, dossier de NVRAM source)
$MODES = foreach ($c in (LireCsv (Join-Path $VALEURS 'cabinets.csv'))) {
  [pscustomobject]@{
    Suffixe = $c.CAB
    Ini     = IniPour $c
    Nvram   = if ($c.CAB -eq '_single') { Join-Path $SINGLE 'NVRAM_single' } else { Join-Path $LINK "NVRAM$($c.CAB)" }
  }
}

# ---------------------------------------------------------------- verification
if ($Verifier) {
  foreach ($m in $MODES) {
    $wd = Join-Path $WriteDirRoot "supermodel$($m.Suffixe)"
    Write-Host "`n=== supermodel$($m.Suffixe)"
    Write-Host "    $wd"
    if (-not (Test-Path -LiteralPath $wd)) { Write-Host '    PAS AMORCE'; continue }

    $ini = Join-Path $wd 'Config\Supermodel.ini'
    if (Test-Path -LiteralPath $ini) {
      # la ligne AddressOut identifie la cabine a elle seule
      $addr = Select-String -LiteralPath $ini -Pattern 'AddressOut' | ForEach-Object { $_.Line.Trim() }
      Write-Host "    ini      OK   $addr"
    } else {
      Write-Host '    ini      MANQUE'
    }

    $nv = @(Get-ChildItem -LiteralPath $wd -Filter *.nv -Recurse -ErrorAction SilentlyContinue)
    Write-Host "    nvram    $($nv.Count) fichier(s)"

    # comparer a la source : l'amorcage a-t-il derive ?
    if (Test-Path -LiteralPath $m.Nvram) {
      $differents = 0
      foreach ($src in Get-ChildItem -LiteralPath $m.Nvram -Filter *.nv) {
        $romset = [IO.Path]::GetFileNameWithoutExtension($src.Name)
        $dst = Join-Path $wd "$romset\NVRAM\$($src.Name)"
        if (-not (Test-Path -LiteralPath $dst)) { $differents++; continue }
        $a = (Get-FileHash -LiteralPath $src.FullName -Algorithm SHA256).Hash
        $b = (Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash
        if ($a -ne $b) { $differents++ }
      }
      Write-Host "    ecart par rapport a $($m.Nvram | Split-Path -Leaf) : $differents fichier(s)"
    }
  }
  Write-Host ''
  return
}

# ---------------------------------------------------------------- amorcage
foreach ($m in $MODES) {
  $wd = Join-Path $WriteDirRoot "supermodel$($m.Suffixe)"
  Write-Host "`n=== supermodel$($m.Suffixe)  ->  $wd"

  if (-not (Test-Path -LiteralPath $m.Nvram)) { throw "source absente : $($m.Nvram)" }

  $dejaLa = Test-Path -LiteralPath (Join-Path $wd 'Config\Supermodel.ini')
  if ($dejaLa -and -not $Force) {
    Write-Host '    deja amorce, ignore (passer -Force pour reecrire)'
    continue
  }

  # 1. les reglages de cette identite, dans Supermodel.ini : le nom que lit l'emulateur
  $cfg = Join-Path $wd 'Config'
  if ($PSCmdlet.ShouldProcess("$cfg\Supermodel.ini", "ecrire le gabarit rempli pour $($m.Suffixe)")) {
    New-Item -ItemType Directory -Force -Path $cfg | Out-Null
    [IO.File]::WriteAllText((Join-Path $cfg 'Supermodel.ini'), $m.Ini, (New-Object Text.UTF8Encoding $false))
  }
  $addr = ($m.Ini -split "`r?`n" | Where-Object { $_ -match '^\s*AddressOut' } | Select-Object -First 1).Trim()
  Write-Host "    ini    <- Supermodel.ini.template ($($m.Suffixe), $RES ; $addr)"

  # 2. une NVRAM par jeu, dans <write-dir>\<romset>\NVRAM\<romset>.nv
  $n = 0
  foreach ($src in Get-ChildItem -LiteralPath $m.Nvram -Filter *.nv) {
    $romset = [IO.Path]::GetFileNameWithoutExtension($src.Name)
    $dst    = Join-Path $wd "$romset\NVRAM"
    if ($PSCmdlet.ShouldProcess("$dst\$($src.Name)", 'copier la NVRAM')) {
      New-Item -ItemType Directory -Force -Path $dst | Out-Null
      Copy-Item -LiteralPath $src.FullName -Destination (Join-Path $dst $src.Name) -Force
    }
    $n++
  }
  Write-Host "    nvram  <- $($m.Nvram | Split-Path -Leaf), $n jeu(x)"
}

Write-Host @"

Amorcage termine. Games.xml et Music.xml ne sont PAS copies : Supermodel les
lit dans le write-dir s'ils y sont, sinon a leur emplacement d'origine, et il
vaut mieux ne pas les dupliquer.

Pour activer, mettre dans Utils\set_writedir.bat :
    set WRITEDIR_ROOT=$WriteDirRoot
Puis declarer l'exclusion UWF :
    uwfmgr file add-exclusion $WriteDirRoot
"@
