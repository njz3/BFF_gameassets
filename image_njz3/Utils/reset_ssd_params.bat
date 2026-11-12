:: Remet la borne a zero avant de cloner son disque (IMAGE.md, 2.14).
:: A lancer en administrateur, avec la cabine et le script de resolution :
::   reset_ssd_params.bat -Cabine _link_cab1 -Video SetLCD_1920x1080p -WhatIf
::   reset_ssd_params.bat -Cabine _link_cab1 -Video SetLCD_1920x1080p
:: Ferme BFF et AttractPlus, puis passe la main a Reset-Cabinet.ps1, qui dit
:: ce qu'il va effacer et demande confirmation avant tout effacement (licences
:: de BFF comprises).
@ECHO ON
CD /d "%~dp0"
killProcess.vbs "BackForceFeeder.exe"
CALL killAttractModePlus.bat

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Reset-Cabinet.ps1" %*
PAUSE
