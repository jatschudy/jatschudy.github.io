---
title: Fileserver Failover
date: 2023-07-25 08:35:00 -0500
categories: [Domain Management,File System]
tags: [powershell,script,file server,file system,storage use,failover]
---

### Notes
This guide assumes you already have a server OS installed on each node, have assigned static IPs and joined domain.  I have an array configured in my Powershell Profile for use.

*After restarts or disconnects you will need to connect again*
```powershell
$SERVER = Read-Host -Prompt "Enter server name"
Enter-PSSession -ComputerName $SERVER
```

*Alternatively, use this to create an array for invoke commands.  I have this in my powershell initial startup script.*
```powershell
$arrayFS = @("NODE01","NODE02","NODE03")
```

### Install FileServer and Failover Clustering
*This works best when done on each node individually.*
```powershell
Install-WindowsFeature -Name FS-FileServer
Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools
Get-WindowsFeature -Name FS-FileServer
Get-WindowsFeature -Name Failover-Clustering
Install-WindowsFeature -Name MultiPath-IO
```

*Restart all nodes once you have installed the requirements.*
```powershell
Invoke-Command -ComputerName $arrayFS -ScriptBlock {Restart-Computer}
```

### Connect iSCSI Target
Pause this procedure here and create iscsi connections.

### Validate Cluster Configuration
*Fix any issues here before continuing*
```powershell
Test-Cluster -Node $arrayFS
```

### Create the Cluster
- Did not work when I tried to run remotely.  Worked when remoted into one of the HyperV Nodes.
```powershell
$NAME = Read-Host -Prompt "Enter Cluster Name"
$IP = Read-Host -Prompt "Enter Cluster Management IP"
New-Cluster -Name $NAME -Node $arrayFS -StaticAddress $IP.ToString()
```

### Configure Failover Cluster
1. On a workstation, open Failover Cluster Manager
2. Right click on Roles, select File Server
