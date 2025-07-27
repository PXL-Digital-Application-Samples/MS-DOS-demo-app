#!/bin/sh
echo "Content-Type: application/json"
echo ""

cd ..

# Get user ID from path
USER_ID=$(echo "$PATH_INFO" | sed 's|^/||')

TEMP_RESPONSE="TEMP/cgi_response.tmp"

# Call the DOS handler with user ID as parameter
cmd /c "HANDLERS\\GETUSER.BAT $USER_ID $TEMP_RESPONSE"

# Extract JSON body
if [ -f "$TEMP_RESPONSE" ]; then
    tail -n +6 "$TEMP_RESPONSE"
    rm -f "$TEMP_RESPONSE"
else
    echo '{"error": "Handler failed"}'
fi
