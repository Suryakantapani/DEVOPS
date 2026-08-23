output "public_ip" {
  value = aws_instance.ubuntu.public_ip
}
output "private_ip" {
  value = aws_instance.ubuntu.private_ip
}
output "s3_bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}
