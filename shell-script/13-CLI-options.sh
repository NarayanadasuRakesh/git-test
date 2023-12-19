#!/bin/bash
NAME=""
WISHES=""

USAGE() {
    echo "$(basename $0 -n <name> -w <wishes>)"
    echo "-n, Specify the name (mandatory)"
    echo "-w, Specify the wishes (mandatory)"
    echo "-h, Specify the help, exit"
}

while getopts ":n:w:h" opt;
do
    case $opt in
        n) NAME="$OPTARG";;
        w) WISHES="$OPTARG";;
        h) USAGE; exit;;
        :) USAGE; exit;;
        \?) echo "ERROR: Invalid option: "$OPTARG"" >&2; USAGE; exit;;
    esac    
done

if [ -z $NAME ] || [ -z $WISHES ]
then
    echo "ERROR: Both -n and -w are mandatory"
    USAGE
    exit
fi
echo "Hello $NAME $WISHES. I have been learning shell script."