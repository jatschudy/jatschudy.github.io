---
title: Storage Report
date: 2023-06-22 08:00:00 -0500
categories: [Domain Management,File System]
tags: [powershell,script,file server,file system,storage use]
---

### Get a report on a directory showing file sizes
*Use this one if you have environment variables set*
```powershell
Enter-PSSession -ComputerName $env.PRIMARY_FS
$PATH = Read-Host -Prompt "Enter Directory Path"
gci -force $PATH -ErrorAction SilentlyContinue | ? { $_ -is [io.directoryinfo] } | % { 
    $len = 0
    gci -recurse -force $_.fullname -ErrorAction SilentlyContinue | % { $len += $_.length }
    $_.fullname, '{0:N2}' GB' -f ($len /1Gb)
}

```
*This one if you need to input the server to connect to*
```powershell
$SERVER = Read-Host -Prompt "Enter Server Name"
Enter-PSSession -ComputerName $SERVER
$PATH = Read-Host -Prompt "Enter Directory Path"
"{0:N2} GB" -f ((gci $PATH -Recurse -ErrorAction SilentlyContinue | measure Length -s).sum /1Gb)

```