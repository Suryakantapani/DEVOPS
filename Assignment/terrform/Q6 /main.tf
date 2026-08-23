resource "aws_instance" "ubuntu" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  tags = {
    Name = "Ubuntu-Server"
  }
}
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "TerraformBucket"
  }
}
