#!/bin/bash
cat > policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
 }]}
EOF
aws iam create-policy \
--policy-name S3PolicySurya01 \
--policy-document file://policy.json
cat policy.json