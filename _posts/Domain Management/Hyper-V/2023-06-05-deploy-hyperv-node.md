---
title: Deploy HyperV Node
date: 2023-06-04 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization]
---

### Install HyperV Role and Management Tools on Server
*Seems to work better if the two are run seperately*
```powershell
Invoke-Command -ComputerName HYPERV01,HYPERV02 -ScriptBlock {Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart}
```
```powershell
    Invoke-Command -ComputerName HYPERV01,HYPERV02 -ScriptBlock {Add-WindowsFeature rsat-Hyper-V-tools}
```

### Install HyperV Management Tools on Workstation
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

```