---
title: Join Domain
date: 2023-06-30 9:12:00 -0500
categories: [Domain Management,Active Directory]
tags: [ad,active directory,powershell,script,Domain Join]
---

### Rename PC and Join Domain
*Place this script on your installation media or easy access for new devices.  If in a secure location, consider hard coding the Domain and User for yourself*
```powershell
$DOMAIN = Read-Host -Prompt "Enter Domain Name"
$PC = Read-Host -Prompt "Enter PC Name"
$ADMIN = Read-Host -Prompt "Enter Domain Admin Username"
Add-Computer -ComputerName $PC -DomainName -DOMAIN -Credential $DOMAIN\$ADMIN -Restart
```