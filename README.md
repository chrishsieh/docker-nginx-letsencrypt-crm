# Docker-nginx-letsencrypt-CRM(ChurchCRM)

## For Windows
- Use Docker for Windows
  >1. Install Docker for Windows.(Hyper-V will disable VirtualBox and VMware)
  >1. Run Docker for Windows.Open Windows Power Shell. Run docker login.If fail, restart Docker for Windows.
  >1. In Windows Power Shell, run windows_path_fix.ps1 to fix path issue.
- Use Vagrant(default is docker-compose-dev.yml)
  >1. Install VaitualBox and Vagrant.
  >1. Run "vagrant up".
  >1. For develop use software-link support, need run vagrant up in administrator.(https://github.com/winnfsd/vagrant-winnfsd/issues/66)
  >1. Recommand use putty to connect. reference https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Connect-to-Your-Vagrant-Virtual-Machine-with-PuTTY

## Install
1. docker-compose build
1. docker-compose up -d, wait ChurchCRM install.
1. https://myapp.localtest.me, *.localtest.me ip is 127.0.0.1, no need to change hosts file, default user is admin, password is changeme.

## Debug
1. Use docker-compose-dev.yml for develop, default url is https://dev.localtest.me
1. Modify docker-compose.yml, enabled debug setting.
1. Remove setting\nginx\vhost.d\default first line '#'
1. docker-compose down;docker-compose up -d
1. nginx and php debug information at ./log

## Other setting
### Auto DNS API
1. if use letsencrypt dns mode, need modify secrets\dns_api.json, detail setting reference https://github.com/Neilpang/acme.sh/tree/master/dnsapi.
### SSL mode setting
1. Modify secrets\ssl.json "host", "letsencrypt"."mode", "letsencrypt"."domain_parameter". detail setting reference https://github.com/Neilpang/acme.sh.
1. Update docker-compose.yml
### CRM setting modify
1. Modify secrets\crm_sql_secrets.json "MYSQL_ROOT_PWD" and "MYSQL_USER_PWD"

## Note
1. When use letsencrypt dns mode, need wait 60 seconds for dns check.
1. Change Hyper-V to VirtualBox or VMware, use admin run command "bcdedit /set hypervisorlaunchtype off" then reboot PC,
Change VirtualBox or VMware to Hyper-V, use admin run command "bcdedit /set hypervisorlaunchtype auto" then reboot PC, others issue can try https://docs.microsoft.com/en-us/windows/security/identity-protection/credential-guard/credential-guard-manage#turn-off-with-hardware-readiness-tool, disable Disable Windows Defender Credential Guard.
