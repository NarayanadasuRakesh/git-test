#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=$("/tmp/$0-$TIMESTAMP.log")

#colors
RED="\e[31m"
GREEN="\e[32m"
NC="\e[0m"

#check root user or not
if [ $? -ne 0 ]
then
  echo "$RED ERROR: Please run script with root access $NC"
else
  echo "$GREEN You are a root user $NC"
fi    

#validation function
VALIDATION() {
    if [ $1 -ne 0 ]
    then
      echo "$RED ERROR: $2 IS ... FAILED $NC"
    else
      echo "$GREEN $2 ... SUCCESS $NC"
    fi
}

#install git
yum install git -y
VALIDATION $? "INSTALLING GIT"

#install mysql
yum install mysql -y
VALIDATION $? "INSTALLING MYSQL"