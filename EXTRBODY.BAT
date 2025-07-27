@echo off
setlocal enabledelayedexpansion

:: Extract body from HTTP request
:: %1 = request file, %2 = output body file

set REQUEST_FILE=%1
set BODY_FILE=%2

:: Find empty line that separates headers from body
set BODY_START=0
set LINE_NUM=0

for /f "tokens=*" %%L in (%REQUEST_FILE%) do (
    set /a LINE_NUM+=1
    if "%%L"=="" (
        set BODY_START=!LINE_NUM!
        goto found_body
    )
)

:found_body
if %BODY_START%==0 (
    :: No body found
    echo {} > %BODY_FILE%
    goto end
)

:: Skip headers and extract body
set SKIP_LINES=%BODY_START%
set BODY_CONTENT=

for /f "skip=%SKIP_LINES% tokens=*" %%L in (%REQUEST_FILE%) do (
    if not "%%L"=="" (
        if "!BODY_CONTENT!"=="" (
            set BODY_CONTENT=%%L
        ) else (
            set BODY_CONTENT=!BODY_CONTENT! %%L
        )
    )
)

:: Write body to file
if "%BODY_CONTENT%"=="" (
    echo {} > %BODY_FILE%
) else (
    echo %BODY_CONTENT% > %BODY_FILE%
)

:end