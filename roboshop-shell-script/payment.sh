#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"
exec &>LOGFILE

#Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "Script started executing at $TIMESTAMP"

#Check for root user
if [ $ID -ne 0 ]
then
  echo -e "$RED ERROR: Please run script with root access$NC"
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
dnf install python36 gcc python3-devel -y
VALIDATE $? "Installing python"

#creating user
id roboshop 
if [ $? -ne 0 ]
then
  useradd roboshop 
  VALIDATE $? "USER CREATING"
else
  echo -e "$YELLOW roboshop user already exist...skipping$NC"
fi

mkdir -p /app 
VALIDATE $? "Creating directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip
VALIDATE $? "Downloading payment src"

cd /app 
VALIDATE $? "Change directory"

unzip -o /tmp/payment.zip
VALIDATE $? "Unzip src"

pip3.6 install -r requirements.txt
VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell-script/payment.service /etc/systemd/system/payment.service
VALIDATE $? "Copying payment.service file"

systemctl daemon-reload
VALIDATE $? "Daemon reload"

systemctl enable payment 
VALIDATE $? "Enable payment service"

systemctl start payment
VALIDATE $? "Start payment service"

