@echo off
setlocal enabledelayedexpansion

:: POST /users - Create new user
:: %1 = body file, %2 = response file

set BODY_FILE=%1
set RESPONSE_FILE=%2

:: Get next user ID
call GETNXTID.BAT NEXT_ID

:: Parse JSON body (simple parsing for name and email)
set NAME=
set EMAIL=

for /f "tokens=*" %%L in (%BODY_FILE%) do (
    echo %%L | findstr /c:"\"name\"" >nul
    if !errorlevel!==0 (
        for /f "tokens=2 delims=:" %%V in ("%%L") do (
            set TEMP=%%V
            :: Remove quotes and spaces
            set TEMP=!TEMP:"=!
            set TEMP=!TEMP: =!
            set TEMP=!TEMP:,=!
            set NAME=!TEMP!
        )
    )
    
    echo %%L | findstr /c:"\"email\"" >nul
    if !errorlevel!==0 (
        for /f "tokens=2 delims=:" %%V in ("%%L") do (
            set TEMP=%%V
            :: Remove quotes and spaces
            set TEMP=!TEMP:"=!
            set TEMP=!TEMP: =!
            set TEMP=!TEMP:,=!
            set TEMP=!TEMP:}=!
            set EMAIL=!TEMP!
        )
    )
)

if "%NAME%"=="" goto error
if "%EMAIL%"=="" goto error

:: Create user file
set USER_FILE=DATA\USER_%NEXT_ID%.TXT
echo {"id": %NEXT_ID%, "name": "%NAME%", "email": "%EMAIL%"} > %USER_FILE%

:: Return created user
for %%F in (%USER_FILE%) do set CONTENT_LENGTH=%%~zF

echo HTTP/1.1 201 Created > %RESPONSE_FILE%
echo Content-Type: application/json >> %RESPONSE_FILE%
echo Content-Length: %CONTENT_LENGTH% >> %RESPONSE_FILE%
echo Connection: close >> %RESPONSE_FILE%
echo. >> %RESPONSE_FILE%
type %USER_FILE% >> %RESPONSE_FILE%

goto end

:error
set ERROR_MSG={"error": "Name and email are required"}
echo %ERROR_MSG%> TEMP\ERROR.JSN
for %%F in (TEMP\ERROR.JSN) do set CONTENT_LENGTH=%%~zF

echo HTTP/1.1 400 Bad Request > %RESPONSE_FILE%
echo Content-Type: application/json >> %RESPONSE_FILE%
echo Content-Length: %CONTENT_LENGTH% >> %RESPONSE_FILE%
echo Connection: close >> %RESPONSE_FILE%
echo. >> %RESPONSE_FILE%
type TEMP\ERROR.JSN >> %RESPONSE_FILE%
del TEMP\ERROR.JSN 2>nul

:end