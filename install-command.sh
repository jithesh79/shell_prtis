#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run this Script by using root user"
    exit 1
else
    echo "script running with root user"
fi

dnf list installed mysql

if [ $? -ne 0 ]
then
    echo "MySql is not installed.....go to install it"
    dnf install mysql -y
    if [ $? -eq 0 ]
    then
        echo "Installing MySQL......SUCCESs"
    else
        echo " Installing MySQL ......FAILUER"
        exit 1
    fi

else
    echo "MySQL is alredy installed..Noting to do"

fi
