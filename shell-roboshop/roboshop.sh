#!/bin/bash

AMI_ID="ami-0ec18f6103c5e0491"
SG_ID="sg-0df02a323031ac06f"
INSTANCES=("robo" "maongo")
ZONE_ID=
DOMAIN_NAME=

for instances in ${INSTANCES[@]}
do


instance_id=$(aws ec2 run-instances \
    --image-id ami-0c55b33f761770f57 \
    --instance-type t2.micro \
    --key-name your-key-pair-name \
    --security-group-ids sg-0123456789abcdef0 \
    --subnet-id subnet-0fedcba9876543210 \
    --query 'Instances[0].InstanceId' \
    --output text)
  if [ $Instances -ne "frontend" ]
  then
    IP=aws ec2 describe-instances \
        --instance-ids "$instance_id" \
        --query 'Reservations[].Instances[].PublicIpAddress' \
        --output text
        
    else
        IP=$(aws ec2 describe-instances \
        --instance-ids "$instance_id" \
        --query 'Reservations[].Instances[].PublicIpAddress' \
        --output text)
    fi
        echo "$instance IP address: $IP"
  

done
