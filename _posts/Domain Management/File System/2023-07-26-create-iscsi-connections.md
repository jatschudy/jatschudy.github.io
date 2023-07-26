---
title: Create iSCSI Connections
date: 2023-07-26 08:35:00 -0500
categories: [Domain Management,File System]
tags: [powershell,script,file server,file system,storage use,failover,iscsi]
---

### Pre-Requisites
This assumes you already have an iSCSI portal configured and the nodes intended to be connected to it are also prepared.

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
Connect-iscsitarget -nodeaddress iqn.2005-10.org.freenas.ctl:witness -IsPersistent $true -InitiatorPortalAddress $ipAddress -TargetPortalAddress $targetAddress
Get-iSCSIsession | Register-iSCSIsession
Get-iSCSITarget
```

### Check Connections for All Nodes
```powershell
Invoke-Command -ComputerName $array@@ -ScriptBlock{Get-iSCSITarget}
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
8. list volume
9. select volume #
10. assign letter=x


*Label the drive with these commands. '#' represents the correct letter.*
1. Exit
2. Powershell
3. Start-Process Powershell -Verb RunAs
4. Get-Volume
5. Set-Volume -DriveLetter # -NewFileSystemLabel "LABELNAME"

*Return to diskpart and remove the volume label*
1. remove letter #

### Online Disks for Other Nodes
1. RDP into node
2. Get to command line
3. Enter 'diskpart'
4. list disk
5. select disk #
6. online disk
7. repeat for each offline disk on each node