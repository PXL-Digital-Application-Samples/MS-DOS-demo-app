#!/bin/sh
# CGI wrapper for DOS batch files
echo "Content-Type: application/json"
echo ""

# Get the requested batch file from PATH_INFO
BATCH_FILE=$(echo "$PATH_INFO" | sed 's|^/cgi-bin/||' | sed 's|\.sh$|.BAT|')

# Execute the batch file and capture output
if [ -f "../$BATCH_FILE" ]; then
    # Call the actual DOS batch file
    cd ..
    cmd.exe /c "$BATCH_FILE"
else
    echo '{"error": "Batch file not found", "requested": "'$BATCH_FILE'"}'
fi
