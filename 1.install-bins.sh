#!/bin/bash
# All code concepts are from
#-> https://docs.docker.com/engine/install/binaries/#install-daemon-and-client-binaries-on-linux

# Must run as root
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

# Acquire User to set
USER=$(stat -c '%U' $(readlink -f "$0"))

# Disable Firewalld
systemctl stop firewalld || true
systemctl disable firewalld || true

# Disabled SELinux - need reboot.
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux && cat /etc/sysconfig/selinux

# Check Command
function check_command() {
  COMMAND="$1"
  if ! command -v "${COMMAND}" &> /dev/null
  then
    echo "${COMMAND} could not be found"
    exit 1
  fi
}

check_command "iptables"
check_command "xz"
check_command "git"

# create group and apply things
groupadd docker
usermod -aG docker ${USER}

# copy docker bins /

cp -f packages/scripts/docker.service /lib/systemd/system/docker.service
cp -f packages/scripts/docker.socket /lib/systemd/system/docker.socket
chmod +x packages/docker/* packages/bin/*
cp -f packages/docker/* /usr/bin/
cp -f packages/bin/* /usr/bin/

systemctl enable docker
systemctl start docker

exit 0
