@echo off
setlocal enabledelayedexpansion

:: PUT /users/{id} - Update user
:: %1 = user ID, %2 = body file, %3 = response file

set USER_ID=%1
set BODY_FILE=%2
set RESPONSE_FILE=%3
set USER_FILE=DATA\USER_%USER_ID%.TXT

if not exist %USER_FILE% (
    :: User not found
    set ERROR_MSG={"error": "User not found"}
    echo !ERROR_MSG!> TEMP\ERROR.JSN
    for %%F in (TEMP\ERROR.JSN) do set CONTENT_LENGTH=%%~zF
    
    echo HTTP/1.1 404 Not Found > %RESPONSE_FILE%
    echo Content-Type: application/json >> %RESPONSE_FILE%
    echo Content-Length: %CONTENT_LENGTH% >> %RESPONSE_FILE%
    echo Connection: close >> %RESPONSE_FILE%
    echo. >> %RESPONSE_FILE%
    type TEMP\ERROR.JSN >> %RESPONSE_FILE%
    del TEMP\ERROR.JSN 2>nul
    goto end
)

:: Read existing user data
for /f "tokens=*" %%L in (%USER_FILE%) do set OLD_DATA=%%L

:: Extract current values
echo %OLD_DATA% | findstr /o "name" >nul
if !errorlevel!==0 (
    for /f "tokens=3 delims=:," %%V in ("%OLD_DATA%") do (
        set CURRENT_NAME=%%V
        set CURRENT_NAME=!CURRENT_NAME:"=!
        set CURRENT_NAME=!CURRENT_NAME: =!
    )
)

echo %OLD_DATA% | findstr /o "email" >nul
if !errorlevel!==0 (
    for /f "tokens=4 delims=:,}" %%V in ("%OLD_DATA%") do (
        set CURRENT_EMAIL=%%V
        set CURRENT_EMAIL=!CURRENT_EMAIL:"=!
        set CURRENT_EMAIL=!CURRENT_EMAIL: =!
    )
)

:: Parse new values from body
set NEW_NAME=%CURRENT_NAME%
set NEW_EMAIL=%CURRENT_EMAIL%

for /f "tokens=*" %%L in (%BODY_FILE%) do (
    echo %%L | findstr /c:"\"name\"" >nul
    if !errorlevel!==0 (
        for /f "tokens=2 delims=:" %%V in ("%%L") do (
            set TEMP=%%V
            set TEMP=!TEMP:"=!
            set TEMP=!TEMP: =!
            set TEMP=!TEMP:,=!
            if not "!TEMP!"=="" set NEW_NAME=!TEMP!
        )
    )
    
    echo %%L | findstr /c:"\"email\"" >nul
    if !errorlevel!==0 (
        for /f "tokens=2 delims=:" %%V in ("%%L") do (
            set TEMP=%%V
            set TEMP=!TEMP:"=!
            set TEMP=!TEMP: =!
            set TEMP=!TEMP:,=!
            set TEMP=!TEMP:}=!
            if not "!TEMP!"=="" set NEW_EMAIL=!TEMP!
        )
    )
)

:: Update user file
echo {"id": %USER_ID%, "name": "%NEW_NAME%", "email": "%NEW_EMAIL%"} > %USER_FILE%

:: Return updated user
for %%F in (%USER_FILE%) do set CONTENT_LENGTH=%%~zF

echo HTTP/1.1 200 OK > %RESPONSE_FILE%
echo Content-Type: application/json >> %RESPONSE_FILE%
echo Content-Length: %CONTENT_LENGTH% >> %RESPONSE_FILE%
echo Connection: close >> %RESPONSE_FILE%
echo. >> %RESPONSE_FILE%
type %USER_FILE% >> %RESPONSE_FILE%

:end