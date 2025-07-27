#!/bin/sh
echo "Content-Type: application/json"
echo ""

# Debug info
echo '{"debug": "Starting", "pwd": "'$(pwd)'", "method": "'$REQUEST_METHOD'", "path": "'$PATH_INFO'"}'

# Change to parent directory
cd ..
echo '{"debug": "Changed dir", "pwd": "'$(pwd)'"}'

# Test calling GETUSERS directly
cmd.exe /c "HANDLERS\GETUSERS.BAT"
