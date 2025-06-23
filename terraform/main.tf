resource "aws_instance" "frontend" {
  ami           = "ami-0f3f13f145e66a0a3" # Amazon Linux 2 (64-bit x86)
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = ["sg-05a7015767640bf35"] # Security Group added
  tags = {
    Name = "c8.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname c8.local
              EOF
}

resource "aws_instance" "backend" {
  ami           = "ami-020cba7c55df1f615" # Ubuntu Server 24.04 LTS (64-bit x86)
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = ["sg-05a7015767640bf35"] # Security Group added
  tags = {
    Name = "u21.local"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname u21.local
              EOF
}

output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}
