<#
.SYNOPSIS
    Désactive l'algorithme de Nagle sur toutes les interfaces Ethernet actives.

.DESCRIPTION
    Compatible Windows 10 LTSC et Windows 11.
    Le script :
      1. Vérifie les droits administrateur (et relance en élévation si besoin).
      2. Recherche les cartes Ethernet physiques dont l'état est "Up".
      3. Pour chaque carte, retrouve la clé de registre correspondante via son GUID
         sous HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{GUID}.
      4. Ajoute/modifie les valeurs DWORD nécessaires à la désactivation de Nagle :
            TcpAckFrequency = 1   (désactive le regroupement des ACK)
            TCPNoDelay      = 1   (désactive Nagle proprement dit)
            TcpDelAckTicks  = 0   (supprime le délai d'ACK)

    Un redémarrage (ou une réinitialisation de la pile réseau) est nécessaire
    pour que les modifications prennent effet.

.NOTES
    À exécuter dans une console PowerShell en tant qu'administrateur.
    Pour annuler : voir le script Enable-Nagle.ps1 ou supprimer les trois valeurs
    dans les clés de registre concernées.
#>

#Requires -Version 5.1

# --- 1. Élévation automatique en administrateur -----------------------------
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent())

if (-not $currentPrincipal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Host "Droits administrateur requis. Relance du script en élévation..." -ForegroundColor Yellow
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName  = (Get-Process -Id $PID).Path            # powershell.exe ou pwsh.exe
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb      = "runas"
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Host "Élévation annulée. Le script ne peut pas continuer." -ForegroundColor Red
    }
    return
}

# --- 2. Paramètres à écrire dans le registre --------------------------------
$nagleValues = @{
    'TcpAckFrequency' = 1
    'TCPNoDelay'      = 1
    'TcpDelAckTicks'  = 0
}

$interfacesBase = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces'

# --- 3. Sélection des cartes Ethernet physiques actives ---------------------
# On garde les cartes physiques, à l'état "Up", de type Ethernet (802.3),
# en excluant le Wi-Fi.
$adapters = Get-NetAdapter -Physical -ErrorAction Stop | Where-Object {
    $_.Status -eq 'Up' -and $_.PhysicalMediaType -eq '802.3'
}

if (-not $adapters) {
    Write-Host "Aucune interface Ethernet active trouvée." -ForegroundColor Yellow
    return
}

Write-Host "Interfaces Ethernet actives détectées :" -ForegroundColor Cyan
$adapters | Format-Table -AutoSize Name, InterfaceDescription, LinkSpeed, InterfaceGuid

# --- 4. Application sur chaque interface -------------------------------------
foreach ($adapter in $adapters) {

    $guid = $adapter.InterfaceGuid          # ex. {XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}
    $regPath = Join-Path $interfacesBase $guid

    Write-Host "`n--- $($adapter.Name)  [$guid] ---" -ForegroundColor Green

    # La sous-clé existe normalement pour une carte liée à TCP/IP ; on la crée sinon.
    if (-not (Test-Path $regPath)) {
        Write-Host "  Clé absente, création : $regPath" -ForegroundColor Yellow
        New-Item -Path $regPath -Force | Out-Null
    }

    foreach ($name in $nagleValues.Keys) {
        try {
            New-ItemProperty -Path $regPath -Name $name `
                -Value $nagleValues[$name] -PropertyType DWord -Force | Out-Null
            Write-Host ("  {0,-16} = {1}" -f $name, $nagleValues[$name])
        } catch {
            Write-Host "  Échec sur $name : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Write-Host "`nTerminé. Un redémarrage est recommandé pour appliquer les changements." -ForegroundColor Cyan
