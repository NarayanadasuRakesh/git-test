#!/bin/bash
ID=$(id -u)

#check root user or not
if [ $? -ne 0 ]
then
  echo "ERROR: Please run script with root access"
else
  echo "You are a root user"
fi    

#install git
yum install git -y
if [ $? -ne 0 ]
then
  echo "ERROR: INSTALLING GIT IS FAILED"
else
  echo "INSTALLING GIT SUCCESS"
fi

#install mysql
yum install mysql -y
if [ $? -ne 0 ]
then
  echo "ERROR: INSTALLING MYSQL IS FAILED"
else
  echo "INSTALLING MYSQL IS SUCCESS"
fi