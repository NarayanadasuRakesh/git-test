#!/bin/bash

ID=(id -u)
TIMESTAMP=(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"

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
dnf module disable nodejs -y
VALIDATE $? "Module disable"

echo -e "$YELLOW Enabling nodejs.....$NC"
dnf module enable nodejs:18 -y
VALIDATE $? "Module enable"

dnf list installed nodejs
if [ $? -ne 0 ]
then
  dnf install nodejs -y
  VALIDATE $? "Install nodejs"
else
  echo -e "$YELLOW nodejs already installed....SKIPPING$NC"
fi   

id roboshop
if [ $? -ne 0 ]
then
  useradd roboshop
  VALIDATE $? "roboshop user creation"
else
  echo -e "$YELLOW roboshop user already exists...SKIPPING$NC"
fi

mkdir -p /app
VALIDATE $? "Creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
VALIDATE $? "Downloading user.zip"

cd /app 
VALIDATE $? "Change directory"

unzip -o /tmp/user.zip
VALIDATE $? "unzip"

npm install 
VALIDATE $? "Installing dependencies"

cp /home/centos/git-test/roboshop-shell-script/user.service /etc/systemd/system/user.service
VALIDATE $? "copying user.service file"

systemctl daemon-reload
VALIDATE $? "Daemon reload"

systemctl enable user 
VALIDATE $? "Enable user"

systemctl start user
VALIDATE $? "Start user"

dnf install mongodb-org-shell -y
VALIDATE $? "Installing mongodb client"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js
VALIDATE $? "Schema into mongodb"

