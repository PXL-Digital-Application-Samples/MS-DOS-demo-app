#!/bin/sh
echo "Content-Type: application/json"
echo ""

# Simple test to see if we can call DOS batch files
cd ..

# Test if we can execute a DOS command
echo '{"test": "Starting DOS test"}'
cmd.exe /c "echo {\"dos_response\": \"Hello from DOS\", \"current_dir\": \"%CD%\"}"
