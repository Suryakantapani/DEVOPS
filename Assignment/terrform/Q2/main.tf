 provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "surya-s3-90617575"

  tags = {
    Name = "surya"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  depends_on = [
    aws_s3_bucket_public_access_block.website
  ]

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  content_type = "text/html"

  content = <<EOF
<html>
<head>
  <title>Q2 Website</title>
</head>
<body>
  <h1>Hello from Terraform</h1>
  <p>This website is hosted on Amazon S3.</p>
</body>
</html>
EOF
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website.id
  key          = "error.html"
  content_type = "text/html"

  content = <<EOF
<html>
<body>
  <h1>Error 404</h1>
  <p>Page not found.</p>
</body>
</html>
EOF
}
output "bucket_name" {
  value = aws_s3_bucket.website.id
}
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}
