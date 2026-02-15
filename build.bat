@echo off
title KP Liberation Build Tool

rem Check that Node.js is installed
where /q node
if ERRORLEVEL 1 (
    echo node is missing. Ensure it is installed. It can be downloaded from:
    echo https://nodejs.org/en/download/
    timeout 30
    exit /b
)

node "%~dp0build.js"
pause
exit /b
