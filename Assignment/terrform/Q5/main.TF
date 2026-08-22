provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "backend" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t3.micro"

  user_data = file("backend.sh")

  tags = {
    Name = "Backend"
  }
}

resource "aws_instance" "frontend" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t3.micro"

  user_data = templatefile("frontend.sh", {
    backend_ip = aws_instance.backend.public_ip
  })

  tags = {
    Name = "Frontend"
  }
}

output "backend_public_ip" {
  value = aws_instance.backend.public_ip
}

output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}
