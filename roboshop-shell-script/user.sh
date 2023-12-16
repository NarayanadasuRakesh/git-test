#!/bin/bash

ID=$(id -u)
TIMESTAMP=(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"
MONGODB_HOST=<mongodb-ip/domain-name>

#Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "Script started executing at $TIMESTAMP" &>>"$LOGFILE"

if [ "$ID" -ne 0 ]
then 
  echo -e "$RED ERROR: Please run script using root access $NC"
  exit 1
else
  echo -e "$GREEN You are root user$NC"
fi

#Function to validation various commands
VALIDATE() {
  if [ "$1" -ne 0 ] 
  then
    echo -e "$RED $2 is ...FAILED$NC"
    exit 1
  else
    echo -e "$GREEN $2 is ...SUCCESS$NC"
  fi
}

echo -e "$YELLOW Disabling nodejs.....$NC"
dnf module disable nodejs -y &>>"$LOGFILE"
VALIDATE $? "Module disable"

echo -e "$YELLOW Enabling nodejs.....$NC"
dnf module enable nodejs:18 -y &>>"$LOGFILE"
VALIDATE $? "Module enable"

dnf list installed nodejs &>>"$LOGFILE"
if [ $? -ne 0 ]
then
  dnf install nodejs -y &>>"$LOGFILE"
  VALIDATE $? "Install nodejs"
else
  echo -e "$YELLOW nodejs already installed....SKIPPING$NC"
fi   

id roboshop &>>"$LOGFILE"
if [ $? -ne 0 ]
then
  useradd roboshop &>>"$LOGFILE"
  VALIDATE $? "roboshop user creation"
else
  echo -e "$YELLOW roboshop user already exists...SKIPPING$NC"
fi

mkdir -p /app &>>"$LOGFILE"
VALIDATE $? "Creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>"$LOGFILE"
VALIDATE $? "Downloading user.zip"

cd /app  &>>"$LOGFILE"
VALIDATE $? "Change directory"

unzip -o /tmp/user.zip &>>"$LOGFILE"
VALIDATE $? "unzip"

npm install  &>>"$LOGFILE"
VALIDATE $? "Installing dependencies"

cp /home/centos/git-test/roboshop-shell-script/user.service /etc/systemd/system/user.service &>>"$LOGFILE"
VALIDATE $? "copying user.service file"

systemctl daemon-reload &>>"$LOGFILE"
VALIDATE $? "Daemon reload"

systemctl enable user  &>>"$LOGFILE"
VALIDATE $? "Enable user"

systemctl start user &>>"$LOGFILE"
VALIDATE $? "Start user"
cp /home/centos/git-test/roboshop-shell-script/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying mongodb client repo"

dnf install mongodb-org-shell -y &>>"$LOGFILE"
VALIDATE $? "Installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/user.js &>>"$LOGFILE"
VALIDATE $? "Schema into mongodb"

