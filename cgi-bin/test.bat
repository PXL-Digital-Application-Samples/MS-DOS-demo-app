@echo off
echo Content-Type: application/json
echo.
echo {"message": "Hello from DOS batch via CGI!", "timestamp": "%date% %time%", "method": "%REQUEST_METHOD%"}
