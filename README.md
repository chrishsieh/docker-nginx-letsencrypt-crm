# Docker-nginx-letsencrypt-CRM(ChurchCRM)

## For Windows
- Use Docker for Windows
  >1. Install Docker for Windows.(Hyper-V will disable VirtualBox and VMware)
  >1. Run Docker for Windows.Open Windows Power Shell. Run docker login.If fail, restart Docker for Windows.
  >1. In Windows Power Shell, run windows_path_fix.ps1 to fix path issue.
- Use Vagrant
  >1. Install VaitualBox and Vagrant.
  >1. Run vagrant_setting.ps1 to setting vagrant and xdebug ip.Can select nginx or apache, debian or alpine.
  >1. Update .env setting.
  >1. Run "vagrant up".
  >1. ~~For develop use software-link support, need run vagrant up in administrator.(https://github.com/winnfsd/vagrant-winnfsd/issues/66)~~
  >1. Recommand use putty to connect. reference https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Connect-to-Your-Vagrant-Virtual-Machine-with-PuTTY. ~~If use vscode can use SSHExtension to open ssh terminal.~~
  >1. vagrant will auto run docker-compose up -d, vagrant ssh to vagrant machine, /vagrant run "docker-compose logs check status.

## Version note
1. Use vagrant_setting.ps1 to select different version.
1. For development single web site, use apache.
1. For development multi web sites, use nginx, if only use en_US locale can use alpine OS for small size, others use debian OS.

## Install
1. Update .env setting.
1. docker-compose build
1. docker-compose up -d, wait ChurchCRM install.
1. https://myapp.localtest.me, *.localtest.me ip is 127.0.0.1, no need to change hosts file, default user is admin, password is changeme.

## Debug
1. Use docker-compose-dev.yml for develop, default url is https://dev.localtest.me
1. Modify docker-compose-dev.yml, enabled debug setting, if need trace nginx, enable php DEBUG_MODE=true.
1. docker-compose -f docker-compose-dev.yml down;docker-compose -f docker-compose-dev.yml up -d
1. nginx and php debug information at ./log

## Develop
- In windows use vagrant, vagrant will run a ubuntu with docker inside. use putty to connect, default work folder is /vagrant, mapping to windows vagrant folder.
- Vagrant will auto run docker-compose with web, db and php-dev services.
- If switch different image, need run docker-compose build --pull.
- First time docker-compose will build php-dev image. others had pre-build as image. The image file system is readonly.
- ~~default docker-compose use docker-compose-dev.yml in vagrant, can be change in Vagrantfile.~~
- Volume mapping CRM source at /var/www/CRM, windows mapping to ../CRM_sync, use unison to sync, in windows run run_unison.ps1 to sync, can modify the mark line to auto sync. ~~Volume mapping CRM source code /var/www/CRM to docker local volume to keep modify, /var/www/CRM/src mapping to windows ./content, so can use windows editor to edit php code.~~
- After connect to vagrant, switch to /vagrant folder, can use docker-compose command.
- At VM /vagrant do command dc exec php bash can swith to php service to run node command.
- This version use yarn to replace npm command.
- Had add alias dc to docker-compose.
  >- dc up -d: run all services.
  >- dc down: stop and remove all services
  >- dc ps: show services running status.
  >- dc build --nocache --pull: no use cache, pull the newest image for build.
  >- dc logs: show all services logs.
  >- dc logs php-dev: only show php-dev services log.
  >- dc exec php-dev bash:connect to php-dev services, in this service work folder is /var/www/CRM, can use npm command.
- Docker command.
  >- docker ps: show all docker running services.
  >- docker system prune -f: remove all no running data.
  >- docker images: show all builed or pulled images.
  >- docker rmi <image id>: remove selected images.
  >- docker volume ls: show docker local volume.
  >- docker volume rm <volume name>: remove selected volume.
  >- docker volume prune: prune all volumes.
- System up follow:
  >1. load builed image.
  >1. run prechk batch.(the batch path mapping windows file /setting/php-dev/crmsetup) can edit it in windows for need.
  >1. run service command.
- default web url is https://dev.localtest.me , if port 443 used, need modify Vagratfile $forwarded_ports = { 80 => 80, 443 => 8080} and connect with https://dev.localtest.me:8080, default user is admin, password is changeme.
- Build from ChurchCRM git version: dc down, delete /content/index.php, set GIT RESET version in docker-compose-dev.yml, dc up -d
- vscode setting:
  - Xdebug with vscode:
    >- Vscode need install PHP Debug. the debug setting at ./vscode/launch.json.
    >- Enable vscode debug first, then connect to https://dev.localtest.me to trigger debug.
    >- PowerShell need use advance mode.

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
