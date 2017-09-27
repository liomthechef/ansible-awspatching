###### Usage/Summary
This Ansible play is a fully contained playbook for patching windows and linux server.
playbook.yml is flexible and can have each subsidiary play removed without impact.

This has been written with a specific purpose and likely needs modification for regular usage.
Broken on Ansible 2.4 due to https://github.com/ansible/ansible/issues/29008, part of how it's broken requires duplication
of parameters, once that issue is resolved a refactor is due.

Works on Ansible 2.3.2

###### Guide:
- include: ./playbook-nagios-maintenance-on.yml
places nagios hosts into downtime

- include: ./plays/playbook-amibackup.yml creates
AMI backup of server without reboot

- include: ./plays/playbook-prepatchreport.yml
creates email format of in-scope servers and sends

- include: ./plays/playbook-windows.yml
patches [windows] servers and logs

- include: ./plays/playbook-linux.yml
patches [linux] servers and logs

- include: ./plays/playbook-nagios-maintenance-off.yml
places nagios servers into downtime

- include: ./plays/playbook-patchreport.yml
sends status report of patching.


###### Prerequisites:
- Prepare client windows servers with at least winrm3.0 and configure/enable it with GPO or /lib/ConfigureAnsibleRemoting.ps1
- Obtain AWS credentials, store them encrypted with ansible-vault in group_vars`

###### Host machine prerequisites for Ansible Mac/Linux

Install Python 2.7.14, earlier 2.7 versions should work.
Install Python pip

Python Dependencies.
`pip install ansible
 pip install boto
 pip install winrm
 pip install "pywinrm>=0.2.2
`

###### Playbook dependencies

- Set smtpfrom and smtp fields in playbooks, along with adjusting smtp server parameters
- Populate inventory file with hosts the server should be deployed as below:

`###WINDOWS SERVERS TO BE PATCHED
[windows]
nppamft01.domain.com
###LINUX SERVERS TO BE PATCHED
[linux]
nppaprx01.domain.com
####NAGIOS SERVER FOR DOWNTIME
[maintenance]
10.200.9.11
###AWS INSTANCE NAMES
[amibackup]
nppamft01.domain.com awsname="NPP_A_IN_MFT01"
nppaprx01.domain.com awsname="NPP_A_IN_PRX01"
###NAGIOS HOSTS FOR DOWNTIME
[maintenance:vars]
maintenance_hosts='["nppamft01", "nppaprx01"]'
`

- Group_vars should include your servers SSH access details including key location or
password if required, see sample information in /group_vars

###### Deployment

- Execute bin/deploy.sh to deploy do a patching run on windows/linux in inventory
