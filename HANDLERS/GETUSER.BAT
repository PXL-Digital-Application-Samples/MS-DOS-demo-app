@echo off
setlocal enabledelayedexpansion

:: GET /users/{id} - Return specific user
:: %1 = user ID, %2 = response file

set USER_ID=%1
set RESPONSE_FILE=%2
set USER_FILE=DATA\USER_%USER_ID%.TXT

if exist %USER_FILE% (
    :: User found
    for %%F in (%USER_FILE%) do set CONTENT_LENGTH=%%~zF
    
    echo HTTP/1.1 200 OK > %RESPONSE_FILE%
    echo Content-Type: application/json >> %RESPONSE_FILE%
    echo Content-Length: %CONTENT_LENGTH% >> %RESPONSE_FILE%
    echo Connection: close >> %RESPONSE_FILE%
    echo. >> %RESPONSE_FILE%
    type %USER_FILE% >> %RESPONSE_FILE%
) else (
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
)