@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=f1lap

:: CAB_ID
CALL set_cab_id.bat
:: Network: LOCALPORT NEXTPORT LOCALIP NEXTIP
CALL set_cab_networkd%CAB_ID%.bat

:: Normal command
start mame.exe %GAME% -nvram_directory nvram%CAB_ID% -comm_localport %LOCALPORT% -comm_remoteport %NEXTPORT% -comm_localhost %LOCALIP% -comm_remotehost %NEXTIP%
