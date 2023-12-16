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

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "DISABLING CURRENT NODEJS"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "ENABLING NODEJS:18"

echo -e "$YELLOW Installing Nodejs .....$NC"
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "INSTALLING NODEJS"

#creating user
id roboshop &>> $LOGFILE
if [ $? -ne 0 ]
then
  useradd roboshop &>> $LOGFILE
  VALIDATE $? "USER CREATING"
else
  echo -e "$YELLOW roboshop user already exist...skipping$NC"
fi

mkdir -p /app

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
VALIDATE $? "DOWNLOADING CART APPLICATION"

cd /app 
unzip -o /tmp/cart.zip &>> $LOGFILE

npm install &>> $LOGFILE
VALIDATE $? "INSTALLING DEPENDENCIES"

#copying cart service file
cp /home/centos/git-test/roboshop-shell-script/cart.service /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "COPYING CART SERVICE FILE"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "CART DAEMON RELOAD"

systemctl enable cart &>> $LOGFILE
VALIDATE $? "ENABLING CART"

systemctl start cart &>> $LOGFILE
VALIDATE $? "STARTING CART"

