#!/bin/bash
USER=$(stat -c '%U' $(readlink -f "$0"))

# Disable Firewalld
systemctl stop firewalld || true

# create group and apply things

groupadd docker
usermod -aG docker ${USER}

exit 0
