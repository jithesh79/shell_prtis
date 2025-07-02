#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/logsfile.sh"
SCRIPT_NAME=$(basename $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Scripting starting date : $(date)"  | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo -e "$R Please run this Script as root user $N" | tee -a $LOG_FILE
    exit 1
else
    echo "You are running this script as root user" | tee -a $LOG_FILE
fi

VALIDATE () {
    if [ $1 -eq 0 ]; then
        echo -e "$2...$G Success $N" | tee -a $LOG_FILE
    else
        echo -e "$2...$R Failed $N" | tee -a $LOG_FILE
        exit 1
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying MongoDB repo"

dnf install -y mongodb-org &>>$LOG_FILE
VALIDATE $? "Installing MongoDB server"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enabling MongoDB service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Updating MongoDB bind IP for remote access"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "Restarting MongoDB"
