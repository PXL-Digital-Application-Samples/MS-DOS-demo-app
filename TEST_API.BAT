@echo off
echo ========================================
echo DOS REST API - Comprehensive Test Suite
echo ========================================
echo.

set BASE_URL=http://localhost:9000/cgi-bin
set NEW_USER_JSON={"name":"TestUser","email":"test@example.com"}
set UPDATE_USER_JSON={"name":"UpdatedUser","email":"updated@example.com"}

echo Testing server availability...
curl -s %BASE_URL%/users > nul
if errorlevel 1 (
    echo ERROR: Server not running! Please start the server first.
    echo Run: SERVER.BAT
    pause
    exit /b 1
)
echo ✓ Server is running
echo.

echo ========================================
echo 1. Testing GET /cgi-bin/users
echo ========================================
curl -s %BASE_URL%/users
echo.
echo.

echo ========================================
echo 2. Testing GET /cgi-bin/user/1
echo ========================================
curl -s %BASE_URL%/user/1
echo.
echo.

echo ========================================
echo 3. Testing POST /cgi-bin/users (Create)
echo ========================================
echo Creating new user...
curl -s -X POST -H "Content-Type: application/json" -d "{\"name\":\"TestUser\",\"email\":\"test@example.com\"}" %BASE_URL%/users
echo.
echo.

echo ========================================
echo 4. Testing GET /cgi-bin/users (After Create)
echo ========================================
curl -s %BASE_URL%/users
echo.
echo.

echo ========================================
echo 5. Testing GET /cgi-bin/user/5 (New User)
echo ========================================
curl -s %BASE_URL%/user/5
echo.
echo.

echo ========================================
echo 6. Testing PUT /cgi-bin/user/1 (Update)
echo ========================================
echo Updating user 1...
curl -s -X PUT -H "Content-Type: application/json" -d "{\"name\":\"UpdatedAlice\",\"email\":\"updated@example.com\"}" %BASE_URL%/user/1
echo.
echo.

echo ========================================
echo 7. Testing GET /cgi-bin/user/1 (After Update)
echo ========================================
curl -s %BASE_URL%/user/1
echo.
echo.

echo ========================================
echo 8. Testing DELETE /cgi-bin/user/5
echo ========================================
curl -s -X DELETE %BASE_URL%/user/5
echo.
echo.

echo ========================================
echo 9. Testing GET /cgi-bin/users (After Delete)
echo ========================================
curl -s %BASE_URL%/users
echo.
echo.

echo ========================================
echo 10. Testing Error Cases
echo ========================================
echo.
echo Testing 404 - Non-existent user:
curl -s %BASE_URL%/user/999
echo.
echo.

echo Testing 405 - Invalid method:
curl -s -X PATCH %BASE_URL%/users
echo.
echo.

echo ========================================
echo Test Suite Complete!
echo ========================================
echo.
echo All basic CRUD operations have been tested.
echo Check the output above for any errors.
echo.
pause
