@echo off
setlocal enabledelayedexpansion

:: Initialize database with seed users

echo Initializing database...

:: Check if data already exists
if exist DATA\USER_1.TXT (
    echo Database already initialized.
    goto end
)

:: Create seed users
echo {"id": 1, "name": "Alice", "email": "alice@example.com"} > DATA\USER_1.TXT
echo {"id": 2, "name": "Bob", "email": "bob@example.com"} > DATA\USER_2.TXT
echo {"id": 3, "name": "Charlie", "email": "charlie@example.com"} > DATA\USER_3.TXT

echo Created 3 seed users.

:end