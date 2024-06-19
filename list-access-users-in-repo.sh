#!/bin/bash

######################################
# About: This script is about to list out the users that are currently read access to a particular repository
# Required: First export username and access token before run the script and when ren the script please give 2 arguments
#           First argument : Repository owner
#           Second argument : Repository name
# Author: Samarth Gupta
# Date: 19-06-2024
######################################

# Github API Url
API_URL="https://api.github.com"

# Github username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a get request to Github api
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a get request ton github api with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users to read access to a particular repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch list of collaborators in the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}."
        echo "$collaborators"
    fi
}

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}......."
list_users_with_read_access