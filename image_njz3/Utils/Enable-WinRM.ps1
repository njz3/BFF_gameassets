#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Turns WinRM on, on a cabinet PC, so that BackForceFeeder's development PC
    can reach it (Invoke-Command, as with Racecab1).

.DESCRIPTION
    Run on the cabinet, in an elevated PowerShell:
        powershell -ExecutionPolicy Bypass -File .\Enable-WinRM.ps1

    What it does, each step said as it goes:
      1. a network in the Public profile set to Private - WinRM's firewall
         exception is limited there (-KeepNetworkProfile leaves it alone);
      2. Enable-PSRemoting: the WinRM service started and automatic, its HTTP
         listener on 5985, the firewall exception;
      3. LocalAccountTokenFilterPolicy = 1: a local administrator account keeps
         its rights when it connects from another PC (-NoLocalAdmin leaves it
         alone);
      4. Test-WSMan.
    What was there before is written to %ProgramData%\BFF-WinRM\state.json,
    which Disable-WinRM.ps1 reads to put it back. Run again, it keeps the first
    state saved.

    The development PC still needs the cabinet in its TrustedHosts and a
    credential file - see the commands given with these scripts.
#>
param(
    [switch]$KeepNetworkProfile,
    [switch]$NoLocalAdmin
)
$ErrorActionPreference = 'Stop'

$stateDir = Join-Path $env:ProgramData 'BFF-WinRM'
$stateFile = Join-Path $stateDir 'state.json'
$policyKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$policyName = 'LocalAccountTokenFilterPolicy'

# The state before anything is changed, kept from the first run
if (Test-Path $stateFile) {
    Write-Host "State of before already saved in $stateFile, kept"
} else {
    $policy = Get-ItemProperty -Path $policyKey -Name $policyName -ErrorAction SilentlyContinue
    $service = Get-Service WinRM
    $state = [ordered]@{
        Saved             = (Get-Date).ToString('s')
        Networks          = @(Get-NetConnectionProfile | ForEach-Object {
                                [ordered]@{ InterfaceIndex = $_.InterfaceIndex; InterfaceAlias = $_.InterfaceAlias; Category = [string]$_.NetworkCategory } })
        TokenPolicyExists = ($null -ne $policy)
        TokenPolicyValue  = if ($null -ne $policy) { [int]$policy.$policyName } else { $null }
        ServiceStartType  = [string]$service.StartType
        ServiceRunning    = ($service.Status -eq 'Running')
    }
    New-Item -ItemType Directory -Force -Path $stateDir | Out-Null
    $state | ConvertTo-Json -Depth 4 | Set-Content -Path $stateFile -Encoding UTF8
    Write-Host "State of before saved in $stateFile"
}

# 1. Public networks to Private
if ($KeepNetworkProfile) {
    Write-Host '1. Network profiles left as they are (-KeepNetworkProfile)'
} else {
    $public = @(Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -eq 'Public' })
    if ($public.Count -eq 0) {
        Write-Host '1. No network in the Public profile'
    }
    foreach ($p in $public) {
        Set-NetConnectionProfile -InterfaceIndex $p.InterfaceIndex -NetworkCategory Private
        Write-Host ("1. Network '{0}' ({1}): Public -> Private" -f $p.Name, $p.InterfaceAlias)
    }
}

# 2. WinRM: service, listener, firewall exception
if ($KeepNetworkProfile) {
    # A Public network left as it is: the firewall exception then local subnet only
    Enable-PSRemoting -Force -SkipNetworkProfileCheck | Out-Null
} else {
    Enable-PSRemoting -Force | Out-Null
}
Set-Service WinRM -StartupType Automatic
Write-Host '2. WinRM on: service automatic and running, HTTP listener, firewall exception'

# 3. A local administrator keeps its rights remotely
if ($NoLocalAdmin) {
    Write-Host "3. $policyName left as it is (-NoLocalAdmin)"
} else {
    New-ItemProperty -Path $policyKey -Name $policyName -Value 1 -PropertyType DWord -Force | Out-Null
    Write-Host "3. $policyName = 1: a local administrator keeps its rights when it connects remotely"
}

# 4. The check
Test-WSMan | Out-Null
$listeners = Get-ChildItem WSMan:\localhost\Listener | ForEach-Object {
    ($_.Keys -join ' ')
}
Write-Host ('4. Test-WSMan answers; listeners: ' + ($listeners -join '; '))
Write-Host ("WinRM is on for {0}. To turn it off: Disable-WinRM.ps1" -f $env:COMPUTERNAME)
