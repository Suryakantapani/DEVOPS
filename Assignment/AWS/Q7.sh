#!/bin/bash
VPC_ID=$(aws ec2 describe-vpcs \
--filters Name=is-default,Values=true \
--query 'Vpcs[0].VpcId' \
--output text)
SG_ID=$(aws ec2 create-security-group \
--group-name suryasg1 \
--description "SSH Security Group" \
--vpc-id "$VPC_ID" \
--query 'GroupId' \
--output text)
aws ec2 authorize-security-group-ingress \
--group-id "$SG_ID" \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0
AMI_ID=$(aws ec2 describe-images \
--owners amazon \
--filters "Name=name,Values=al2023-ami-*" \
"Name=architecture,Values=x86_64" \
"Name=state,Values=available" \
--query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
--output text)
INSTANCE_ID=$(aws ec2 run-instances \
--image-id "$AMI_ID" \
--instance-type t3.micro \
--security-group-ids "$SG_ID" \
--query 'Instances[0].InstanceId' \
--output text)
aws ec2 wait instance-running \
--instance-ids "$INSTANCE_ID"
aws ec2 describe-instances \
--instance-ids "$INSTANCE_ID" \
--query 'Reservations[].Instances[].[InstanceId,PublicDnsName]' \
--output table