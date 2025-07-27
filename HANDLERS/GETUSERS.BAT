@echo off
setlocal enabledelayedexpansion

:: GET /users - Return all users
:: %1 = response file

set RESPONSE_FILE=%1
set JSON_BODY=TEMP\USERS.JSN

:: Build JSON array of users
echo [ > %JSON_BODY%

set FIRST=1
for /f "tokens=*" %%f in ('dir /b DATA\USER_*.TXT 2^>nul') do (
    if !FIRST!==0 echo , >> %JSON_BODY%
    set FIRST=0
    
    :: Read user data from file
    set USER_FILE=DATA\%%f
    type !USER_FILE! >> %JSON_BODY%
)

echo ] >> %JSON_BODY%

:: Count content length
for %%F in (%JSON_BODY%) do set CONTENT_LENGTH=%%~zF

:: Write HTTP response
echo HTTP/1.1 200 OK > %RESPONSE_FILE%
echo Content-Type: application/json >> %RESPONSE_FILE%
echo Content-Length: %CONTENT_LENGTH% >> %RESPONSE_FILE%
echo Connection: close >> %RESPONSE_FILE%
echo. >> %RESPONSE_FILE%
type %JSON_BODY% >> %RESPONSE_FILE%

del %JSON_BODY% 2>nul