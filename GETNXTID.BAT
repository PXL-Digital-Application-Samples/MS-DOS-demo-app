@echo off
setlocal enabledelayedexpansion

:: Get next available user ID
:: %1 = variable name to store result

set MAX_ID=0

:: Find highest existing ID
for /f "tokens=*" %%f in ('dir /b DATA\USER_*.TXT 2^>nul') do (
    :: Extract ID from filename
    set FILENAME=%%f
    set FILENAME=!FILENAME:USER_=!
    set FILENAME=!FILENAME:.TXT=!
    
    if !FILENAME! GTR !MAX_ID! set MAX_ID=!FILENAME!
)

:: Next ID is max + 1
set /a NEXT_ID=%MAX_ID%+1

:: Return value in specified variable
endlocal & set %1=%NEXT_ID%