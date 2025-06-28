#!/bin/bash
USERID=$(id -u)
R="e\[31m"
G="e\[32m"
Y="e\[33m"
N="e\[0m"
LOGS_FOLDER="/var/logs/shellscript.sh"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
PACKAGES=("mysql" "python" "nginx" "java")

mkdir -p $LOGS_FOLDER  

echo "Script Stating date : $(date)" &>>$LOG_FILE
 
 if [ $USERID -ne 0 ]
 then
    echo -e "$R please run this script by using roor user $N"  | tee -a &>>$LOG_FILE 
    exit 1
 else
    echo "Your runing with root user" &>>$LOG_FILE
 fi

VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "installing $2 is.....$G SUCCESS $N" &>>$LOG_FILE | tee -a &>>$LOG_FILE 
    else
        echo -e "installing $2 is......$R FAILUR $N" | tee -a &>>$LOG_FILE 
        exit 1
    fi
}

for package in ${PACKAGES [@]}
do
    dnf list installed $package &>>$LOG_FILE
    if [ $? -ne 0 ]
    then
        echo "$package is not installed...go to install" | tee -a &>>$LOG_FILE 
        dnf install $package -y  | tee -a &>>$LOG_FILE 
        VALIDATE $? "$package"
    else
        echo -e "Noting to do... $Y already installed $N"  | tee -a &>>$LOG_FILE 
    fi

done

