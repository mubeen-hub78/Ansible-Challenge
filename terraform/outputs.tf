inventory = <<EOT
[frontend]
c8.local ansible_host=${aws_instance.frontend.public_ip} ansible_user=ec2-user ansible_python_interpreter=/usr/bin/python3

[backend]
u21.local ansible_host=${aws_instance.backend.public_ip} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3

[redhat_hosts]
c8.local

[debian_hosts]
u21.local
EOT
