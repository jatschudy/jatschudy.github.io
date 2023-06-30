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