#!/bin/bash

######################################
# About: This script lists out the repositories that are currently present in the specified GitHub organization or user profile.
# Required: First export username and access token before running the script and provide one argument when running the script.
#           First argument : Owner name (organization or user)
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
OWNER_NAME=$1

# Check if OWNER_NAME is provided
if [[ -z "$OWNER_NAME" ]]; then
  echo "Error: Please provide the owner name (organization or user) as an argument."
  exit 1
fi

# Function to make a GET request to Github API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list repositories in the organization or user profile
function list_repositories {
    local endpoint="users/${OWNER_NAME}/repos"

    repositories="$(github_api_get "${endpoint}" | jq -r '.[] | .name')"

    if [[ -z "$repositories" ]]; then
        echo "No repositories found for ${OWNER_NAME}."
    else 
        echo "Repositories for ${OWNER_NAME}:"
        echo "$repositories"
    fi
}

echo "Listing repositories for ${OWNER_NAME}..."
list_repositories
