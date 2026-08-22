#!/bin/bash
read -p "Enter Registration Number: " username
aws iam create-user --user-name "$username"
aws iam attach-user-policy \
--user-name "$username" \
--policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam attach-user-policy \
--user-name "$username" \
--policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-user-policy \
--user-name "$username" \
--policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
aws iam get-user --user-name "$username" \
--query 'User.[UserName,UserId,Arn,CreateDate]' \
--output text > report.txt
sed -i.bak 's/[[:space:]]\+/ | /g' report.txt
awk '{print}' report.txt
aws iam list-attached-user-policies \
--user-name "$username" \
--query 'AttachedPolicies[*].[PolicyName,PolicyArn]' \
--output table