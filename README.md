# Docker-nginx-letsencrypt-CRM(ChurchCRM)

## For Windows
- Use Docker for Windows
  >1. Install Docker for Windows.(Hyper-V will disable VirtualBox and VMware)
  >1. Run Docker for Windows.Open Windows Power Shell. Run docker login.If fail, restart Docker for Windows.
  >1. In Windows Power Shell, run windows_path_fix.ps1 to fix path issue.
- Use Vagrant(default is docker-compose-dev.yml)
  >1. Install VaitualBox and Vagrant.
  >1. Run "vagrant up".
  >1. ~~For develop use software-link support, need run vagrant up in administrator.(https://github.com/winnfsd/vagrant-winnfsd/issues/66)~~
  >1. Recommand use putty to connect. reference https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Connect-to-Your-Vagrant-Virtual-Machine-with-PuTTY
  >1. vagrant will auto run docker-compose up -d, ssh to vagrant machine, /vagrant run "docker-compose logs check status.

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

## Develop
1. In windows use vagrant, vagrant will run a ubuntu with docker inside. use putty to connect, default work folder is /vagrant, mapping to windows vagrant folder.
1. Vagrant will auto run docker-compose with web, db and php-dev services.
1. First time docker-compose will build php-dev image. others had pre-build as image. The image file system is readonly.
1. default docker-compose use docker-compose-dev.yml in vagrant, can be change in Vagrantfile.
1. Volume mapping CRM source code /var/www/CRM to docker local volume to keep modify, /var/www/CRM/src mapping to windows ./content, so can use windows editor to edit php code.
1. After connect to vagrant, switch to /vagrant folder, can use docker-compose command.
1. Had add alias dc to docker-compose.
  >- dc up -d: run all services.
  >- dc down: stop and remove all services
  >- dc ps: show services running status.
  >- dc build --nocache --pull: no use cache, pull the newest image for build.
  >- dc logs: show all services logs.
  >- dc logs php-dev: only show php-dev services log.
  >- dc exec php-dev bash:connect to php-dev services, in this service work folder is /var/www/CRM, can use npm command.
1. Docker command.
  >- docker ps: show all docker running services.
  >- docker system prune -f: remove all no running data.
  >- docker images: show all build or pulled images.
  >- docker rmi <image id>: remove selected images.
  >- docker volume ls: show docker local volume.
  >- docker volume rm <volume name>: remove selected volume.
1. System up follow:
  >1. load builed image.
  >1. run prechk batch.(the batch path mapping windows file /setting/php-dev/crmsetup) can edit it in windows for need.
  >1. run service command.

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
