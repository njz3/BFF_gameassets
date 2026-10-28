@ECHO OFF
if "%~1"=="" goto :aide
CONSOLESTATE /Min

:: The three Triforce games, in place of one .cmd a game. They differed
:: only by the Dolphin build and the disc image.
::
:: Attract-Mode passes the game through RunAltRomname.cfg, which calls
:: this script with the entry name as its argument. %~n1 drops an
:: extension if one is ever given, as the TeknoParrot launcher does.

set ROM=%~n1
if "%ROM%"=="" ( echo Usage: %~n0 ^<game^> & exit /b 1 )

:: The title BFF reads: the rom name between brackets, nothing else
TITLE [%ROM%]

CD /d "%~dp0"

:: The Dolphin build and the disc image, one block a game below
set DOLPHIN=
set ISO=
CALL :game_%ROM% 2>NUL
if not defined ISO ( echo Unknown game: %ROM% & exit /b 1 )

:: /WAIT: Attract-Mode waits for the game, and the console lives as long
:: as it so that BFF keeps the title
START /WAIT %DOLPHIN% -b -e "%ISO%"

EXIT

:: --------------------------------------------------------------------
:: One block a game
:: --------------------------------------------------------------------

:game_fzeroax
set DOLPHIN=dolphin_tri_FZero\Dolphin.exe
set ISO=F-Zero AX (Rev E).iso
goto :eof

:game_mkartagp
set DOLPHIN=dolphin_tri_MKAGP\Dolphin.exe
set ISO=Mario Kart Arcade GP (USA).iso
goto :eof

:game_mkartag2
set DOLPHIN=dolphin_tri_MKAGP\Dolphin.exe
set ISO=Mario Kart Arcade GP 2 (USA).iso
goto :eof

:aide
:: Sans argument : la syntaxe et les noms de jeu possibles, par
:: Utils\AideLanceur.ps1 (chemin normalise : les dossiers Demul ont des [ ])
for %%d in ("%~dp0..\..\Utils") do set "UTILS=%%~fd"
powershell -NoProfile -ExecutionPolicy Bypass -File "%UTILS%\AideLanceur.ps1" "%~f0"
:: Lance par un double-clic : garder la fenetre ouverte
echo %CMDCMDLINE% | find /i "%~nx0" >nul && pause
exit /b 1
