#!/bin/bash

######################################
# About: This script lists out the issues in repository of the organization
# Required: First export username and access token before running the script and provide two argument when running the script.
#           First argument : Owner name (organization or user)
#           Second argument : Repository name
# Author: Samarth Gupta
# Date: 19-06-2024
######################################

# Github API url
API_URL="https://api.github.com"

# Check if username and token are set
if [[ -z "$username" || -z "$token" ]]; then
  echo "Error: Please export 'username' and 'token' environment variables."
  exit 1
fi

# Username and permission access token
USERNAME=$username
TOKEN=$token

# Arguments
REPO_OWNER=$1
REPO_NAME=$2

# Check if REPO_OWNER and REPO_NAME is provided
if [[ -z "$REPO_OWNER" || -z "$REPO_NAME" ]]; then
  echo "Error: Please provide the organization name and repository name as an argument."
  exit 1
fi

# Function to make a GET request to Github API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list the issues in the repository
function list-issues-of-repository {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/issues"

    issues="$(github_api_get "${endpoint}" | jq -r '.[] | .title')"

    if [[ -z "$issues" ]]; then
     echo "No issue found in the ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Issue found in ${REPO_OWNER}/${REPO_NAME}."
        echo "${issues}"
    fi
}

echo "Listing the issues for ${REPO_OWNER}/${REPO_NAME}.............."
list-issues-of-repository