# terraform/outputs.tf

output "frontend_ip" {
  description = "Public IP address of the frontend server"
  value       = aws_instance.frontend.public_ip
}

output "backend_ip" {
  description = "Public IP address of the backend server"
  value       = aws_instance.backend.public_ip
}

output "inventory" {
  description = "Ansible inventory for the deployed instances"
  value = <<EOT
[frontend]
# Explicitly tell Ansible to use Python 3.8 for c8.local, as this will be installed.
c8.local ansible_host=${aws_instance.frontend.public_ip} ansible_user=ec2-user ansible_python_interpreter=/usr/bin/python3.8

[backend]
# Ubuntu's /usr/bin/python3 (e.g., Python 3.12 for 24.04) is sufficient.
u21.local ansible_host=${aws_instance.backend.public_ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3

[redhat_hosts]
c8.local

[debian_hosts]
u21.local

EOT
}
