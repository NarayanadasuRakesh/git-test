#!/bin/bash

USERNAME=$1
PASSWORD=$2

# using read command to read arguments and -s flag to hide input from terminal
echo "Enter your username: "
read -s USERNAME
echo "Your user name is: ${USERNAME}"
echo "Enter your password: "
read -s PASSWORD
echo "Your  Password is: ${PASSWORD}"
