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

dnf install maven -y
VALIDATE $? "Installing maven"

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
VALIDATE $? "creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
VALIDATE $? "Downloading shipping.zip file"

cd /app
VALIDATE $? "Changing into app directory"

unzip -o /tmp/shipping.zip
VALIDATE $? "unzip file"

mvn clean package
VALIDATE $? "Installing Dependencies"

mv target/shipping-1.0.jar shipping.jar
VALIDATE $? "renaming and moving shipping.jar into app directory from target directory"

cp /home/centos/roboshop-shell-script/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "Copying shipping.service file "

systemctl daemon-reload
VALIDATE $? "Daemon reload"

systemctl enable shipping 
VALIDATE $? "Enable shipping"

systemctl start shipping
VALIDATE $? "Starting shipping"

dnf install mysql -y
VALIDATE $? "Installing mysql client"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql 
VALIDATE $? "loading schema"

systemctl restart shipping
VALIDATE $? "Restarting shipping"

