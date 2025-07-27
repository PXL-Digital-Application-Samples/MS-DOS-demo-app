#!/bin/sh
echo "Content-Type: application/json"
echo ""

# Change to parent directory
cd ..

# Create a temporary response file
TEMP_RESPONSE="TEMP/cgi_response.tmp"

# Call the DOS handler with the temp file
cmd /c "HANDLERS\\GETUSERS.BAT $TEMP_RESPONSE"

# Extract just the JSON body (skip HTTP headers)
if [ -f "$TEMP_RESPONSE" ]; then
    # Skip HTTP headers and output just the JSON
    tail -n +6 "$TEMP_RESPONSE"
    rm -f "$TEMP_RESPONSE"
else
    echo '{"error": "Handler failed"}'
fi
