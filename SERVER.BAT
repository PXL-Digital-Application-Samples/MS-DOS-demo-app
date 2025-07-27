@echo off
setlocal enabledelayedexpansion

:: Flask User Management API - DOS Batch Implementation
:: Main server using netcat (nc.exe)

set PORT=5000
set DATA_DIR=DATA
set TEMP_DIR=TEMP

:: Create directories if they don't exist
if not exist %DATA_DIR% mkdir %DATA_DIR%
if not exist %TEMP_DIR% mkdir %TEMP_DIR%

:: Initialize database with seed data
call INIT_DB.BAT

echo Flask User Management API (Batch Version)
echo =========================================
echo Server starting on port %PORT%...
echo.
echo Available endpoints:
echo   GET    /users      - List all users
echo   GET    /users/{id} - Get user by ID
echo   POST   /users      - Create new user
echo   PUT    /users/{id} - Update user
echo   DELETE /users/{id} - Delete user
echo.
echo Press Ctrl+C to stop server
echo =========================================

:server_loop
:: HTTP server using busybox nc - DOS compatible approach
echo.
echo Waiting for request on port %PORT%...

:: Create temp files
set REQUEST_FILE=%TEMP_DIR%\REQ_%random%.TXT
set RESPONSE_FILE=%TEMP_DIR%\RSP_%random%.TXT

:: Use mTCP nc for DOS networking
nc -l -p %PORT% > %REQUEST_FILE%

:: Process the request
call PROCESS.BAT %REQUEST_FILE% %RESPONSE_FILE%

:: Send the response back
type %RESPONSE_FILE% | nc -l -p %PORT%

:: Clean up
del %REQUEST_FILE% 2>nul
del %RESPONSE_FILE% 2>nul

goto server_loop