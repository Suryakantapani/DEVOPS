#!/bin/bash
BUCKET_NAME="surya-website-$RANDOM-$RANDOM"
aws s3api create-bucket \
--bucket "$BUCKET_NAME" \
--region us-east-1
aws s3api put-public-access-block \
--bucket "$BUCKET_NAME" \
--public-access-block-configuration \
BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
cat > index.html <<EOF
<html>
<body>
<h1>Welcome to Surya's Website</h1>
</body>
</html>
EOF
cat > error.html <<EOF
<html>
<body>
<h1>Error: Page Not Found</h1>
</body>
</html>
EOF
aws s3api put-bucket-website \
--bucket "$BUCKET_NAME" \
--website-configuration '{
    "IndexDocument": {
        "Suffix": "index.html"
    },
    "ErrorDocument": {
        "Key": "error.html"
}}'
aws s3 cp index.html s3://$BUCKET_NAME/
aws s3 cp error.html s3://$BUCKET_NAME/
cat > website-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
            }]}
EOF
aws s3api put-bucket-policy \
--bucket "$BUCKET_NAME" \
--policy file://website-policy.json
echo "http://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com"