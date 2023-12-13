#!/bin/bash
ID=$(id -u)

if [ $? -ne 0]
then
  echo "ERROR: Please run script with root access"
else
  echo "You are a root user"
fi    