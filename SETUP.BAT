@echo off
echo Flask User Management API (Batch Version) - Setup
echo ================================================
echo.

:: Create required directories
echo Creating directories...
if not exist DATA mkdir DATA
if not exist TEMP mkdir TEMP
if not exist HANDLERS mkdir HANDLERS

echo.
echo Checking for netcat (ncat.exe)...
where ncat >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: netcat (ncat.exe) not found!
    echo.
    echo Please download netcat for Windows from:
    echo https://nmap.org/ncat/
    echo.
    echo Or install via Scoop:
    echo   scoop install nmap
    echo.
    echo After installing, add ncat.exe to your PATH or copy it to this directory.
    echo.
    pause
    exit /b 1
)

echo Netcat found!
echo.

echo Checking for curl (for testing)...
where curl >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo WARNING: curl not found!
    echo The server will work, but CLIENT.BAT requires curl for testing.
    echo Windows 10+ includes curl by default.
    echo.
)

echo.
echo Setup complete!
echo.
echo To start the server:
echo   SERVER.BAT
echo.
echo To test the API:
echo   CLIENT.BAT
echo.
pause