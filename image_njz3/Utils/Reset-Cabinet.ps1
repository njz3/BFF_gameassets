<#
.SYNOPSIS
  Remet une borne a zero avant de cloner son disque : NVRAM propres pour la
  cabine choisie, Saves et C:\Temp vides, outils de test arretes.

.DESCRIPTION
  Fait en une fois les etapes 3 et 4 du tutoriel de clonage (IMAGE.md, 2.14)
  et le menage des essais :

    1. verifie : console administrateur, filtre d'ecriture UWF desactive,
       aucun programme lance depuis C:\Racecab (jeu, emulateur, AttractPlus) ;
    2. dit ce qui va etre efface, avec les tailles, et demande confirmation ;
    3. arrete et desactive les taches planifiees qui lancent un programme de
       C:\Temp (la capture d'ecran "BFF - capture"), puis arrete les
       programmes lances depuis C:\Temp (vjoydffb, boucle de capture) ;
    4. vide C:\Racecab\Saves (le dossier lui-meme reste), les statistiques
       d'AttractPlus, et retire les dossiers de travail _a_supprimer-*,
       _sauvegardes et _tests_* de la racine ; efface les journaux et
       fichiers de debug que les jeux TeknoParrot ecrivent en tournant (voir
       JournauxDesJeux) ; ferme le BackForceFeeder et efface ses licences
       (*.dat : elles dependent de la machine, le nouvel utilisateur demande
       la sienne) et les temoins de l'assistant d'etalonnage, ce que faisait
       reset_ssd_params.bat ;
    5. Build-Config -Cabine <cabine> -ForcerNvram : identite de cabine et
       NVRAM reposees depuis leurs modeles (Supermodel, sm2-emu, Flycast,
       MAME, linuxloader) ;
    6. recopie les reglages link de windowsloader que Build-Config ne pose pas :
       saves_link_cabN dans Saves\windowsloader_link_cabN (Sonic, Sega Racing
       Classic, Virtua RLimit, Chase HQ 2), testmode_link_cabN dans les dossiers
       des deux Mario Kart DX (PCB-ID) ;
    7. vide C:\Temp ;
    8. lance le script de resolution (Set*.bat) : Windows, NVRAM de Virtua
       Racing au format de l'ecran, Build-Config -Res ;
    9. Build-Config -Etat, pour verifier.

  Les fichiers sont effaces pour de bon, pas mis a la corbeille. Les scripts
  de test et de pilotage de C:\Temp sont archives dans le depot
  BackForceFeeder, dossier cabinet-harness.

  Restent a la main, apres : le reseau Windows (SetWindowsNetwork_RunAsAdmin.bat),
  la licence et les ControlSets du BackForceFeeder, la corbeille, puis UWF.

  Point d'entree : Utils\reset_ssd_params.bat, en administrateur, avec les
  memes arguments ; il ferme BFF et AttractPlus puis appelle ce script.

.EXAMPLE
  reset_ssd_params.bat -Cabine _link_cab1 -Video SetLCD_1920x1080p -WhatIf
  .\Reset-Cabinet.ps1 -Cabine _link_cab1 -Video SetLCD_1920x1080p -WhatIf
  .\Reset-Cabinet.ps1 -Cabine _link_cab2 -Video SetLCD_1920x1080p
#>
param(
  # Identite de la cabine, sa place dans un link. Une borne seule : _link_cab1.
  [Parameter(Mandatory = $true)]
  [ValidateSet('_link_cab1', '_link_cab2', '_link_cab3', '_link_cab4')]
  [string]$Cabine,
  # Script de resolution a lancer en dernier, sans .bat (SetLCD_1920x1080p...).
  # Omis : celui de la resolution en place, s'il est seul a la donner.
  [string]$Video,
  [string]$Racine = 'C:\Racecab',
  [string]$Temp = 'C:\Temp',
  # Le dossier de configuration du BackForceFeeder : ses licences sont effacees
  [string]$DossierBff = 'C:\Users\Racecab\Documents\BackForceFeeder',
  # Ne pas demander de confirmation.
  [switch]$Oui,
  # Dire ce qui serait fait, sans rien changer.
  [switch]$WhatIf
)
$ErrorActionPreference = 'Stop'
$UTILS = Join-Path $Racine 'Utils'
$BUILD = Join-Path $UTILS 'config\Build-Config.ps1'
$SAVES = Join-Path $Racine 'Saves'
$numCab = $Cabine.Substring($Cabine.Length - 1)

function Taille([string]$chemin) {
  $o = (Get-ChildItem -LiteralPath $chemin -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
  if (-not $o) { return '0 Mo' }
  '{0:N1} Mo' -f ($o / 1MB)
}

function LancerBuild([string[]]$arguments) {
  Write-Host "`n--- Build-Config $($arguments -join ' ')"
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $BUILD @arguments
  if ($LASTEXITCODE -ne 0) { throw "Build-Config $($arguments -join ' ') a echoue (code $LASTEXITCODE)" }
}

# Vide un dossier sans le supprimer. Un fichier tenu par un programme est
# signale et laisse en place, le reste est efface.
function Vider([string]$chemin) {
  if (-not (Test-Path -LiteralPath $chemin)) { return }
  foreach ($e in Get-ChildItem -LiteralPath $chemin -Force) {
    try { Remove-Item -LiteralPath $e.FullName -Recurse -Force -ErrorAction Stop }
    catch { Write-Warning "non efface : $($e.FullName) ($($_.Exception.Message))" }
  }
}

# Les journaux et fichiers de debug que les jeux TeknoParrot (et TeknoParrot
# lui-meme : AMDaemon, ip_log, BudgieLoader) ecrivent en tournant : debug.txt
# (2,3 Go pour Daytona Championship USA), *.dmp, *.stackdump, *.log,
# *log.txt, dans les dossiers de jeux qu'un profil TeknoParrot vise, plus les
# deux Daytona Championship USA. Seulement ceux de 2024 et apres : les plus
# vieux sont venus avec le jeu. Jamais ceux qui sont des donnees du jeu ou de
# l'image systeme d'origine : les voitures fantomes de Hummer
# (ghost_car_stage*.log), les err.log de data\model (Dead Heat, Maximum Heat,
# Mario Kart), salidas des Gaelco, var\log, XFree86 et ksyms des jeux Linux.
# Releve du 03/11/2026 : 61 fichiers (3 Go) sur Racecab1, 34 (1 Go) sur Racecab2.
function JournauxDesJeux {
  $jeux = @{}
  $games = Join-Path $Racine 'Games'
  foreach ($tp in Get-ChildItem -LiteralPath (Join-Path $Racine 'Emulators') -Directory -Filter 'Teknoparrot*') {
    foreach ($xml in Get-ChildItem -LiteralPath (Join-Path $tp.FullName 'UserProfiles') -Filter *.xml -ErrorAction SilentlyContinue) {
      try { $chemin = ([xml](Get-Content -LiteralPath $xml.FullName -Raw)).GameProfile.GamePath } catch { $chemin = $null }
      if ($chemin -and $chemin.StartsWith("$games\", [StringComparison]::OrdinalIgnoreCase)) {
        $jeux[(Join-Path $games ($chemin.Substring($games.Length + 1).Split('\')[0]))] = 1
      }
    }
  }
  $jeux[(Join-Path $games 'Daytona Championship USA')] = 1
  $jeux[(Join-Path $games 'Daytona Championship USA New Season Edition')] = 1
  $exclus = '\\ghost_car\\|\\data\\model\\|\\salidas\\|\\var\\log|XFree86|ksyms'
  foreach ($j in $jeux.Keys) {
    if (-not (Test-Path -LiteralPath $j)) { continue }
    Get-ChildItem -LiteralPath $j -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object {
      ($_.Extension -in '.log', '.dmp', '.stackdump' -or $_.Name -eq 'debug.txt' -or $_.Name -like '*log.txt') -and
      $_.FullName -notmatch $exclus -and $_.LastWriteTime -ge [datetime]'2024-01-01' }
  }
}

# ------------------------------------------------------------ 1. verifications
if (-not (Test-Path -LiteralPath $BUILD)) { throw "introuvable : $BUILD" }

$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin -and -not $WhatIf) { throw 'lancer ce script dans une console PowerShell en administrateur' }

try {
  $uwf = Get-CimInstance -Namespace root\standardcimv2\embedded -ClassName UWF_Filter -ErrorAction Stop
  if ($uwf.CurrentEnabled -or $uwf.NextEnabled) {
    throw "le filtre d'ecriture UWF est actif (maintenant : $($uwf.CurrentEnabled), au prochain demarrage : $($uwf.NextEnabled)) : le desactiver et redemarrer avant"
  }
} catch [Microsoft.Management.Infrastructure.CimException] {
  # UWF non installe : rien a verifier
}

$racineVue = $Racine.TrimEnd('\') + '\'
$enCours = @(Get-CimInstance Win32_Process | Where-Object { $_.ExecutablePath -and $_.ExecutablePath.StartsWith($racineVue, [StringComparison]::OrdinalIgnoreCase) })
if ($enCours) {
  $liste = ($enCours | ForEach-Object { "  $($_.ProcessId) $($_.ExecutablePath)" }) -join "`n"
  $message = "des programmes tournent depuis $Racine, les fermer avant (AttractPlus : Utils\killAttractModePlus.bat) :`n$liste"
  if ($WhatIf) { Write-Warning $message } else { throw $message }
}

# Le script de resolution : choisi avant tout changement, pour ne pas
# s'arreter a mi-chemin.
if ($Video) {
  $batVideo = Join-Path $UTILS (($Video -replace '\.bat$', '') + '.bat')
  if (-not (Test-Path -LiteralPath $batVideo)) { throw "script de resolution introuvable : $batVideo" }
} else {
  $temoinRes = Get-ChildItem -LiteralPath $Racine -Filter 'Configured_for*.txt' | Select-Object -First 1
  if (-not $temoinRes -or $temoinRes.BaseName -notmatch '^Configured_for(.+)$') { throw 'aucune resolution en place : passer -Video' }
  $resEnPlace = $Matches[1]
  $candidats = @(Get-ChildItem -LiteralPath $UTILS -Filter 'Set*.bat' | Where-Object {
      Select-String -LiteralPath $_.FullName -SimpleMatch -Pattern "RES_EXT=$resEnPlace" -Quiet })
  if ($candidats.Count -ne 1) {
    throw "resolution en place $resEnPlace : $($candidats.Count) scripts possibles ($(($candidats | ForEach-Object BaseName) -join ', ')), choisir par -Video"
  }
  $batVideo = $candidats[0].FullName
}

# Reglages link de windowsloader pour cette cabine
$WL = Join-Path $Racine 'Emulators\windowsloader'
$wlSaves = Join-Path $WL "saves$Cabine"
$wlTest = Join-Path $WL "testmode$Cabine"
$MKDX = @(
  @{ Modele = 'MKDX118'; Jeu = 'Mario Kart Arcade GP DX V1.18 - Namco ES3' },
  @{ Modele = 'MKDX';    Jeu = 'Mario Kart Arcade GP DX (V1.10 - Mod FR 1h) - Namco ES3' }
)

# ------------------------------------------------------------ 2. le plan
$taches = @(Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object {
    ($_.Actions | ForEach-Object { "$($_.Execute) $($_.Arguments)" }) -match [regex]::Escape($Temp.TrimEnd('\') + '\') })
$tempVu = $Temp.TrimEnd('\') + '\'
# jamais ce script ni la console qui l'a lance
$parent = (Get-CimInstance Win32_Process -Filter "ProcessId = $PID").ParentProcessId
$outils = @(Get-CimInstance Win32_Process | Where-Object {
    $_.ProcessId -ne $PID -and $_.ProcessId -ne $parent -and (
      ($_.ExecutablePath -and $_.ExecutablePath.StartsWith($tempVu, [StringComparison]::OrdinalIgnoreCase)) -or
      ($_.Name -match '^(powershell|pwsh|wscript|cscript|cmd)\.exe$' -and $_.CommandLine -and $_.CommandLine.IndexOf($tempVu, [StringComparison]::OrdinalIgnoreCase) -ge 0)) })
$travail = @(Get-ChildItem -LiteralPath $Racine -Directory -Force | Where-Object { $_.Name -match '^(_a_supprimer-.*|_sauvegardes|_tests_.*)$' })
$stats = Join-Path $Racine 'AttractPlus\stats'
$lastRun = Join-Path $Racine 'AttractPlus\last_run.log'
$licences = @(Get-ChildItem -LiteralPath $DossierBff -Filter *.dat -File -ErrorAction SilentlyContinue)
$temoinsAssistant = @('calibration_done', 'calibration_done.flag' | ForEach-Object { Join-Path $UTILS "Assistant_BFF\$_" } | Where-Object { Test-Path -LiteralPath $_ })
$journaux = @(JournauxDesJeux)
$tailleJournaux = '{0:N1} Mo' -f ((($journaux | Measure-Object Length -Sum).Sum) / 1MB)

Write-Host "`n=== Remise a zero de la borne : cabine $Cabine"
Write-Host "`nArreter :"
if (-not $taches -and -not $outils) { Write-Host '  rien' }
foreach ($t in $taches) { Write-Host "  tache planifiee '$($t.TaskName)' (arretee puis desactivee)" }
foreach ($p in $outils) { Write-Host "  programme $($p.ProcessId) : $($p.CommandLine)" }
Write-Host "`nEffacer pour de bon :"
Write-Host ("  {0,-48} {1}" -f "$SAVES\*", (Taille $SAVES))
Write-Host ("  {0,-48} {1}" -f "$tempVu*", (Taille $Temp))
Write-Host ("  {0,-48} {1}" -f "$stats\*", (Taille $stats))
foreach ($d in $travail) { Write-Host ("  {0,-48} {1}" -f $d.FullName, (Taille $d.FullName)) }
Write-Host ("  {0,-48} {1}" -f "journaux des jeux TeknoParrot ($($journaux.Count))", $tailleJournaux)
foreach ($f in $licences) { Write-Host "  licence BFF $($f.Name) (propre a cette machine)" }
foreach ($f in $temoinsAssistant) { Write-Host "  $f" }
Write-Host "`nReposer :"
Write-Host "  Build-Config -Cabine $Cabine -ForcerNvram"
if (Test-Path -LiteralPath $wlSaves) { Write-Host "  $wlSaves -> $SAVES\windowsloader$Cabine" }
else { Write-Warning "pas de modele $wlSaves : Sonic, Sega Racing Classic, Virtua RLimit et Chase HQ 2 repartiront de reglages d'usine en link" }
foreach ($m in $MKDX) {
  $src = Join-Path $wlTest $m.Modele
  if (Test-Path -LiteralPath $src) { Write-Host "  $src -> Games\$($m.Jeu)" }
  else { Write-Warning "pas de modele $src : $($m.Jeu) garde le PCB-ID en place" }
}
Write-Host "  $(Split-Path -Leaf $batVideo) (resolution)"

if ($WhatIf) {
  LancerBuild @('-Cabine', $Cabine, '-ForcerNvram', '-WhatIf')
  Write-Host "`n-WhatIf : rien n'a ete change."
  return
}
if (-not $Oui) {
  $reponse = Read-Host "`nTaper $Cabine pour confirmer"
  if ($reponse -ne $Cabine) { Write-Host 'abandon, rien change'; return }
}

# ------------------------------------------------------------ 3. outils de test
foreach ($t in $taches) {
  Stop-ScheduledTask -InputObject $t -ErrorAction SilentlyContinue
  Disable-ScheduledTask -InputObject $t | Out-Null
  Write-Host "tache '$($t.TaskName)' arretee et desactivee"
}
foreach ($p in $outils) {
  Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue
  Write-Host "programme $($p.ProcessId) $($p.Name) arrete"
}

# ------------------------------------------------------------ 4. menage
Vider $SAVES
Vider $stats
if (Test-Path -LiteralPath $lastRun) { Remove-Item -LiteralPath $lastRun -Force }
foreach ($d in $travail) {
  try { Remove-Item -LiteralPath $d.FullName -Recurse -Force -ErrorAction Stop }
  catch { Write-Warning "non efface : $($d.FullName) ($($_.Exception.Message))" }
}
foreach ($f in $journaux) {
  try { Remove-Item -LiteralPath $f.FullName -Force -ErrorAction Stop }
  catch { Write-Warning "non efface : $($f.FullName) ($($_.Exception.Message))" }
}
Write-Host "Saves, statistiques d'AttractPlus, dossiers de travail et journaux des jeux vides"

# Le BackForceFeeder, par son nom : il ne tourne pas depuis C:\Racecab
Get-Process -Name 'BackForceFeeder' -ErrorAction SilentlyContinue | ForEach-Object {
  Stop-Process -Id $_.Id -Force; Write-Host "BackForceFeeder ($($_.Id)) ferme" }
foreach ($f in @($licences | ForEach-Object FullName) + $temoinsAssistant) {
  try { Remove-Item -LiteralPath $f -Force -ErrorAction Stop; Write-Host "efface : $f" }
  catch { Write-Warning "non efface : $f ($($_.Exception.Message))" }
}

# ------------------------------------------------------------ 5. cabine et NVRAM
LancerBuild @('-Cabine', $Cabine, '-ForcerNvram')

# ------------------------------------------------------------ 6. windowsloader link
if (Test-Path -LiteralPath $wlSaves) {
  $dest = Join-Path $SAVES "windowsloader$Cabine"
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  Copy-Item -Path (Join-Path $wlSaves '*') -Destination $dest -Recurse -Force
  Write-Host "reglages link windowsloader poses dans $dest"
}
foreach ($m in $MKDX) {
  $src = Join-Path $wlTest $m.Modele
  $jeu = Join-Path $Racine "Games\$($m.Jeu)"
  if (-not (Test-Path -LiteralPath $src)) { continue }
  if (-not (Test-Path -LiteralPath $jeu)) { Write-Warning "jeu absent : $jeu"; continue }
  Copy-Item -Path (Join-Path $src '*') -Destination $jeu -Recurse -Force
  Write-Host "PCB-ID de la cabine $numCab pose dans $($m.Jeu)"
}

# ------------------------------------------------------------ 7. C:\Temp
Vider $Temp
Write-Host "$Temp vide"

# ------------------------------------------------------------ 8. resolution
Write-Host "`n--- $(Split-Path -Leaf $batVideo)"
Push-Location $UTILS
try {
  & cmd.exe /c "`"$batVideo`""
  if ($LASTEXITCODE -ne 0) { Write-Warning "$(Split-Path -Leaf $batVideo) a rendu le code $LASTEXITCODE" }
} finally { Pop-Location }

# ------------------------------------------------------------ 9. verification
LancerBuild @('-Etat')

Write-Host @"

Remise a zero terminee pour $Cabine. Restent, a la main :
  - reseau Windows, bornes reliees seulement : Utils\SetWindowsNetwork_RunAsAdmin.bat, choix $numCab ;
  - BackForceFeeder : demander la licence de la machine (son ID s'affiche au
    demarrage de BFF), ControlSets du panneau, etalonnage ;
  - vider la corbeille ;
  - le controle final (IMAGE.md 2.13), puis UWF si la borne doit etre protegee,
    avec $SAVES comme seule exclusion.
"@
