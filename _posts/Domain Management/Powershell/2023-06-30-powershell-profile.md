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
```powershell
$USER = (Get-ChildItem Env:\USERNAME).value
$PATH = "C:\Users\$USER\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$env = "C:\Users\$USER\.env" | Out-String | ConvertFrom-StringData
Add-Content -Path $PATH -Value $env
Add-Content -Path $PATH -Value "TEST"
```