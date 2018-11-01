# Docker-nginx-letsencrypt-CRM(ChurchCRM)

## Windows docker
1. Install Docker for Windows.(Hyper-V will disable VirtualBox and VMware)
1. Run Docker for Windows.Open Windows Power Shell. Run docker login.If fail, restart Docker for Windows.
1. In Windows Power Shell, run windows_path_fix.ps1 to fix path issue.

## Install
1. docker-compose build
1. docker-compose up -d, wait ChurchCRM install.
1. https://localhost, default user is admin, password is changeme.

## Debug
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
Change VirtualBox or VMware to Hyper-V, use admin run command "bcdedit /set hypervisorlaunchtype auto" then reboot PC
