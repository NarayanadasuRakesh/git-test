#!/bin/bash

SUBJECT=$1
TO_ADDR=$2
TO_TEAM=$3
ALERT_TYPE=$4
BODY=$5
ESCAPE_BODY=$(printf '%s\n' "$BODY" | sed -e 's/[]\/$*.^[]/\\&/g');

FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/BODY/$ESCAPE_BODY/g" template.html)

echo "$FINAL_BODY" | mail -s "$(echo -e "$SUBJECT\n content-Type: text:html")" "$TO_ADDR"