#!/bin/bash

AMI_ID="ami-020cba7c55df1f615"
SG_ID="sg-07fc610592e333d7b"
INSTANCES=("mongodb" "redis" "mysql" "rabbirmq" "catalogue" "user"
 "cart" "shipping" "payment" "dispatch" "forntend")
 DOMAIN_NAME=""  # need to creat domine id 
 ZONE_ID=""  # need to creat zone id

 for instance in ${INSTANCES[@]}
 do
      INSTANCES_ID=$(aws ec2 run-instances --image-id ami-020cba7c55df1f615 --instances-type t2.micro --security-group-ids sg-07fc610592e333d7b --tag-specifications "ResourceType=instance,Tags=[{Key=Nmae, Value=$instance}]" --query "Insatances[0].InsatanceId" --output text)
      if [ $instance != "frontend" ]
      then
          IP=$(aws ec2 decribe-instance --instance-ids $INSTANCES_ID --quary "Reservations[0].Insatances[0].PrivateIpAddress" --output text)
      else
          IP=$(aws ec2 describe-instance --intance-ids $INSTANCES_ID --query "Reservations[0].Instances[0].PublivlpAddress" --output text)
      
      fi
      echo "instances IP address: $IP"

      aws route53 change-resource-record-sets \
      --hosted-zone-id $ZONE_ID \
      --change-bathch '
      {
        "comment": "Creating or Updateing a record set for congnito endpoint"
         ,"Changes": [{
         "Action"                  : "UPSERT"
         ,"ResourceRecordSet"       : {
                "Name"              :"'$instance' . '$DOMAIN_NAME'"
                ,Type"              :"A"
                ,"TTL"              : 1
                ,"ResourceRecords"  :[{
                    "Value"         : "'$IP'"
                
                }]
        }
         }]
       
      }
      


 done


