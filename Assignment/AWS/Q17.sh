#!/bin/bash
AMI_ID=$(aws ec2 describe-images \
--owners 099720109477 \
--filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
"Name=architecture,Values=x86_64" \
"Name=state,Values=available" \
--query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
--output text)
INSTANCE_ID=$(aws ec2 run-instances \
--image-id "$AMI_ID" \
--instance-type t3.micro \
--query 'Instances[0].InstanceId' \
--output text)
aws ec2 wait instance-running \
--instance-ids "$INSTANCE_ID"
aws cloudwatch put-metric-alarm \
--alarm-name "Surya-CPU-Alarm" \
--metric-name CPUUtilization \
--namespace AWS/EC2 \
--statistic Average \
--period 300 \
--evaluation-periods 1 \
--threshold 70 \
--comparison-operator GreaterThanThreshold \
--dimensions Name=InstanceId,Value="$INSTANCE_ID"
echo "EC2 Instance: $INSTANCE_ID"