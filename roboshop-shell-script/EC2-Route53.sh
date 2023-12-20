#!/bin/bash
GC="\e[32m"
NC="\e[0m"

IMAGE_ID="ami-11222333JISEFE"
SG="sg-6X2f8c5XXXXX" 
INSTANCE=("web" "catalogue" "cart" "user" "shipping" "payment" "dispatch" "mongodb" "mysql" "redis" "rabbitmq")
DOMAIN_NAME="yourdomail.com"
ZONE_ID="IJRHGOIRG51UWJKVFSD"

for i in "${INSTANCE[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    
    #Create EC2 Instance and Print Private IP Address
    IP_ADDR=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$i"}]" --query 'Instances[0].[PrivateIpAddress]' --output text)
    echo "$GC $i: $IP_ADDR $NC"

    #Create Route53 A Records
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating A record"
        ,"Changes": [{
        "Action"              : "CREATE"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDR'"
            }]
        }
        }]
    }
        '

done

