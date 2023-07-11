---
title: Deploy HyperV Cluster
date: 2023-06-04 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization]
---

### Notes
This guide assumes you already have a server OS installed, have assigned it a static IP and joined it to a domain.

*You will need HyperV Tools on your workstation.* ***DO NOT RUN ON SERVER***
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

*After restarts or disconnects you will need to connect again*
```powershell
$SERVER = Read-Host -Prompt "Enter server name"
Enter-PSSession -ComputerName $SERVER
```

*Alternatively, use this to create an array for invoke commands.  I have this in my powershell initial startup script.*
```powershell
$arrayHV = @("NODE01","NODE02","NODE03")
```

*I found these videos very useful while setting up.*
- https://www.youtube.com/watch?v=K0jA-q3C0Io&list=PLJrz5WYgikAw_INfe028LtPIz8AyDuMbM&index=2
- https://www.youtube.com/watch?v=yVAFU1M6Auw&list=PLJrz5WYgikAw_INfe028LtPIz8AyDuMbM&index=3

### Install Windows Features
```powershell
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
```
```powershell
Install-WindowsFeauture -Name MultiPath-IO
```

### Install HyperV Management Tools
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
Connect-iscsitarget -nodeaddress iqn.2005-10.org.freenas.ctl:vm-storage -IsPersistent $true -InitiatorPortalAddress $ipAddress -TargetPortalAddress $targetAddress
Get-iSCSIsession | Register-iSCSIsession
Get-iSCSITarget
```

### Check Connections for All Nodes
```powershell
Invoke-Command -ComputerName $arrayHV -ScriptBlock{Get-iSCSITarget}
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

### Online Disks for Other Nodes
1. RDP into node
2. Get to command line
3. Enter 'diskpart'
4. list disk
5. select disk #
6. online disk
7. repeat for each offline disk on each node

# Configure HyperV Nodes

### Setup HyperV Host
*Install necessary features*
```powershell
Invoke-Command -ComputerName $arrayHV -ScriptBlock {Install-WindowsFeature Hyper-V, Failover-Clustering -IncludeAllSubFeature -IncludeManagementTools -Restart}
```

*Run pre-validation and fix any warnings*
```powershell
Test-Cluster -Node $arrayHV -Verbose
```

*Create Cluster*
- Did not work when I tried to run remotely.  Worked when remoted into one of the HyperV Nodes.
```powershell
$NAME = Read-Host -Prompt "Enter Cluster Name"
$IP = Read-Host -Prompt "Enter Cluster Management IP"
New-Cluster -Name $NAME -Node $arrayHV -StaticAddress $IP.ToString()
```

### Configure Cluster
1. Open Failover Cluster Manager on your workstation.
2. Connect to the IP you set when creating the cluster.
3. Right click on the cluster name --> More Actions --> Configure Cluster Quorum Settings.
4. Use Default unless you know why and how to do the other options already.

***More Steps to Come***

### HyperV Replication
Use this if you have critical VMs and at least two HyperV Clusters.  This will allow for replication between the clusters in the event the primary cluster has a disaster, you can instantly recover by running the VMs on the backup cluster.  It does what the name suggest, creates an exact replica ready for use at any time on the other cluster.  Think of it like clustering clusters.

*You first need to give the cluster permissions in AD*
1. Navigate to the OU that contains HyperV resources, specifically the cluster itself.
2. Right click the OU and select Delegate Control.
3. At Users or Groups click Add and then Object Types.
4. Check Computers object type and click okay.
5. Now add the Cluster name.
6. Select Create a custom task to delegate and click next.
7. Select Only the following obects in the folder: --> check Computer obects.
8. Also check Create selected objects in this folder and click next.
9. Select General, Property-Specific and give Write permissions.  Click next.
10. The HyperV Cluster should now be able to create a replication broker.

*Create Replication Broker*
1. Open HyperV Manager and right click on the server node
2. Select Hyper-V Settings
3. Under Server, select Replication Configuration
4. Check Enable this computer as a replica server.
5. Enable HTTP (port 80) for demo.  Setup HTTPS (port 443) for production.
6. Allow replication from an authenticated server
7. Select a volume from ClusterStorage




### These steps may not have been necessary but I have not run this without using them
*Check if ports are open*
```powershell
foreach ($item in $arrayHV) {
Test-NetConnection -Port 80 -Computer $item
}
```
```powershell
foreach ($item in $arrayHV) {
Test-NetConnection -Port 443 -Computer $item
}
```
*Open Ports*
```powershell
Invoke-Command -ComputerName $arrayHV -ScriptBlock {New-NetFirewallRule -DisplayName "Allow HTTP Inbound" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow}
```
```powershell
Invoke-Command -ComputerName $arrayHV -ScriptBlock {New-NetFirewallRule -DisplayName "Allow HTTPS Inbound" -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow}
```
