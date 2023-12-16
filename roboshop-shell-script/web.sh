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

echo -e "$YELLOW Installing nginx.....$NC"
dnf install nginx -y
VALIDATE $? "Installing nginx"

systemctl enable nginx
VALIDATE $? "Enable nginx"

systemctl start nginx
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "Removing default nginx html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "Downloading web src"

cd /usr/share/nginx/html
VALIDATE $? "Change directory"

unzip -o /tmp/web.zip
VALIDATE $? "Unzip web src"

cp /home/centos/roboshop-shell-script/roboshop.conf /etc/nginx/default.d/roboshop.conf
VALIDATE $? "Copying roboshop.conf file"

systemctl restart nginx 
VALIDATE $? "Restarting nginx"