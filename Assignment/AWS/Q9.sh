#!/bin/bash
AMI_ID=$(aws ec2 describe-images \
--owners 099720109477 \
--filters \
"Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
"Name=state,Values=available" \
--query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
--output text)
echo "Latest Ubuntu LTS AMI: $AMI_ID"
INSTANCE_ID=$(aws ec2 run-instances \
--image-id "$AMI_ID" \
--instance-type t3.micro \
--query 'Instances[0].InstanceId' \
--output text)
echo "Instance ID: $INSTANCE_ID"
aws ec2 wait instance-running \
--instance-ids "$INSTANCE_ID"
aws ec2 describe-instances \
--instance-ids "$INSTANCE_ID" \
--query 'Reservations[].Instances[].[InstanceId,PublicIpAddress,PublicDnsName]' \
--output table