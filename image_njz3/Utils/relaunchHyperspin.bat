@echo on
killHyperspin.vbs
ping -n 5 127.0.0.1 >nul
start ..\Hyperspin\HyperSpin.exe /B /MIN
@echo off