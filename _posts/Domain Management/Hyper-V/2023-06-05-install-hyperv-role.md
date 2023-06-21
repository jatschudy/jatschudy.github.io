---
title: Install HyperV Role
date: 2023-06-04 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization]
---

### Install HyperV Role and Management Tools on Server
```powershell
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
Add-WindowsFeature rsat-Hyper-V-tools
Install-WindowsFeature -Name Falover-Clustering -Restart
Restart-Computer

```

### Install HyperV Management Tools on Workstation
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

```