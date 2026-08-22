provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t3.micro"

  user_data = file("provision.sh")

  tags = {
    Name = "Q4-Nginx-Server"
  }
}

output "public_ip" {
  value = aws_instance.server.public_ip
}
