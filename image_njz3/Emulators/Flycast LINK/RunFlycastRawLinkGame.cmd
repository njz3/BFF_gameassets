@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

::set ROM=first argument
set ROM=%~1
:: set the title with the _raw suffix : BFF lit ce nom entre crochets
:: pour choisir son profil, et bascule en mode brut sur ce suffixe
TITLE [%ROM%_raw]

:: Change current directory to the folder that contains this file
CD /d "%~dp0"


set GAME=..\MameRoms\%ROM%.zip
:: Lunch emulator, without waiting: a multiboard game (F355) opens one more
:: flycast window a board, and Esc or Alt+F4 only closes the one in front
:: Options before the game: Flycast takes the first argument that is not an option as the game and ignores the rest of the command line
:: Full screen forced at each launch (-config is never saved); the rest,
:: NetworkOutput for BFF included, comes from emu.cfg (Build-Config template)
:: Dossier d ecriture (bornes sous UWF) : Saves\flycast<CAB_ID>, que Flycast
:: amorce lui-meme au premier lancement depuis emu.cfg et data en place
:: (ceux de la cabine de cette machine, poses par Build-Config)
CALL "..\..\Utils\set_cab_id.bat"
set VARIANTE=%CAB_ID:~1%
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
set ECRITURE=
if defined WRITEDIR_ROOT set ECRITURE=--write-dir "%WRITEDIR_ROOT%\flycast_%VARIANTE%"
start "" flycast.exe -config window:fullscreen=yes %ECRITURE% %GAME%

:: Wait for flycast to be up (20 s at most)
set /a TRIES=0
:waitup
ping -n 2 127.0.0.1 >nul
call :count
if %N% GTR 0 goto running
set /a TRIES+=1
if %TRIES% LSS 20 goto waitup
goto done

:: Then until one of its windows is closed: the highest count seen is the
:: number of boards, and any fewer means the player quit
:running
set MAX=%N%
:watch
ping -n 2 127.0.0.1 >nul
call :count
if %N% GTR %MAX% set MAX=%N%
if %N% EQU 0 goto done
if %N% LSS %MAX% goto done
goto watch

:done
:: Kill remaining processes for multiboard games (F355), silently: a board
:: closing by itself meanwhile must not pop up an error on the cabinet
taskkill /F /IM flycast.exe >nul 2>&1

:: leave caller
EXIT

:: N = how many flycast.exe run
:count
set N=0
for /f %%a in ('tasklist /fi "imagename eq flycast.exe" /nh ^| find /c /i "flycast.exe"') do set N=%%a
exit /b

:aide
:: Sans argument : la syntaxe et les noms de jeu possibles, par
:: Utils\AideLanceur.ps1 (chemin normalise : les dossiers Demul ont des [ ])
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
:: Lance par un double-clic : garder la fenetre ouverte
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
