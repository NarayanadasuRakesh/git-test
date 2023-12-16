#!/bin/bash

ID=(id -u)
TIMESTAMP=(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP"

#Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "Script started executing at $TIMESTAMP" &>>LOGFILE

if [ $ID -ne 0 ]
then
  echo -e "$RED ERROR: Please run script with root access$NC"
  exit 1
else
  echo -e "$GREEN You are a root user$NC"
fi

VALIDATE() {
  if [ $1 -ne 0 ] 
  then
    echo -e "$RED ERROR: $2 is FAILED$NC"
    exit 1
  else
    echo -e "$GREEN $2 is SUCCESS$NC"
  fi
}

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>LOGFILE
VALIDATE $? "Configure yum repos"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>LOGFILE
VALIDATE $? "Configue yum repos for rabbitmq"

echo -e "$YELLOW Installing tabbitmq.....$NC"
dnf install rabbitmq-server -y  &>>LOGFILE
VALIDATE $? "Install rabbitmq"

systemctl enable rabbitmq-server &>>LOGFILE
VALIDATE $? "Enable rabbitmq"

systemctl start rabbitmq-server &>>LOGFILE
VALIDATE $? "Start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>LOGFILE
VALIDATE $? "Adding new user to rabbitmq"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>LOGFILE
VALIDATE $? "Set permissions to rabbitmq"


