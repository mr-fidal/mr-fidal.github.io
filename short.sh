#!/bin/bash

GITHUB_USER="mrfidal"
REPO_NAME="mrfidal.github.io"
FILE_NAME="short.sh"
BRANCH="main"
RAW_FILE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/$BRANCH/$FILE_NAME"

check_localhost() {
    response=$(curl --write-out "%{http_code}" --silent --output /dev/null "http://127.0.0.1:5000")
    
    if [ "$response" -eq 200 ]; then
        echo "The server is running."
        return 0
    else
        echo "Server is not running properly."
        return 1
    fi
}

check_internet() {
    response=$(curl --write-out "%{http_code}" --silent --output /dev/null "https://www.google.com")
    
    if [ "$response" -eq 200 ]; then
        echo "Internet is connected."
    else
        echo "Internet is not reachable."
    fi
}

check_file_exists() {
    response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$RAW_FILE_URL")
    
    if [ "$response" -eq 200 ]; then
        echo "File exists."
        return 0
    else
        echo "File does not exist."
        return 1
    fi
}

create_ssh_tunnel() {
    echo "Attempting to create an SSH tunnel to serveo.net..."
    ssh -R 80:localhost:5000 serveo.net
    if [ $? -ne 0 ]; then
        echo "Error while setting up SSH tunnel"
    fi
}

if check_localhost && check_file_exists; then
    check_internet
    create_ssh_tunnel
else
    echo "Either the server is not running or the file does not exist. Cannot proceed."
fi
