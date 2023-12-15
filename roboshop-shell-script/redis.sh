#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"

#Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "Script started executing at $TIMESTAMP" &>>"$LOGFILE"

if [ "$ID" -ne 0 ]
then 
  echo "$RED ERROR: Please run script using root access $NC"
  exit 1
else
  echo "$GREEN You are root user$NC"
fi

#Function to validation various commands
VALIDATE() {
  if [ "$1" -ne 0 ] 
  then
    echo "$RED $2 is ...FAILED$NC"
    exit 1
  else
    echo "$GREEN $2 is ...SUCCESS$NC"
  fi
}

echo "$YELLOW Installing rpm package.....$NC"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>"$LOGFILE"
VALIDATE $? "Installing rpm package"

echo "$YELLOW Installing redis.....$NC"
dnf module enable redis:remi-6.2 -y &>>"$LOGFILE"
VALIDATE $? "Enable redis package"

dnf list installed redis &>>"$LOGFILE"
if [ $? -ne 0 ]
then
  dnf install redis -y &>>"$LOGFILE"
  VALIDATE $? "Installing redis"
else
  echo "$YELLOW redis already installed...SKIPPING"
fi

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>"$LOGFILE"
VALIDATE $? "IP configuration"

systemctl enable redis &>>"$LOGFILE"
VALIDATE $? "Enable redis"

systemctl start redis &>>"$LOGFILE"
VALIDATE $? "Start redis"