#!/bin/bash
#Purpose: Alert script gmail setup
#Version:1.0
#Created Date: Tue Dec 16 11:11:11 IST 2023
#Modified Date:
#Author: Nararayanadasu Rakesh
#START#

RC=\e[31m
GC=\e[32m
YC=\e[33m
NC=\e[0m

SMPT="[smpt.gmail.com]:587 $GMAIL:$APP_PASSWD"
POSTFIX_CONF="$(cat <<EOF
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
EOF
)"
POSTFIX_MAIN="/etc/postfix/main.cf"

echo -e "$GC Installing postfix.....$NC"
yum install postfix -y  #Postfix hits gmail API

echo -e "$GC Installing sasl.....$NC"
yum install cyrus-sasl-plain -y #Authentication framework

echo -e "$GC Installing mailx.....$NC"
yum mailx -y    #Commands to send mail

#Configure Postfix
$POSTFIX_CONF >> $POSTFIX_MAIN

#Configure SASL credentials
touch /etc/postfix/sasl_passwd

#Create Postfix lookup table from the sasl_passwd file
Postmap /etc/postfix/sasl_passwd

echo -p 'Enter your Gmail: ' GMAIL
echo -p 'Enter your Gmail App password: ' APP_PASSWD
#END#