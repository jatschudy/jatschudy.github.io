---
title: Failover Clustering
date: 2023-06-21 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization,failover,cluster]
---

### Install Necessary Features
*Installs the failover clustering and enables the MultiPathIO features.  Upon completion, server will restart.*
```powershell
$SERVER = Read-Host -Prompt "Enter Server Name: "
Enter-PSSession -ComputerName $SERVER
Install-WindowsFeature -Name Failover-Clustering -Restart
Enable-WindowsOptionalFeature -Online -FeatureName MultiPathIO -Restart
Restart-Computer

```

### Install HyperV Management Tools on Workstation
*Enable iSCSI Disk Support, set failover policy and enable path verification.  Upon completion, server will restart.*
**Failover Policy Options**
- **None**: Clears any currently configured default load balance policy.
- **FOO**: Fail Over Only. (Recommended)
- **RR**: Round Robin.
- **LQD**: Least Queue Depth.
- **LB**: Least Blocks.

```powershell
$SERVER = Read-Host -Prompt "Enter Server Name: "
Enter-PSSession -ComputerName $SERVER
$POLICY = Read-Host -Prompt "Enter Failover Policy"
Enable-MSDSMAutomaticClaim -BusType iSCSI
Set-MSDSMGlobalDefaultLoadbalancePolicy -Policy $POLICY
Set-MPIOSetting -NewPathVerificationState Enabled
Restart-Computer

```