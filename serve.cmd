@echo off
rem Starts a local server for the worksheets and opens the newest one.
rem Use this if the microphone is blocked when opening worksheets directly as files.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1" %*
