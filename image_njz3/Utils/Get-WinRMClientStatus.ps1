<#
.SYNOPSIS
    Says, from the development PC, whether each cabinet can be reached over
    WinRM, and what is missing when it cannot. Reads only, changes nothing.

.DESCRIPTION
        powershell -ExecutionPolicy Bypass -File .\Get-WinRMClientStatus.ps1
        powershell -ExecutionPolicy Bypass -File .\Get-WinRMClientStatus.ps1 -Cabinets Racecab2

    This PC as a client: its TrustedHosts, read from the registry when the
    WinRM service is stopped. Then for each cabinet, each on its line:
      - its name resolved;
      - TCP 5985 reachable (2 s at most);
      - Test-WSMan: WinRM answers, no credential needed;
      - in this PC's TrustedHosts;
      - its credential file, %USERPROFILE%\.<cabinet>.cred, made by
        Get-Credential | Export-Clixml - present or not, never read here
        but to connect;
      - a session: Invoke-Command, the cabinet's name and its boot time.
    Then a verdict per cabinet, with what to do first.
#>
param(
    [string[]]$Cabinets = @('Racecab1', 'Racecab2')
)
$ErrorActionPreference = 'Continue'

function Line([string]$what, [string]$value, [string]$mark) {
    # mark: OK, NO, ?? (unknown), -- (information)
    Write-Host ('  [{0}] {1,-22} {2}' -f $mark, $what, $value)
}

Write-Host ("WinRM client on {0}, {1}" -f $env:COMPUTERNAME, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))

# TrustedHosts: the WSMan drive when the service runs, else the registry
$trusted = $null
try {
    $trusted = (Get-Item WSMan:\localhost\Client\TrustedHosts -ErrorAction Stop).Value
} catch {
    $reg = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Client' -Name trusted_hosts -ErrorAction SilentlyContinue
    if ($null -ne $reg) {
        $trusted = $reg.trusted_hosts
    }
}
$trustedList = @(if ($trusted) { $trusted -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ } })
Write-Host ('  TrustedHosts: ' + $(if ($trustedList.Count) { $trustedList -join ', ' } else { 'empty' }))
$service = Get-Service WinRM -ErrorAction SilentlyContinue
if ($service) {
    Write-Host ("  WinRM service here: {0}, start {1} (a client needs no listener)" -f $service.Status, $service.StartType)
}

foreach ($cabinet in $Cabinets) {
    Write-Host ''
    Write-Host $cabinet
    $first = $null

    # The name
    $addresses = @()
    try {
        $addresses = @([System.Net.Dns]::GetHostAddresses($cabinet) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | ForEach-Object { $_.IPAddressToString })
    } catch {
    }
    Line 'Name' $(if ($addresses.Count) { $addresses -join ', ' } else { 'not resolved' }) $(if ($addresses.Count) { 'OK' } else { 'NO' })
    if (-not $addresses.Count -and -not $first) { $first = 'the name does not resolve: the cabinet is off, or not on this network - or use its IP' }

    # The port
    $open = $false
    if ($addresses.Count) {
        $tcp = New-Object System.Net.Sockets.TcpClient
        try {
            $wait = $tcp.BeginConnect($addresses[0], 5985, $null, $null)
            if ($wait.AsyncWaitHandle.WaitOne(2000) -and $tcp.Connected) { $open = $true }
        } catch {
        } finally {
            $tcp.Close()
        }
    }
    Line 'TCP 5985' $(if ($open) { 'open' } else { 'no answer' }) $(if ($open) { 'OK' } else { 'NO' })
    if (-not $open -and -not $first) { $first = 'nothing on 5985: run Enable-WinRM.ps1 on the cabinet (or its firewall, or a Public network)' }

    # WinRM answers
    $wsman = $false
    if ($open) {
        try {
            Test-WSMan -ComputerName $cabinet -ErrorAction Stop | Out-Null
            $wsman = $true
        } catch {
        }
    }
    Line 'Test-WSMan' $(if ($wsman) { 'answers' } elseif ($open) { 'no answer' } else { 'not tried' }) $(if ($wsman) { 'OK' } elseif ($open) { 'NO' } else { '??' })
    if ($open -and -not $wsman -and -not $first) { $first = 'port open but WinRM does not answer: check the service on the cabinet' }

    # TrustedHosts
    $isTrusted = $false
    foreach ($t in $trustedList) {
        if ($t -eq '*' -or $cabinet -like $t -or ($addresses | Where-Object { $_ -like $t })) { $isTrusted = $true }
    }
    Line 'In TrustedHosts' $(if ($isTrusted) { 'yes' } else { 'no' }) $(if ($isTrusted) { 'OK' } else { 'NO' })
    if (-not $isTrusted -and -not $first) { $first = ('add it, elevated: Set-Item WSMan:\localhost\Client\TrustedHosts -Value "{0}" -Concatenate -Force' -f $cabinet) }

    # The credential file
    $credFile = Join-Path $env:USERPROFILE ('.' + $cabinet.ToLowerInvariant() + '.cred')
    $hasCred = Test-Path $credFile
    Line 'Credential file' $(if ($hasCred) { $credFile } else { "none ($credFile)" }) $(if ($hasCred) { 'OK' } else { 'NO' })
    if (-not $hasCred -and -not $first) { $first = ('make it: Get-Credential -UserName "{0}\<account>" | Export-Clixml "{1}"' -f $cabinet, $credFile) }

    # A session
    $session = $false
    if ($wsman -and $isTrusted -and $hasCred) {
        try {
            $options = New-PSSessionOption -OpenTimeout 8000 -OperationTimeout 15000
            $r = Invoke-Command -ComputerName $cabinet -Credential (Import-Clixml $credFile) -SessionOption $options -ErrorAction Stop -ScriptBlock {
                '{0}, up since {1}' -f $env:COMPUTERNAME, (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToString('yyyy-MM-dd HH:mm')
            }
            $session = $true
            Line 'Session' $r 'OK'
        } catch {
            $why = $_.Exception.Message.Split([Environment]::NewLine)[0]
            Line 'Session' ('refused: ' + $why) 'NO'
            if (-not $first) { $first = 'the session is refused: the account or its password in the credential file, or LocalAccountTokenFilterPolicy on the cabinet' }
        }
    } else {
        Line 'Session' 'not tried' '??'
    }

    if ($session) {
        Write-Host '  Verdict: reachable over WinRM.'
    } else {
        Write-Host ('  Verdict: not reachable - first: ' + $first)
    }
}
