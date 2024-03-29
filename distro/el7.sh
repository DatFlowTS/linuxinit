#!/usr/bin/env bash

{
    yum -y install wget curl dnf
    dnf -y install gettext make gcc-c++ make vim epel-release dnf-plugins-core cockpit
    sh -c "$(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/install_45drives_repo.sh)"
    dnf -y install cockpit-{packagekit,sosreport,storaged,networkmanager,selinux,kdump,navigator}
    systemctl enable --now cockpit.socket && systemctl start cockpit.socket
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
    dnf -y config-manager --set-enabled {powertools,epel,extras,plus}
    dnf -y upgrade --refresh
    sh -c "$(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/install_nodejs_repo.sh)"
    sh -c "$(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/install_endpoint_repo.sh)"
    dnf -y install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1
    curl -s https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o /usr/bin/neofetch
    chmod -v 555 /usr/bin/neofetch
    dnf -y install git nodejs zsh speedtest google-authenticator
    npm i -g typescript pm2
    sed -i 's/bash/zsh/g' /etc/default/useradd
    usermod --shell /bin/zsh root
    cd ~ || exit 1
    sh -c "$(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/zsh/wheel.sh)"
} | tee -a "$LOGFILE"