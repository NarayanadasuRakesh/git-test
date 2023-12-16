#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"

#Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "Script started executing at $TIMESTAMP" &>>LOGFILE

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

dnf module disable mysql -y &>>LOGFILE
VALIDATE $? "Disable Mysql"

echo -e "$YELLOW Installing mysql.....$NC"
dnf install mysql-community-server -y &>>LOGFILE
VALIDATE $? "Installing Mysql"

systemctl enable mysqld &>>LOGFILE
VALIDATE $? "Enable mysql"

systemctl start mysql &>>LOGFILE
VALIDATE $? "Start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>LOGFILE
VALIDATE $? "set mysql root password"

mysql -uroot -pRoboShop@1 &>>LOGFILE
VALIDATE $? "login to mysql"