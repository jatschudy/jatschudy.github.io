---
title: Docker Host Deployment
date: 2023-12-23 20:00:00 -0500
categories: [Deployments,Docker]
tags: [debian,domain join,terminal,script,docker]
---

### Overview
This guide configures a docker host on a Debian installation. It should work on any Debian based distro.  Before you begin, be sure to set a static IP Address on the install.

### Configure Install
Run updates and install SSH, FTP and a firewall.
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install openssh-server vfstpd ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
```

Now add the docker repository
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Last install the docker
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
