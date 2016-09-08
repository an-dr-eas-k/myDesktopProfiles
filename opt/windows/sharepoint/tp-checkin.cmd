@echo off
rem put this file to your send-to explorer folder
rem (= the batch file) but with the extension ".ps1"
set PSScript=U:\My Documents\bin\tp-function.ps1
set args=%1
:More
shift
if '%1'=='' goto Done
set args=%args%, %1
goto More
:Done
powershell.exe -NoExit -Command "& '%PSScript%' checkin '%args%'"
