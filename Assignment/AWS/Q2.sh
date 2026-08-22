#!/bin/bash
users=$(aws iam list-users --query 'Users[*].UserName' --output text)
for user in $users
do
    arn=$(aws iam get-user \
        --user-name "$user" \
        --query 'User.Arn' \
        --output text)

    echo "User ARN: $arn"
    echo "Attached Policies:"
    aws iam list-attached-user-policies \
        --user-name "$user" \
        --query 'AttachedPolicies[*].[PolicyName,PolicyArn]' \
        --output table
done