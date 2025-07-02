USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/logs/logsfile.sh"
SCRIPT_NAME=$(echo $0 | cut "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Scripting starting date : $(date)"  | tee >>$LOG_FILE

if [$USERID -ne 0 ]
then
    echo -e "$R Please run this Script by root user $N " >>$LOG_FILE
    exit 1
else
    echo "your run this Script By root user" >>$LOG_FILE

fi

VALATADE (){
    if [ $1 -eq o ]
    then
        echo -e " $2...$G Success $N " | tee >>$LOG_FILE
    else
        echo -e "  $2...$R Failner $N " | tee >>$LOG_FILE
        exit 1
    fi

}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALATADE $? "Copying MongoDb repo "

dnf mongo-org -y &>>$LOG_FILE
VALATADE $? "Installing mongo db server"

systemctl enable mongodb &>>$LOG_FILE
VALATADE $? "Starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALATADE $? "Editing Mongo db config file and editing remot conntion "

systemctl restart mongodb &>>$LOG_FILE
VALATADE $? "Restating mongodb"