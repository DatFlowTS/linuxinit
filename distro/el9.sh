#!/usr/bin/env bash

LOG_FILE=$(bash <(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/provide_logfile.sh) setup)
CONFIG_LOG=$(bash <(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/provide_logfile.sh) config)

{
    yum -y install wget curl jq dnf sqlite --allowerasing
    dnf -y install gcc-c++ make vim epel-release dnf-plugins-core cockpit --allowerasing
    dnf -y install https://pkgs.dyn.su/el9/base/x86_64/raven-release-1.0-4.el9.noarch.rpm
    dnf -y config-manager --set-enabled {raven,raven-extras,crb,epel,extras,plus}
    cd || exit 1
    bash <(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/install_nodejs.sh) global
    bash <(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/install_endpoint_repo.sh)
    dnf clean all ; dnf -y upgrade --refresh ; dnf -y update ; dnf clean all
    dnf -y install --skip-broken git cockpit-{packagekit,sosreport,storaged,networkmanager,selinux,kdump,navigator,podman} --allowerasing
    git clone https://github.com/skobyda/cockpit-certificates.git
    cd cockpit-certificates || exit 1
    make install
    cd || exit 1
    systemctl enable --now cockpit.socket && systemctl start cockpit.socket
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
    curl -s https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch -o /usr/bin/neofetch
    chmod -v 555 /usr/bin/neofetch
    dnf -y install zsh speedtest google-authenticator
    npm i -g typescript pm2
    sed -i 's/bash/zsh/g' /etc/default/useradd
    usermod --shell /bin/zsh root
    cd ~ || exit 1
    bash <(curl -fsSL https://raw.github.com/datflowts/linuxinit/master/functions/zsh_setup.sh)
} | tee -a "$LOG_FILE" | tee -a "$CONFIG_LOG"
