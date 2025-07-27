#!/bin/sh
echo "Content-Type: application/json"
echo ""
echo '{"message": "Hello from CGI!", "method": "'$REQUEST_METHOD'", "path": "'$PATH_INFO'", "query": "'$QUERY_STRING'"}'
