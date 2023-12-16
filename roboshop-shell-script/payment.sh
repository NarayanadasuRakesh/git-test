#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"

#Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "Script started executing at $TIMESTAMP" &>>$LOGFILE

#Check for root user
if [ $ID -ne 0 ]
then
  echo -e "$RED ERROR: Please run script with root access$NC"
  exit
else
  echo -e "$GREEN You are root user$NC"
fi

VALIDATE() {
    if [ "$1" -ne 0 ]
    then
      echo -e "$RED ERROR: $2 is FAILED$NC"
      exit 1
    else
      echo -e "$GREEN $2 is SUCCESS$NC"
    fi
}

echo -e "$YELLOW Installing python.....$NC"
dnf install python36 gcc python3-devel -y &>>$LOGFILE
VALIDATE $? "Installing python"

#creating user
id roboshop  &>>$LOGFILE
if [ $? -ne 0 ]
then
  useradd roboshop 
  VALIDATE $? "USER CREATING"
else
  echo -e "$YELLOW roboshop user already exist...skipping$NC"
fi

mkdir -p /app  &>>$LOGFILE
VALIDATE $? "Creating directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE
VALIDATE $? "Downloading payment src"

cd /app &>>$LOGFILE
VALIDATE $? "Change directory"

unzip -o /tmp/payment.zip &>>$LOGFILE
VALIDATE $? "Unzip src"

pip3.6 install -r requirements.txt &>>$LOGFILE
VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell-script/payment.service /etc/systemd/system/payment.service &>>$LOGFILE
VALIDATE $? "Copying payment.service file"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reload"

systemctl enable payment  &>>$LOGFILE
VALIDATE $? "Enable payment service"

systemctl start payment &>>$LOGFILE
VALIDATE $? "Start payment service"

