---
title: Deploy HyperV Node
date: 2023-06-04 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization]
---

### Setup HyperV Host
*Run on HyperV Server*
```powershell
$SERVER = Read-Host -Prompt "Enter server name"
Enter-PSSession -ComputerName $SERVER
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart
Add-WindowsFeature rsat-Hyper-V-tools
write-host "Computer will restart"
pause
Restart-Computer
```

### Install HyperV Management Tools on Workstation
*Do not run this on the server*
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```