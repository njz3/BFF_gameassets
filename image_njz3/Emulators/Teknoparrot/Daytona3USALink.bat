@ECHO OFF
:: set the title to match the name of the batch file with
TITLE %~nx0
CONSOLESTATE /Min

set GAME=Daytona3.xml
::Copy EPROM for link cab mode
set EPROM_SRC=..\..\Games\Daytona Championship USA\Sega1\ShellData\ShellData_link.ini
set EPROM_DST=..\..\Games\Daytona Championship USA\Sega1\ShellData\ShellData.ini
XCOPY /Y /C "%EPROM_SRC%" "%EPROM_DST%"
::Start game
TeknoParrotUi.exe --profile=%GAME% --startMinimized
