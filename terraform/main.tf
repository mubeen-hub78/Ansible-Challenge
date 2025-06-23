# terraform/main.tf

# Security Group
resource "aws_security_group" "web_sg" {
  name_prefix = "ansible-challenge-sg-"
  description = "Allow HTTP, SSH, and Netdata traffic for Ansible Challenge"

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

  ingress {
    from_port   = 19999
    to_port     = 19999
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

# Frontend VM (Amazon Linux 2)
resource "aws_instance" "frontend" {
  ami           = "ami-0f3f13f145e66a0a3"
  instance_type = "t2.micro"
  key_name      = var.key_name # This will now reference an *existing* key pair in AWS
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "c8.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname c8.local
              EOF
}

# Backend VM (Ubuntu 24.04 LTS)
resource "aws_instance" "backend" {
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  key_name      = var.key_name # This will now reference an *existing* key pair in AWS
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "u21.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname u21.local
              EOF
}
