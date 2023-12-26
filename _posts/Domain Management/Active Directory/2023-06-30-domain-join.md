---
title: Join Domain
date: 2023-06-30 9:12:00 -0500
categories: [Domain Management,Active Directory]
tags: [ad,active directory,powershell,script,Domain Join]
---

### Rename PC and Join Domain for a Single Devices
*Run Powershell as Admin*
```powershell
$DOMAIN = Read-Host -Prompt "Enter Domain Name"
$CompInfo = Get-WMIObject Win32_ComputerSystemProduct | Select IdentifyingNumber
$PCName = "IGI-"+$CompInfo.identifyingNumber
$ADMIN = Read-Host -Prompt "Enter Domain Admin Username"
Add-Computer -NewName $PCName -DomainName $DOMAIN -Credential $ADMIN -Restart
```

*After restart, set description*
```powershell
Add-WindowsCapability –online –Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
$CompInfo = Get-WMIObject Win32_ComputerSystemProduct | Select Name,IdentifyingNumber
$PCName = "IGI-"+$CompInfo.identifyingNumber
$NAME = switch ($compInfo.Name) {
    "HP ProBook 450 G8 Notebook PC" {"HP Probook 450 G8"}
    "HP ProBook 450 G6" {"HP Probook 450 G6"}
}
$USER = Read-Host -Prompt "Enter Assigned User (Last, First)"
Set-ADComputer -Identify $PCName -Description $USER+" | WIN11 | "+$NAME
```

### Join Debian Installation to Domain
Elevate to sudo priviledges before starting.
```bash
read -p "Enter Domain: " domain
apt update && apt full-upgrade -y
apt install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit samba -y
apt update && apt upgrade -y
ufw allow samba
realm discover "$domain"
realm join "$domain"
sed -i '/nss,/a default_domain_suffix = CONTOSO.COM' /etc/sssd/sssd.conf
pam-auth-update --enable mkhomedir
```
Add groups to Sudoers
```bash
read -p "Enter group@domain: " group
echo "%$group ALL=(ALL:ALL) ALL" >> /etc/sudoers
```
