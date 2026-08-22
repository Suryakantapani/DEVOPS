#!/bin/bash
USER_NAME="pot-admin1"
KEY_NAME="hari"
KEY_FILE="hari.pem"
INSTANCE_TYPE="t3.micro"
aws iam create-user \
--user-name "$USER_NAME"
aws iam attach-user-policy \
--user-name "$USER_NAME" \
--policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam attach-user-policy \
--user-name "$USER_NAME" \
--policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
AMI_ID=$(aws ec2 describe-images \
--owners amazon \
--filters \
"Name=name,Values=al2023-ami-*" \
"Name=architecture,Values=x86_64" \
"Name=state,Values=available" \
--query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
--output text)
echo "Latest AMI: $AMI_ID"
VPC_ID=$(aws ec2 describe-vpcs \
--filters Name=is-default,Values=true \
--query 'Vpcs[0].VpcId' \
--output text)
SG_ID=$(aws ec2 describe-security-groups \
--filters Name=vpc-id,Values="$VPC_ID" \
Name=group-name,Values=default \
--query 'SecurityGroups[0].GroupId' \
--output text)
INSTANCE_IDS=$(aws ec2 run-instances \
--image-id "$AMI_ID" \
--instance-type "$INSTANCE_TYPE" \
--count 5 \
--key-name "$KEY_NAME" \
--security-group-ids "$SG_ID" \
--instance-market-options '{
    "MarketType": "spot",
    "SpotOptions": {
        "SpotInstanceType": "one-time"
    }
}' \
--query 'Instances[*].InstanceId' \
--output text)
echo "$INSTANCE_IDS"
aws ec2 wait instance-running \
--instance-ids $INSTANCE_IDS
i=1
for INSTANCE_ID in $INSTANCE_IDS
do
    aws ec2 create-tags \
    --resources "$INSTANCE_ID" \
    --tags Key=Name,Value=pot$i

    i=$((i+1))
done
IPS=$(aws ec2 describe-instances \
--instance-ids $INSTANCE_IDS \
--query 'Reservations[].Instances[].PublicIpAddress' \
--output text)
i
for IP in $IPS
do
    echo "Connecting to pot$i ($IP)..."
    ssh -o StrictHostKeyChecking=no \
    -o ConnectTimeout=10 \
    -i "$KEY_FILE" \
    ec2-user@"$IP" "echo 'SSH connection successful - pot$i'"
    i=$((i+1))
done
echo "All 5 Spot Instances configured and SSH verified."