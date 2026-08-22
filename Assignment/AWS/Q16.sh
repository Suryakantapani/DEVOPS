#!/bin/bash
AMI_ID=$(aws ec2 describe-images \
--owners 099720109477 \
--filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
"Name=architecture,Values=x86_64" \
"Name=state,Values=available" \
--query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
--output text)
SG_ID=$(aws ec2 describe-security-groups \
--group-names default \
--query 'SecurityGroups[0].GroupId' \
--output text)
USER_DATA=$(cat <<EOF
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>Web Server</h1>" > /var/www/html/index.html
EOF
)
INSTANCE_IDS=$(aws ec2 run-instances \
--image-id "$AMI_ID" \
--instance-type t3.micro \
--count 2 \
--security-group-ids "$SG_ID" \
--user-data "$USER_DATA" \
--query 'Instances[*].InstanceId' \
--output text)
echo "$INSTANCE_IDS"