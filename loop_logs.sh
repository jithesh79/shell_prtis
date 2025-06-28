#!/bin/bash

USERID=$(id -u)
R="\e[31m"   # Red
G="\e[32m"   # Green
Y="\e[33m"   # Yellow
N="\e[0m"    # Reset
LOGS_FOLDER="/var/logs/shellscript.sh"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python" "nginx" "java")

mkdir -p $LOGS_FOLDER  

echo "Script Starting date: $(date)" >> $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this script as root user $N" | tee -a $LOG_FILE
    exit 1
else
    echo "You are running as root user" >> $LOG_FILE
fi

VALIDATE(){
    if [ $1 -eq 0 ]; then
        echo -e "Installing $2...$G SUCCESS $N" >> $LOG_FILE
    else
        echo -e "Installing $2...$R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

for package in ${PACKAGES[@]}; do
    dnf list installed $package >> $LOG_FILE
    if [ $? -ne 0 ]; then
        echo "$package is not installed... Installing now" | tee -a $LOG_FILE
        dnf install $package -y | tee -a $LOG_FILE
        VALIDATE $? "$package"
    else
        echo -e "Nothing to do... $Y $package already installed $N" | tee -a $LOG_FILE
    fi
done
