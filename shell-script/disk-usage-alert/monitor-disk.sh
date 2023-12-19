#!/bin/bash
#Purpose: Monitoring Disk usage and Alert script
#Version:1.0
#Created Date: Tue Dec 16 11:11:11 IST 2023
#Modified Date:
#Author: Nararayanadasu Rakesh
#START#
DISK_USAGE=$(df -hT | grep -vE 'tmp|File') 
DISK_THRESHOLD=1
message=""

while IFS= read line
do
    usage=$(echo $line | awk '{print $6F}' | cut -d % -f1)
    partition=$(echo $line | awk '{print $1F}')
    if [ $usage -ge $DISK_THRESHOLD ]
    then
        message+="High Disk Usage on $partition is: $usage <br>"
    fi
done <<< $DISK_USAGE

echo -e "Message: $message"
#mail -s "<subject>" <to-address>
#echo "$message" | mail -s "High Disk Usage" name@gmail.com
sh mail.sh "ALERT HIGH DISK USAGE" "name@gmail.com" "DevOps Team" "High Disk Usage" "$message"
#END#