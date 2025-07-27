@echo off
setlocal enabledelayedexpansion

:: Process HTTP request and route to appropriate handler
:: %1 = request file, %2 = response file

set REQUEST_FILE=%1
set RESPONSE_FILE=%2

:: Parse first line of HTTP request
set /p REQUEST_LINE=<%REQUEST_FILE%

:: Extract method and path
for /f "tokens=1,2" %%a in ("%REQUEST_LINE%") do (
    set METHOD=%%a
    set PATH=%%b
)

echo Processing: %METHOD% %PATH%

:: Route based on method and path
if "%METHOD%"=="GET" (
    if "%PATH%"=="/users" (
        call HANDLERS\GETUSERS.BAT %RESPONSE_FILE%
    ) else (
        :: Check if it's /users/{id}
        echo %PATH% | C:\WINDOWS\system32\findstr.exe /r "^/users/[0-9][0-9]*$" >nul
        if !errorlevel!==0 (
            :: Extract user ID from path
            for /f "tokens=3 delims=/" %%i in ("%PATH%") do set USER_ID=%%i
            call HANDLERS\GETUSER.BAT !USER_ID! %RESPONSE_FILE%
        ) else (
            call HANDLERS\NOTFOUND.BAT %RESPONSE_FILE%
        )
    )
) else if "%METHOD%"=="POST" (
    if "%PATH%"=="/users" (
        :: Extract body from request
        call EXTRBODY.BAT %REQUEST_FILE% BODY.TMP
        call HANDLERS\CREATUSR.BAT BODY.TMP %RESPONSE_FILE%
        del BODY.TMP 2>nul
    ) else (
        call HANDLERS\NOTFOUND.BAT %RESPONSE_FILE%
    )
) else if "%METHOD%"=="PUT" (
    echo %PATH% | C:\WINDOWS\system32\findstr.exe /r "^/users/[0-9][0-9]*$" >nul
    if !errorlevel!==0 (
        for /f "tokens=3 delims=/" %%i in ("%PATH%") do set USER_ID=%%i
        call EXTRBODY.BAT %REQUEST_FILE% BODY.TMP
        call HANDLERS\UPDTUSER.BAT !USER_ID! BODY.TMP %RESPONSE_FILE%
        del BODY.TMP 2>nul
    ) else (
        call HANDLERS\NOTFOUND.BAT %RESPONSE_FILE%
    )
) else if "%METHOD%"=="DELETE" (
    echo %PATH% | C:\WINDOWS\system32\findstr.exe /r "^/users/[0-9][0-9]*$" >nul
    if !errorlevel!==0 (
        for /f "tokens=3 delims=/" %%i in ("%PATH%") do set USER_ID=%%i
        call HANDLERS\DELUSER.BAT !USER_ID! %RESPONSE_FILE%
    ) else (
        call HANDLERS\NOTFOUND.BAT %RESPONSE_FILE%
    )
) else (
    call HANDLERS\MTHDNTAL.BAT %RESPONSE_FILE%
)