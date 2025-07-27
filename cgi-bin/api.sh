#!/bin/sh
# CGI bridge to DOS REST API
echo "Content-Type: application/json"
echo ""

# Change to the DOS project directory (parent of cgi-bin)
cd ..

# Get HTTP method and path
METHOD="$REQUEST_METHOD"
PATH="$PATH_INFO"

# Simple routing based on path
case "$PATH" in
    "/users")
        if [ "$METHOD" = "GET" ]; then
            cmd.exe /c "HANDLERS\GETUSERS.BAT"
        elif [ "$METHOD" = "POST" ]; then
            # For POST, we need to handle the request body
            cat > TEMP/request_body.txt
            cmd.exe /c "HANDLERS\CREATUSR.BAT"
        else
            cmd.exe /c "HANDLERS\MTHDNTAL.BAT"
        fi
        ;;
    "/users/"*)
        USER_ID=$(echo "$PATH" | sed 's|^/users/||')
        if [ "$METHOD" = "GET" ]; then
            echo "$USER_ID" > TEMP/user_id.txt
            cmd.exe /c "HANDLERS\GETUSER.BAT"
        elif [ "$METHOD" = "PUT" ]; then
            echo "$USER_ID" > TEMP/user_id.txt
            cat > TEMP/request_body.txt
            cmd.exe /c "HANDLERS\UPDTUSER.BAT"
        elif [ "$METHOD" = "DELETE" ]; then
            echo "$USER_ID" > TEMP/user_id.txt
            cmd.exe /c "HANDLERS\DELUSER.BAT"
        else
            cmd.exe /c "HANDLERS\MTHDNTAL.BAT"
        fi
        ;;
    *)
        cmd.exe /c "HANDLERS\NOTFOUND.BAT"
        ;;
esac
