#!/bin/bash

# Set the pull request number
PR_NUMBER=$(jq -r ".pull_request.number" "$GITHUB_EVENT_PATH")

# Send a GET request to the GitHub API to get the list of changed files in the pull request
FILES_CHANGED=$(curl -s "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls/$PR_NUMBER/files" | jq -r '.[] | select(.filename | endswith(".json")) | .filename')

# Print the list of changed JSON files
echo "$FILES_CHANGED"

for files in $FILES_CHANGED; do
    vacuum lint -d $files
done
