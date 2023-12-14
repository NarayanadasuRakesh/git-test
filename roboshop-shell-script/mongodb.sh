#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

#colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "script started executing at $TIMESTAMP"

VALIDATE() {
  if [ $1 -ne 0 ]
  then
    echo -e "$RED ERROR: $2 FAILED $NC"
  else
    echo -e "$GREEN $2 SUCCESS $NC"
  fi
}
# Check root user or not
if [ $ID -ne 0 ]
then
  echo -e "$RED ERROR: Please run script with root access $NC"
else
  echo -e "$GREEN You are a root user $NC"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "$YELLOW Installing MONGODB ..... $NC"
dnf install mongodb-org -y 
VALIDATE $? "INSTALLATION OF MONGODB"

systemctl enable mongod
VALIDATE $? "ENABLED MONGODB"

systemctl start mongod
VALIDATE $? "STARTED MONGODB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

systemctl restart mongod
VALIDATE $? "RESTARTED MONGODB"


