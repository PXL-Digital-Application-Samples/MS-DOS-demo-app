@echo off
setlocal enabledelayedexpansion

:: Return 405 Method Not Allowed
:: %1 = response file

set RESPONSE_FILE=%1
set ERROR_MSG={"error": "Method not allowed"}

echo %ERROR_MSG%> TEMP\ERROR.JSN
for %%F in (TEMP\ERROR.JSN) do set CONTENT_LENGTH=%%~zF

echo HTTP/1.1 405 Method Not Allowed > %RESPONSE_FILE%
echo Content-Type: application/json >> %RESPONSE_FILE%
echo Content-Length: %CONTENT_LENGTH% >> %RESPONSE_FILE%
echo Connection: close >> %RESPONSE_FILE%
echo Allow: GET, POST, PUT, DELETE >> %RESPONSE_FILE%
echo. >> %RESPONSE_FILE%
type TEMP\ERROR.JSN >> %RESPONSE_FILE%

del TEMP\ERROR.JSN 2>nul