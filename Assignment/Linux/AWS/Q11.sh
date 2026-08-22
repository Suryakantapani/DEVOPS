#!/bin/bash
BUCKET_NAME="surya-bucket-$RANDOM-$RANDOM"
aws s3api create-bucket \
--bucket "$BUCKET_NAME" \
--region us-east-1
cat > bucket-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
        }
    ]
}
EOF
aws s3api put-public-access-block \
--bucket "$BUCKET_NAME" \
--public-access-block-configuration \
BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-policy \
--bucket "$BUCKET_NAME" \
--policy file://bucket-policy.json
echo "File 1" > file1.txt
echo "File 2" > file2.txt
echo "File 3" > file3.txt
aws s3 cp file1.txt s3://$BUCKET_NAME/
aws s3 cp file2.txt s3://$BUCKET_NAME/
aws s3 cp file3.txt s3://$BUCKET_NAME/
echo "Bucket created: $BUCKET_NAME"
