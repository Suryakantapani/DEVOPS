resource "aws_security_group" "web" {
  name = "web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "backend" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "backend"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key)
  }

  provisioner "file" {
    source      = "back.sh"
    destination = "/home/ubuntu/back.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/back.sh",
      "/home/ubuntu/back.sh"
    ]
  }
}

resource "aws_instance" "frontend" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  depends_on = [aws_instance.backend]

  tags = {
    Name = "frontend"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key)
  }

  provisioner "file" {
    source      = "front.sh"
    destination = "/home/ubuntu/front.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/front.sh",
      "/home/ubuntu/front.sh ${aws_instance.backend.public_ip}"
    ]
  }
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}

output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}
