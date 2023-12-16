#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"
exec &>>LOGFILE

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

dnf module disable mysql -y
VALIDATE $? "Disable Mysql"

echo -e "$YELLOW Installing mysql.....$NC"

dnf list installed mysql
if [ $? -ne 0 ]
then
  dnf install mysql-community-server -y
  VALIDATE $? "Installing Mysql"
else
  echo "$YELLOW mysql already installed...SKIPPING$NC"
fi

systemctl enable mysqld
VALIDATE $? "Enable mysql"

systemctl start mysqld
VALIDATE $? "Start mysql"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "set mysql root password"

mysql -uroot -pRoboShop@1
VALIDATE $? "login to mysql"