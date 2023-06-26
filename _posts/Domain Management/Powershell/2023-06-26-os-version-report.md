---
title: Get OS Version
date: 2023-06-26 20:00:00 -0500
categories: [Domain Management,Powershell]
tags: [powershell,script,install,updates]
---

### Set Server Array
*I have this setup in my powershell startup script*
```powershell
$arrayHV = @("NODE01","NODE02","NODE03")
```

### Get Report
```powershell
Invoke-Command -ComputerName $arrayHV -ScriptBlock {[Environment]::OSVersion.Version}
```