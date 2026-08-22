#!/bin/bash
cat > Q5policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
}]}
EOF
aws iam create-role \
--role-name Suryaadmin \
--assume-role-policy-document file://Q5policy.json
aws iam attach-role-policy \
--role-name SuryaEC2Role0811 \
--policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-role-policy \
--role-name SuryaEC2Role0811 \
--policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
