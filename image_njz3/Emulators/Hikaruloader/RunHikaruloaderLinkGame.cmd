:: Lance un jeu Hikaru par hikaruloader (njz3) EN LINK, a la convention de l image.
::
:: Sega Nascar et Star Wars Racer Arcade, deux bornes en anneau TCP (port
:: 1970), link verifie le 03/11/2026 entre Racecab1 et Racecab2 (Nascar).
::
:: L identite de la cabine vient de Utils\set_cab_id.bat, jamais de l adresse
:: IP du PC. Son reglage link (COMMUNICATION MODE MASTER ou SLAVE, borne
:: suivante dans l anneau) est dans link\hikaruloader.ini, produit par
:: Build-Config pour la cabine de cette machine (cabinets.csv : HIKARU_LINK,
:: HIKARU_SUIVANTE). Ce lanceur le pose dans le dossier d ecriture de la
:: cabine, Saves\hikaruloader<CAB_ID>, s il n y est pas : hikaruloader ne
:: lit que la copie de son dossier d ecriture.
::
:: Star Wars Racer Arcade veut en plus un siege different par borne (SEAT
:: NUMBER, GAME ASSIGNMENTS du menu de test), dans la NVRAM du jeu : le modele
:: de la cabine, nvram<CAB_ID>\<set>.nvram, est pose s il existe et que le
:: dossier d ecriture n en a pas encore. Nascar numerote ses bornes par
:: l anneau.
::
:: Appel : %~nx0 <set>   sgnascar ou swracer
@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

set ROM=%~1
TITLE [%ROM%]
CD /d "%~dp0"

CALL "..\..\Utils\set_cab_id.bat"
if /I "%CAB_ID%"=="_single" (
    echo Cette borne n a pas de place en link : Utils\set_cab_id.bat dit _single
    exit /b 4
)
if not exist "link\hikaruloader.ini" (
    echo Reglages link absents : link\hikaruloader.ini, lancer Utils\config\Build-Config.ps1
    exit /b 5
)
if not defined WRITEDIR_ROOT CALL "..\..\Utils\set_writedir.bat"
if not defined WRITEDIR_ROOT (
    echo Le link de hikaruloader demande le dossier d ecriture : Utils\set_writedir.bat
    exit /b 6
)
set "ECRITURE=%WRITEDIR_ROOT%\hikaruloader%CAB_ID%"

:: Amorce : l ini de la cabine, puis le modele de NVRAM du jeu s il y en a un
if not exist "%ECRITURE%\" mkdir "%ECRITURE%"
if not exist "%ECRITURE%\hikaruloader.ini" copy /Y "link\hikaruloader.ini" "%ECRITURE%\" >nul
if exist "nvram%CAB_ID%\%ROM%.nvram" if not exist "%ECRITURE%\%ROM%\nvram\%ROM%.nvram" (
    mkdir "%ECRITURE%\%ROM%\nvram" 2>nul
    copy /Y "nvram%CAB_ID%\%ROM%.nvram" "%ECRITURE%\%ROM%\nvram\" >nul
)

hikaruloader.exe -R "C:\Racecab\Emulators\MameRoms" -r %ROM% --write-dir "%ECRITURE%"

EXIT

:aide
:: Sans argument : la syntaxe, par Utils\AideLanceur.ps1
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
