#!/bin/bash

SOURCE_DIR="/tmp/shell_script_logs"

RC="\e[31m"
GC="\e[32m"

NC="\e[0m"

if [ ! -d $SOURCE_DIR ]
then 
    echo -e "$RC $SOURCE_DIR does not exists $NC"
    exit 1
else
    delete_log_files=$(find $SOURCE_DIR -type f -mtime +14 -name "*.log")
fi

while IFS= read -r line
do
    rm -rf $line
    echo -e "$GC Deleted files: $line $NC"
done <<< $delete_log_files