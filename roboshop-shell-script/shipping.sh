#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"
MYSQL_HOST=<mysql-ip/domain-name>

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
  exit 1
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

echo -e "$YELLOW Installing maven.....$NC"
dnf install maven -y &>>$LOGFILE
VALIDATE $? "Installing maven"

#creating user
id roboshop &>>$LOGFILE
if [ $? -ne 0 ]
then
  useradd roboshop &>>$LOGFILE
  VALIDATE $? "USER CREATING"
else
  echo -e "$YELLOW roboshop user already exist...skipping$NC"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE
VALIDATE $? "Downloading shipping.zip file"

cd /app &>>$LOGFILE
VALIDATE $? "Changing into app directory"

unzip -o /tmp/shipping.zip &>>$LOGFILE
VALIDATE $? "unzip file"

echo -e "$YELLOW Installing dependencies.....$NC"
mvn clean package &>>$LOGFILE &>>$LOGFILE
VALIDATE $? "Installing Dependencies"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE
VALIDATE $? "renaming and moving shipping.jar into app directory from target directory"

cp /home/centos/git-test/roboshop-shell-script/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE
VALIDATE $? "Copying shipping.service file "

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reload"

systemctl enable shipping  &>>$LOGFILE
VALIDATE $? "Enable shipping"

systemctl start shipping &>>$LOGFILE
VALIDATE $? "Starting shipping"

echo -e "$YELLOW Installing mysql client.....$NC"
dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing mysql client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$LOGFILE
VALIDATE $? "loading schema"

systemctl restart shipping &>>$LOGFILE
VALIDATE $? "Restarting shipping"

