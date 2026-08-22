#!/bin/bash
cat > admin-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
}]}
EOF
aws iam create-policy \
--policy-name Suryapolicy \
--policy-document file://admin-policy.json
read -p "Enter username: " username
aws iam create-user --user-name "$username"
aws iam attach-user-policy \
--user-name "$username" \
--policy-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):policy/SuryaAdminPolicy0811
