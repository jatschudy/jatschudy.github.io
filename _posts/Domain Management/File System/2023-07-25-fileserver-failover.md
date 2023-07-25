---
title: Fileserver Failover
date: 2023-07-25 08:35:00 -0500
categories: [Domain Management,File System]
tags: [powershell,script,file server,file system,storage use,failover]
---

### Notes
This guide assumes you already have a server OS installed on each node, have assigned static IPs and joined domain.

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
```powershell
Invoke-Command -ComputerName $arrayFS -ScriptBlock {Install-WindowsFeature -Name FS-FileServer, Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools, Get-WindowsFeature -Name FS-FileServer, Get-WindowsFeature -Name Failover-Clustering}
```

```powershell
Invoke-Command -ComputerName $arrayHV -ScriptBlock {Restart-Computer}
```

### Validate Cluster Configuration
*Fix any issues here before continuing*
```powershell
Test-Cluster -Node "NODE1","NODE2"
```

