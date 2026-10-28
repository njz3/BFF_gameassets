#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Turns WinRM off again on a cabinet PC, what Enable-WinRM.ps1 changed put
    back as it was.

.DESCRIPTION
    Run on the cabinet itself, in an elevated PowerShell - not through WinRM,
    which it cuts:
        powershell -ExecutionPolicy Bypass -File .\Disable-WinRM.ps1

    What it does, each step said as it goes:
      1. Disable-PSRemoting: remote sessions refused;
      2. the WinRM listeners deleted;
      3. the firewall's "Windows Remote Management" rules disabled;
      4. the WinRM service stopped, and set back to its start type of before
         (Manual when none was saved, Windows' own for a client);
      5. LocalAccountTokenFilterPolicy as before: deleted when it did not
         exist, its value back otherwise (0 when nothing was saved);
      6. the networks Enable-WinRM.ps1 set to Private back to Public.
    The state of before is read from %ProgramData%\BFF-WinRM\state.json, then
    the file is removed. Without it, steps 1 to 5 run with Windows' defaults
    and the network profiles are left as they are.
#>
$ErrorActionPreference = 'Stop'

$stateDir = Join-Path $env:ProgramData 'BFF-WinRM'
$stateFile = Join-Path $stateDir 'state.json'
$policyKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$policyName = 'LocalAccountTokenFilterPolicy'

$state = $null
if (Test-Path $stateFile) {
    $state = Get-Content -Path $stateFile -Raw | ConvertFrom-Json
    Write-Host "State of before read from $stateFile (saved $($state.Saved))"
} else {
    Write-Host "No ${stateFile}: Windows' defaults, network profiles left as they are"
}

# 1. Remote sessions refused
Disable-PSRemoting -Force -WarningAction SilentlyContinue
Write-Host '1. Remote sessions refused (Disable-PSRemoting)'

# 2. The listeners deleted
$listeners = @(Get-ChildItem WSMan:\localhost\Listener -ErrorAction SilentlyContinue)
foreach ($l in $listeners) {
    Remove-Item -Path $l.PSPath -Recurse -Force
}
Write-Host ("2. {0} WinRM listener(s) deleted" -f $listeners.Count)

# 3. The firewall exception disabled
$rules = @(Get-NetFirewallRule -Group '@FirewallAPI.dll,-30267' -ErrorAction SilentlyContinue)
if ($rules.Count -eq 0) {
    $rules = @(Get-NetFirewallRule -DisplayGroup 'Windows Remote Management' -ErrorAction SilentlyContinue)
}
$rules | Disable-NetFirewallRule
Write-Host ("3. {0} firewall rule(s) of Windows Remote Management disabled" -f $rules.Count)

# 4. The service stopped, its start type of before
$startType = if ($state -and $state.ServiceStartType -and $state.ServiceStartType -ne 'Automatic') { $state.ServiceStartType } else { 'Manual' }
Stop-Service WinRM -Force
Set-Service WinRM -StartupType $startType
Write-Host "4. WinRM service stopped, start type $startType"

# 5. LocalAccountTokenFilterPolicy as before
if ($state -and -not $state.TokenPolicyExists) {
    Remove-ItemProperty -Path $policyKey -Name $policyName -ErrorAction SilentlyContinue
    Write-Host "5. $policyName deleted, as before"
} else {
    $value = if ($state -and $null -ne $state.TokenPolicyValue) { [int]$state.TokenPolicyValue } else { 0 }
    New-ItemProperty -Path $policyKey -Name $policyName -Value $value -PropertyType DWord -Force | Out-Null
    Write-Host "5. $policyName = $value"
}

# 6. The networks set to Private by Enable-WinRM.ps1, back to Public
if ($state) {
    foreach ($n in $state.Networks) {
        if ($n.Category -ne 'Public') {
            continue
        }
        $now = Get-NetConnectionProfile -InterfaceIndex $n.InterfaceIndex -ErrorAction SilentlyContinue
        if ($now -and $now.NetworkCategory -ne 'Public') {
            Set-NetConnectionProfile -InterfaceIndex $n.InterfaceIndex -NetworkCategory Public
            Write-Host ("6. Network on '{0}': back to Public" -f $n.InterfaceAlias)
        }
    }
    Remove-Item -Path $stateFile -Force
    Write-Host "State file $stateFile removed"
} else {
    Write-Host '6. Network profiles left as they are'
}
Write-Host ("WinRM is off for {0}" -f $env:COMPUTERNAME)
