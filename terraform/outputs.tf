output "inventory" {
  value = <<EOT
[frontend]
c8.local ansible_host=${aws_instance.frontend.public_ip} ansible_user=ec2-user

[backend]
u21.local ansible_host=${aws_instance.backend.public_ip} ansible_user=ubuntu

[redhat_hosts]
c8.local

[debian_hosts]
u21.local
EOT
}
