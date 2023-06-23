---
title: Failover Clustering
date: 2023-06-21 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization,failover,cluster]
---

### Connect to a server
*After restarts or disconnects you will need to connect again*
```powershell
$SERVER = Read-Host -Prompt "Enter server name"
Enter-PSSession -ComputerName $SERVER
```

### Install Necessary Features
*Installs the failover clustering and enables the MultiPathIO features.*
```Powershell
Install-WindowsFeature -Name Failover-Clustering -Restart
```
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName MultiPathIO
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
$POLICY = Read-Host -Prompt "Enter Policy Option"
Enable-MSDSMAutomaticClaim -BusType "iSCSI"
Set-MSDSMGlobalDefaultLoadbalancePolicy -Policy $POLICY
Set-MPIOSetting -NewPathVerificationState Enabled
Restart-Computer
```

### Configure iSCSI Service
*Connect to iSCSI Portal and list get target addresses*
```powershell
Set-Service -Name msiscsi -StartupType "Automatic"
Start-Service msiscsi
$targetAddress = Read-Host -Prompt "Enter Target IP Address"
New-iscsitargetportal -TargetPortalAddress $targetAddress
Get-IscsiTargetPortal | Update-IscsiTargetPortal
Get-IscsiTarget
```

*Make the Connections*
```powershell
$ipAddress = Read-Host -Prompt "Enter Initiator Address"
$targetAddress = Read-Host -Prompt "Enter Target IP Address"
Connect-iscsitarget -nodeaddress iqn.2005-10.org.freenas.ctl:quorum -IsPersistent $true -InitiatorPortalAddress $ipAddress -TargetPortalAddress $targetAddress
Connect-iscsitarget -nodeaddress iqn.2005-10.org.freenas.ctl:storage -IsPersistent $true -InitiatorPortalAddress $ipAddress -TargetPortalAddress $targetAddress
Get-iSCSIsession | Register-iSCSIsession
Get-iSCSITarget
```

### Check Connections for All Nodes
```powershell
Invoke-Command -ComputerName HYPERV01,HYPERV02 -ScriptBlock{Get-iSCSITarget}
```

### Enable Format Drives
*Use Remote Desktop to access one of the nodes to do the following steps.  If all prior steps were followed, these steps only need performed on one node.*
1. Open RDP and remote to one of the nodes
2. Get to command line
3. Enter 'diskpart'

*You are now in diskpart.  The following commands will be repeated for each drive you need to format.  '#' will stand in for the disk number as this may vary.  Be careful not to format the wrong disk.*
1. list disk
2. Select Disk #
3. online disk
4. attributes disk clear readonly
5. clean
6. create partition primary
7. format fs=ntfs

*Label the drive with these commands. '#' represents the correct letter.*
1. Exit
2. Powershell
3. Start-Process Powershell -Verb RunAs
4. Get-Volume
5. Set-Volume -DriveLetter # -NewFileSystemLabel "LABELNAME"