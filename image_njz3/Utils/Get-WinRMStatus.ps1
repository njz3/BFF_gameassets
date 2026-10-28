<#
.SYNOPSIS
    Says where WinRM stands on this PC: reachable from another PC or not, and
    why. Reads only, changes nothing.

.DESCRIPTION
        powershell -ExecutionPolicy Bypass -File .\Get-WinRMStatus.ps1

    Works without elevation; a few lines need an elevated PowerShell to be
    read and say so. Checked, each on its line:
      - the WinRM service: running or not, its start type;
      - Test-WSMan on this PC;
      - TCP 5985 (HTTP) and 5986 (HTTPS) listening;
      - the listeners WinRM declares;
      - the firewall's Windows Remote Management rules, and the profile of
        each network (a Public one limits WinRM to the local subnet);
      - remote PowerShell sessions allowed (Microsoft.PowerShell's
        permissions);
      - LocalAccountTokenFilterPolicy: a local administrator's rights over
        WinRM;
      - this PC as a client: its TrustedHosts;
      - the state Enable-WinRM.ps1 saved, when there is one.
    Then a verdict.
#>
$ErrorActionPreference = 'Continue'

$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

function Line([string]$what, [string]$value, [string]$mark) {
    # mark: OK, NO, ?? (unknown), -- (information)
    Write-Host ('[{0}] {1,-28} {2}' -f $mark, $what, $value)
}

Write-Host ("WinRM on {0}, {1}{2}" -f $env:COMPUTERNAME, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'),
    $(if ($admin) { ', elevated' } else { ', not elevated: some lines need an elevated PowerShell' }))
Write-Host ''

# The service
$service = Get-Service WinRM -ErrorAction SilentlyContinue
$serviceOn = $false
if ($null -eq $service) {
    Line 'Service' 'not found' 'NO'
} else {
    $serviceOn = ($service.Status -eq 'Running')
    Line 'Service' ("{0}, start {1}" -f $service.Status, $service.StartType) $(if ($serviceOn) { 'OK' } else { 'NO' })
}

# Test-WSMan
$answers = $false
try {
    Test-WSMan -ErrorAction Stop | Out-Null
    $answers = $true
    Line 'Test-WSMan (this PC)' 'answers' 'OK'
} catch {
    Line 'Test-WSMan (this PC)' 'no answer' 'NO'
}

# The ports
$listening = @(Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in 5985, 5986 })
$ports = @($listening | ForEach-Object { $_.LocalPort } | Sort-Object -Unique)
Line 'TCP listening' $(if ($ports.Count) { ($ports -join ', ') } else { 'neither 5985 nor 5986' }) $(if ($ports.Count) { 'OK' } else { 'NO' })

# The listeners
$listeners = @()
try {
    $listeners = @(Get-ChildItem WSMan:\localhost\Listener -ErrorAction Stop | ForEach-Object { $_.Keys -join ' ' })
    Line 'Listeners' $(if ($listeners.Count) { $listeners -join '; ' } else { 'none' }) $(if ($listeners.Count) { 'OK' } else { 'NO' })
} catch {
    Line 'Listeners' $(if (-not $serviceOn) { 'unreadable, the service is not running' } else { 'unreadable (needs elevation)' }) '??'
}

# The firewall and the networks
$rules = @(Get-NetFirewallRule -Group '@FirewallAPI.dll,-30267' -ErrorAction SilentlyContinue |
           Where-Object { $_.Direction -eq 'Inbound' })
$enabled = @($rules | Where-Object { $_.Enabled -eq 'True' })
if ($rules.Count -eq 0) {
    Line 'Firewall rules' 'none found' '??'
} else {
    $profiles = @($enabled | ForEach-Object { [string]$_.Profile } | Sort-Object -Unique)
    Line 'Firewall rules' ("{0} of {1} inbound enabled{2}" -f $enabled.Count, $rules.Count,
        $(if ($profiles.Count) { ', profiles ' + ($profiles -join ' / ') } else { '' })) $(if ($enabled.Count) { 'OK' } else { 'NO' })
}
$networks = @(Get-NetConnectionProfile -ErrorAction SilentlyContinue)
$public = @($networks | Where-Object { $_.NetworkCategory -eq 'Public' })
foreach ($n in $networks) {
    Line ('Network ' + $n.InterfaceAlias) ("{0} ({1})" -f $n.NetworkCategory, $n.Name) $(if ($n.NetworkCategory -eq 'Public') { 'NO' } else { 'OK' })
}

# Remote sessions
$sessions = $null
if ($admin) {
    try {
        $config = Get-PSSessionConfiguration -Name Microsoft.PowerShell -ErrorAction Stop
        $denied = ($config.Permission -match 'NT AUTHORITY\\NETWORK AccessDenied')
        $sessions = -not $denied
        Line 'Remote sessions' $(if ($sessions) { 'allowed' } else { 'refused (NETWORK AccessDenied)' }) $(if ($sessions) { 'OK' } else { 'NO' })
    } catch {
        Line 'Remote sessions' 'unreadable, the service is not running' '??'
    }
} else {
    Line 'Remote sessions' 'unreadable (needs elevation)' '??'
}

# A local administrator's rights over WinRM
$policy = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name LocalAccountTokenFilterPolicy -ErrorAction SilentlyContinue
if ($null -eq $policy) {
    Line 'LocalAccountTokenFilter' 'absent: a local admin connects without its rights' '--'
} else {
    $value = [int]$policy.LocalAccountTokenFilterPolicy
    Line 'LocalAccountTokenFilter' ("{0}{1}" -f $value, $(if ($value -eq 1) { ': a local admin keeps its rights' } else { ': a local admin connects without its rights' })) '--'
}

# This PC as a client: the WSMan drive, else the registry
$trusted = $null
$readable = $true
try {
    $trusted = (Get-Item WSMan:\localhost\Client\TrustedHosts -ErrorAction Stop).Value
} catch {
    $reg = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Client' -Name trusted_hosts -ErrorAction SilentlyContinue
    if ($null -ne $reg) { $trusted = $reg.trusted_hosts } else { $readable = $false }
}
if ($readable) {
    Line 'TrustedHosts (as client)' $(if ($trusted) { $trusted } else { 'empty' }) '--'
} else {
    Line 'TrustedHosts (as client)' 'unreadable' '??'
}

# Enable-WinRM.ps1's state
$stateFile = Join-Path $env:ProgramData 'BFF-WinRM\state.json'
if (Test-Path $stateFile) {
    $saved = (Get-Content -Path $stateFile -Raw | ConvertFrom-Json).Saved
    Line 'Enable-WinRM.ps1' ("ran, state of before saved {0}" -f $saved) '--'
} else {
    Line 'Enable-WinRM.ps1' 'no saved state' '--'
}

# The verdict
Write-Host ''
$reachable = $serviceOn -and $answers -and ($ports -contains 5985 -or $ports -contains 5986) -and ($enabled.Count -gt 0)
if ($reachable -and ($sessions -ne $false)) {
    if ($public.Count) {
        Write-Host 'Verdict: WinRM is ON, but a network is Public: other PCs reach it from the local subnet only.'
    } elseif ($null -eq $sessions) {
        Write-Host 'Verdict: WinRM is ON (remote sessions not checked: run elevated to see them).'
    } else {
        Write-Host 'Verdict: WinRM is ON: other PCs can connect.'
    }
} elseif ($serviceOn) {
    Write-Host 'Verdict: WinRM is PARTLY on: the service runs, but see the NO lines above.'
} else {
    Write-Host 'Verdict: WinRM is OFF.'
}
