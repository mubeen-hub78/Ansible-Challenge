# terraform/main.tf

provider "aws" {
  region = "us-east-1" # Ensure this matches the region of your AMI, subnet, and key pair
}

# SSH Key Pair
# This resource assumes the key named by `var.key_name` (e.g., "Virginia") already exists in AWS.
# If it does not exist, Terraform will attempt to create it using the public key from ~/.ssh/id_rsa.pub.
# Ensure your Jenkins SSH credential corresponds to the private key of this pair.
resource "aws_key_pair" "deployer_key" {
  key_name   = var.key_name
  # This path assumes your Jenkins agent has an id_rsa.pub at its home directory.
  # Adjust if your public key is located elsewhere or paste its content directly here.
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security Group
# This security group will be attached to both instances to allow necessary traffic.
resource "aws_security_group" "web_sg" {
  name_prefix = "ansible-challenge-sg-"
  description = "Allow HTTP, SSH, and Netdata traffic for Ansible Challenge"
  # You can specify `vpc_id = "your_vpc_id"` if you are using a non-default VPC

  # Ingress rule for SSH (port 22) from anywhere (0.0.0.0/0)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: For production, restrict to known IPs.
  }

  # Ingress rule for HTTP (port 80) for Nginx frontend
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for Netdata (port 19999) for backend and proxying
  ingress {
    from_port   = 19999
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic (instances can download packages)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Frontend VM (Amazon Linux 2)
resource "aws_instance" "frontend" {
  ami           = "ami-0f3f13f145e66a0a3" # Amazon Linux 2 (64-bit x86) - specific for us-east-1
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id] # Attach the created security group
  tags = {
    Name = "c8.local"
  }

  # User data to set hostname on boot
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname c8.local
              EOF
}

# Backend VM (Ubuntu 24.04 LTS)
resource "aws_instance" "backend" {
  ami           = "ami-020cba7c55df1f615" # Ubuntu Server 24.04 LTS (64-bit x86) - specific for us-east-1
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id] # Attach the created security group
  tags = {
    Name = "u21.local"
  }

  # User data to set hostname on boot
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname u21.local
              EOF
}
