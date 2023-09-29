#!/bin/bash

yum -y install wget curl dnf
cd /etc/pki/rpm-gpg
wget https://rpm.nodesource.com/gpgkey/nodesource.gpg.key
rpm --import /etc/pki/rpm-gpg/nodesource.gpg.key
cd
dnf -y install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
dnf -y install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1
dnf -y install gettext make gcc-c++ make vim epel-release dnf-plugins-core cockpit | tee -a $LOGFILE
sh -c "$(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/install_45drives_repo.sh)"
dnf -y install cockpit-{packagekit,sosreport,storaged,networkmanager,selinux,kdump,navigator} | tee -a $LOGFILE
systemctl enable --now cockpit.socket && systemctl start cockpit.socket | tee -a $LOGFILE
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash >> $LOGFILE
dnf -y config-manager --set-enabled {powertools,epel,extras,plus} | tee -a $LOGFILE
dnf -y upgrade --refresh  | tee -a $LOGFILE
curl -s https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o /usr/bin/neofetch | tee -a $LOGFILE
chmod -v 555 /usr/bin/neofetch | tee -a $LOGFILE
dnf -y install git nodejs zsh speedtest google-authenticator | tee -a $LOGFILE
npm i -g typescript pm2 | tee -a $LOGFILE
sed -i 's/bash/zsh/g' /etc/default/useradd
usermod --shell /bin/zsh root
cd ~
sh -c "$(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/zsh/wheel.sh)"