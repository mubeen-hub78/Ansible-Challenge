# Ansible-Challenge
Create ci pipeline that will deploy and configure these VMs using terraform and ansible
according following requirements
1. Deploy 2 virtual machines using terraform.
first vm on Amazon linux, hostname: c8.local
second vm on ubuntu 21.04, hostname: u21.local
2. As a result of terraform execution, dynamically create inventory for ansible
c8.local should be in the frontend group
u21.local should be in the backend group
3. Create ansible playbook for c8.local and u21.local
for linux OS playbook should apply the following changes
selinux: disable
firewalld: disable
for frontend playbook group should install and configure nginx
nginx configuration should do proxying from port 80 on port 19999 to the
backend group
for the backend group, the playbook must install the Netdata application from the
official repositories and run it on port 19999.
