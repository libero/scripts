#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 REPOSITORY MESSAGE"
    echo "Example: $0 environments \"Update Browser to 123456\""
    echo "Depends on a TRAVIS_TOKEN environment variable"
    exit 1
fi

repository="$1"
message="$2"

body='{
    "request": {
        "branch": "master",
        "message": "'"$message"'"
    }
}'

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token $TRAVIS_TOKEN" \
   -d "$body" \
   "https://api.travis-ci.com/repo/libero%2F${repository}/requests"
