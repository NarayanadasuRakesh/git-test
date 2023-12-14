#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGODB_HOST="mongodb.rakeshintech.online"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "script started executing at $TIMESTAMP"  &>> $LOGFILE

# root access check
if [ $ID -ne 0 ]
then
  echo -e "$RED ERROR: please run script with root access $NC"
else
  echo -e "$GREEN You are root user$NC"
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then 
      echo -e "$RED $2 IS FAILED$NC"
    else
      echo -e "$GREEN $2 IS SUCCESS$NC"
    fi
}

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "DISABLING CURRENT NODEJS"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "ENABLING NODEJS:18"

echo -e "$YELLOW Installing Nodejs$NC"
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "INSTALLING NODEJS"

#creating user
id roboshop
if [ $? -ne 0]
then
  useradd roboshop &>> $LOGFILE
  VALIDATE $? "USER CREATING"
else
  echo -e "$YELLOW roboshop user already exist skipping$NC"
fi

mkdir -p /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
VALIDATE $? "DOWNLOADING CATALOGUE APPLICATION"

cd /app 
unzip -o /tmp/catalogue.zip &>> $LOGFILE

npm install &>> $LOGFILE
VALIDATE $? "INSTALLING DEPENDENCIES"

#copying catalogue service file
cp /home/centos/git-test/roboshop-shell-script/mongo.repo /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "COPYING CATALOGUE SERVICE FILE"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "CATALOGUE DAEMON RELOAD"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "ENABLING CATALOGUE"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "STARTING CATALOGUE"

echo -e "$YELLOW Istalling mongo client$NC"
dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "INSTALLING MONGODB CLIENT"

mongo --host "${MONGODB_HOST}" </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "Loading Catalogue data into MongoDB"

