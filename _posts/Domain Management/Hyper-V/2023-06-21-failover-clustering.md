---
title: Failover Clustering
date: 2023-06-21 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization,failover,cluster]
---

### Install HyperV Role and Management Tools on Server
```powershell
$SERVER = Read-Host -Prompt "Enter Server Name: "
Enter-PSSession -ComputerName $SERVER
Install-WindowsFeature -Name Failover-Clustering -Restart
Restart-Computer

```

### Install HyperV Management Tools on Workstation
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

```