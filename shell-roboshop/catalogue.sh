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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disabling defalut nodejs"

dnf module enable nodejs-20 -y &>>$LOG_FILE
VALIDATE $? "Enabling nodejs:20"

dnf install nodejs -y
VALIDATE $? "Insatlling nodejs:20"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
VALIDATE $? "Crateing roboshop system user"

mkdir /app 
VALIDATE $? "Creating app directing "

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE $? "Dlonloging catalogues"

cd /app 
unzip /tmp/catalogue.zip
VALIDATE $? "unziping catalogo"

nmp install
VALIDATE $? "installing dependinces"


