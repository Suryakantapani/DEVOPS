#!/bin/bash
KEY_NAME="hari"
KEY_FILE="hari.pem"
AMI_ID=$(aws ec2 describe-images \
--owners 099720109477 \
--filters \
"Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
"Name=architecture,Values=x86_64" \
"Name=state,Values=available" \
--query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
--output text)
echo "Ubuntu AMI: $AMI_ID"
VPC_ID=$(aws ec2 describe-vpcs \
--filters Name=is-default,Values=true \
--query 'Vpcs[0].VpcId' \
--output text)
SG_ID=$(aws ec2 describe-security-groups \
--filters Name=vpc-id,Values="$VPC_ID" Name=group-name,Values=default \
--query 'SecurityGroups[0].GroupId' \
--output text)
aws ec2 authorize-security-group-ingress \
--group-id "$SG_ID" \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0 2>/dev/null
aws ec2 authorize-security-group-ingress \
--group-id "$SG_ID" \
--protocol tcp \
--port 80 \
--cidr 0.0.0.0/0 2>/dev/null
INSTANCE_ID=$(aws ec2 run-instances \
--image-id "$AMI_ID" \
--instance-type t3.micro \
--key-name "$KEY_NAME" \
--security-group-ids "$SG_ID" \
--query 'Instances[0].InstanceId' \
--output text)
echo "Instance created: $INSTANCE_ID"
aws ec2 wait instance-running \
--instance-ids "$INSTANCE_ID"
PUBLIC_IP=$(aws ec2 describe-instances \
--instance-ids "$INSTANCE_ID" \
--query 'Reservations[0].Instances[0].PublicIpAddress' \
--output text)
echo "Public IP: $PUBLIC_IP"
ssh -o StrictHostKeyChecking=no \
-i "$KEY_FILE" \
ubuntu@"$PUBLIC_IP" <<'EOF'
sudo apt update -y
sudo apt install nginx -y
PRIVATE_IP=$(hostname -I | awk '{print $1}')
sudo bash -c "cat > /var/www/html/index.html <<HTML
<html>
<body>
<h1>Nginx Web Server</h1>
<h2>Private IP: $PRIVATE_IP</h2>
</body>
</html>
HTML"
sudo systemctl enable nginx
sudo systemctl start nginx
echo "Nginx installed successfully."
echo "Private IP: $PRIVATE_IP"
EOF