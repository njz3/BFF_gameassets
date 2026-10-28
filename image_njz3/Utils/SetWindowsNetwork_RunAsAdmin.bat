@echo off
setlocal enabledelayedexpansion
::color 0A
title WINDOWS NETWORK CONFIG for RACECAB v1.0 (by Tibal)

::============================================================
::  WINDOWS NETWORK CONFIG for RACECAB
::  Version : v1.0
::  Build   : 2025-11-05
::  Author  : Tibal
::============================================================
echo ============================================================
echo   WINDOWS NETWORK CONFIG for RACECAB
echo   Version : v1.0
echo   Build   : 2025-11-05
echo   by Tibal (AI Powered)
echo ============================================================
echo.

::--------------------------------------------
:: PATHS AND CONFIG
::--------------------------------------------
set "NETSH_DIR=C:\Racecab\Utils\Netsh"
set "LOG_FILE=%NETSH_DIR%\LastAppliedCab.txt"

:: Ensure Netsh folder exists
if not exist "%NETSH_DIR%" (
    echo Creating missing folder: %NETSH_DIR%
    mkdir "%NETSH_DIR%"
)

::--------------------------------------------
:: DETECT ACTIVE INTERFACE
::--------------------------------------------
echo ===== Detecting active network interfaces =====
set "NETIF="

for /f "skip=3 tokens=1,2,3,*" %%a in ('netsh interface show interface') do (
    set "ADMIN=%%a"
    set "STATE=%%b"
    set "TYPE=%%c"
    set "NAME=%%d"
    echo Checking: %%a %%b %%c %%d
    echo !STATE! | find /I "connect" >nul
    if !errorlevel! equ 0 (
        set "NETIF=!NAME!"
    )
)

if not defined NETIF (
    echo [X] No connected interface found.
    pause
    exit /b
)

:: Trim spaces
for /f "tokens=* delims= " %%A in ("!NETIF!") do set "NETIF=%%A"
:trimloop
if "!NETIF:~-1!"==" " set "NETIF=!NETIF:~0,-1!" & goto :trimloop

echo.
echo [OK] Active network interface detected: "!NETIF!"
echo.

::--------------------------------------------
:: SHOW LAST CONFIG
::--------------------------------------------
if exist "%LOG_FILE%" (
    echo Last configuration applied:
    type "%LOG_FILE%"
    echo.
)

goto MENU


::--------------------------------------------
:: BACKUP CURRENT CONFIG
::--------------------------------------------
:BACKUP_CONFIG
cls
echo ============================================
echo BACKUP CURRENT NETWORK CONFIGURATION
echo ============================================
echo Creating backup...
setlocal enabledelayedexpansion

set "BACKUP_DIR=%NETSH_DIR%\Backups"
if not exist "!BACKUP_DIR!" mkdir "!BACKUP_DIR!" >nul 2>&1

for /f "tokens=1-3 delims=/ " %%a in ("%DATE%") do set "DD=%%a" & set "MM=%%b" & set "YY=%%c"
for /f "tokens=1-2 delims=:," %%h in ("%TIME%") do set "HH=%%h" & set "MN=%%i"
set "TS=!YY!-!MM!-!DD!_!HH!-!MN!"
set "BACKUP_FILE=!BACKUP_DIR!\Backup_!TS!.txt"

echo Saving to "!BACKUP_FILE!"
netsh interface ip show config > "!BACKUP_FILE!" 2>nul

if exist "!BACKUP_FILE!" (
    echo [OK] Backup saved successfully: "!BACKUP_FILE!"
) else (
    echo [X] Backup failed - check folder permissions or path.
)
endlocal
echo.
pause
cls
goto MENU


::--------------------------------------------
:: RESTORE CONFIG
::--------------------------------------------
:RESTORE_BACKUP
cls
echo ============================================
echo RESTORE NETWORK CONFIGURATION
echo ============================================

set "BACKUP_DIR=%NETSH_DIR%\Backups"
if not exist "%BACKUP_DIR%" (
    echo [X] No backup directory found at "%BACKUP_DIR%".
    pause
    cls
    goto MENU
)

echo Available backup files:
echo --------------------------------------------
dir /b /o-d "%BACKUP_DIR%\Backup_*.txt"
echo --------------------------------------------
set /p RESTORE_FILE="Enter backup filename to restore (or Q to cancel): "

if /I "%RESTORE_FILE%"=="Q" goto MENU

set "FULL_RESTORE_FILE=%BACKUP_DIR%\%RESTORE_FILE%"
if not exist "%FULL_RESTORE_FILE%" (
    echo [X] File not found: "%FULL_RESTORE_FILE%"
    pause
    cls
    goto MENU
)

echo.
echo Applying configuration from "%RESTORE_FILE%"...
echo --------------------------------------------

echo.
echo Backup content:
echo --------------------------------------------
type "%FULL_RESTORE_FILE%"
echo --------------------------------------------

echo.
echo Current IP configuration (for comparison):
echo --------------------------------------------
ipconfig /all | findstr /I "IPv4 DHCP DNS Gateway Interface"
echo --------------------------------------------

echo.
set /p OPEN_GUI="Do you want to open Windows IPv4 settings to manually restore this configuration (Y/N)? "
if /I "%OPEN_GUI%"=="Y" goto OPEN_IPV4_GUIDE

goto RESTORE_DONE

:OPEN_IPV4_GUIDE
echo.
echo Opening Windows network connections panel...
start ncpa.cpl
echo.
echo   In the window that opens:
echo    1. Right-click on "!NETIF!"
echo    2. Select "Properties"
echo    3. Double-click on 'Internet Protocol Version 4 (TCP/IPv4)'
echo    4. Adjust IP / DNS as per the backup shown above.
echo.
echo The command window will remain open in the background.
pause
goto RESTORE_DONE

:RESTORE_DONE
echo.
echo Done. Returning to main menu...
pause
cls
goto MENU


::--------------------------------------------
:: CLEAN NETWORK STACK (manual menu option)
::--------------------------------------------
:CLEAN_NETWORK
cls
echo ============================================
echo CLEAN / RESET NETWORK STACK
echo ============================================
echo This will reset the Windows network stack:
echo   - Winsock catalog
echo   - IP configuration
echo   - DNS cache
echo.
echo Use this only if you see DNS errors such as:
echo   "The DNS server is not responding"
echo   "DNS server not found"
echo.
echo You may need to reboot afterwards.
echo.
set /p CONFIRM_CLEAN="Do you really want to clean the network stack (Y/N)? "
if /I "%CONFIRM_CLEAN%"=="Y" (
    echo.
    echo Resetting network components...
    netsh winsock reset
    netsh int ip reset
    ipconfig /flushdns
    echo.
    echo [OK] Network stack has been reset.
    echo Please reboot your computer before reapplying a configuration.
) else (
    echo Operation cancelled.
)
echo.
pause
cls
goto MENU


::--------------------------------------------
:: MENU SELECTION
::--------------------------------------------
:MENU
echo ============================================
echo Choose a configuration to apply:
echo --------------------------------------------
echo  [B] Backup current configuration
echo  [R] Restore a saved configuration
echo  [0] DHCP (Automatic)
echo  [1] Cab1
echo  [2] Cab2
echo  [3] Cab3
echo  [4] Cab4
echo  [5] Cab5
echo  [6] Cab6
echo  [7] Cab7
echo  [8] Cab8
echo  [S] Show current network config
echo  [C] Clean / Reset network stack
echo  [Q] Quit
echo --------------------------------------------
set /p CHOICE="Your choice: "

if /I "%CHOICE%"=="Q" exit /b
if /I "%CHOICE%"=="B" goto BACKUP_CONFIG
if /I "%CHOICE%"=="R" goto RESTORE_BACKUP
if /I "%CHOICE%"=="S" (
    cls
    goto SHOW_CURRENT_CONFIG
)
if /I "%CHOICE%"=="C" goto CLEAN_NETWORK


::--------------------------------------------
:: APPLY CONFIG
::--------------------------------------------
cls
if "%CHOICE%"=="0" (
    echo Applying configuration: DHCP (Auto)
    netsh interface ipv4 set address name="!NETIF!" source=dhcp
    netsh interface ipv4 set dnsservers name="!NETIF!" source=dhcp
) else (
    set "CONFIG_FILE=%NETSH_DIR%\WinNetworkConfig_Cab%CHOICE%.txt"
    if not exist "%CONFIG_FILE%" (
        echo [X] Configuration file not found: %CONFIG_FILE%
        pause
        exit /b
    )
    echo Applying configuration: WinNetworkConfig_Cab%CHOICE%
    for /f "usebackq tokens=* delims=" %%L in ("%CONFIG_FILE%") do (
        set "LINE=%%L"
        if not "!LINE!"=="" if /I "!LINE:~0,1!" neq "#" (
            echo Running: !LINE!
            cmd /c "!LINE!"
        )
    )
)

::--------------------------------------------
:: LOG RESULT
::--------------------------------------------
(
    echo Cab: %CHOICE%
    echo File: %CONFIG_FILE%
    echo Interface: !NETIF!
    echo Date: %DATE%, Time: %TIME%
) > "%LOG_FILE%"
echo.
echo [OK] Configuration applied and logged.


::--------------------------------------------
:: SHOW CURRENT CONFIG
::--------------------------------------------
echo.
set /p SHOWIP="Show current IP info (Y/N)? "
if /I "%SHOWIP%"=="Y" (
:SHOW_CURRENT_CONFIG
    echo.
    echo ===== CURRENT NETWORK CONFIG: !NETIF! =====
    echo.

    powershell -NoProfile -Command ^
        "$pattern = '(?i)(IPv4|DHCP Enabled|DHCP Activ|!NETIF!)';" ^
        "ipconfig /all | ForEach-Object {" ^
        "if ($_ -match $pattern) { Write-Host $_ -ForegroundColor Blue } else { Write-Host $_ } }"

    echo ============================================
)

echo.
pause
cls
goto MENU
exit /b
