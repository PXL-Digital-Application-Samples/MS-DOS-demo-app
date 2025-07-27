@echo off
setlocal enabledelayedexpansion

:: DOS REST API Server - Using busybox httpd with CGI
:: Serves DOS batch API handlers through CGI bridge

set PORT=9000
set DATA_DIR=DATA
set TEMP_DIR=TEMP

:: Create directories if they don't exist
if not exist %DATA_DIR% mkdir %DATA_DIR%
if not exist %TEMP_DIR% mkdir %TEMP_DIR%

:: Initialize database with seed data
call INIT_DB.BAT

echo DOS REST API Server
echo ===================
echo Starting busybox httpd server on port %PORT%...
echo.
echo Available endpoints:
echo   GET    /cgi-bin/users      - List all users
echo   GET    /cgi-bin/user/{id}  - Get user by ID
echo   POST   /cgi-bin/users      - Create new user
echo   PUT    /cgi-bin/user/{id}  - Update user
echo   DELETE /cgi-bin/user/{id}  - Delete user
echo.
echo Server will run until stopped with Ctrl+C
echo Test with: curl http://localhost:%PORT%/cgi-bin/users
echo ===================

:: Start busybox httpd with CGI support
echo Starting server...
busybox httpd -f -p %PORT% -c httpd.conf