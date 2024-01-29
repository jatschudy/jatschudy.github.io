---
title: Powershell Profile
date: 2023-06-30 14:27:00 -0500
categories: [Domain Management,Powershell]
tags: [powershell,script,config]
---

### Create Profile
```powershell
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}
```

### Edit Profile
```powershell
notepad $PROFILE
```

### My Profile Script
*Change variables to current settings.*
```powershell
# Primary Domain Controller
$PRIMARY_DC="DC Name"

# Primary File Server
$PRIMARY_FS="FS Name"

# iSCSI Info
$PORTAL_ADDRESS="IP Address"

# Marketing Array
$arrayMarketing=@('email1@example.com','email2@eample.com')

# HyperV Node Array
$arrayHV = @('node1','node2')

write-host "Environment Variables Loaded"
```

### Allow scripts to run
```powershell
Set-ExecutionPolicy -ExecutionPolicy Remotesigned -Scope LocalMachine
```
