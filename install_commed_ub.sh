#!/bin/bash

USERID=$(id -u)

if [ "$USERID" -ne 0 ]
 then
    echo "Please run this script as root."
    exit 1
else
    echo "Script is running with root privileges."
fi

# Check if MySQL Server is installed
dpkg -s mysql &> /dev/null

if [ $? -ne 0 ]; then
    echo "MySQL is not installed. Proceeding to install..."
    apt update && apt install mysql -y
    if [ $? -eq 0 ]; then
        echo "Installing MySQL... SUCCESS"
    else
        echo "Installing MySQL... FAILURE"
        exit 1
    fi
else
    echo "MySQL is already installed. Nothing to do."
fi

