# terraform/outputs.tf - Only define outputs here that are NOT in main.tf

output "inventory" {
  description = "Ansible inventory for the deployed instances"
  value = <<EOT
[frontend]
# Remove ansible_python_interpreter for c8.local so it defaults to Python 2 for initial raw commands
c8.local ansible_host=${aws_instance.frontend.public_ip} ansible_user=ec2-user

[backend]
# Keep ansible_python_interpreter for u21.local as its Python 3.12 is sufficient
u21.local ansible_host=${aws_instance.backend.public_ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3

[redhat_hosts]
c8.local

[debian_hosts]
u21.local

EOT
}
