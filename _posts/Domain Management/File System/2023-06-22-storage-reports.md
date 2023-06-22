---
title: Storage Report
date: 2023-06-22 08:00:00 -0500
categories: [Domain Management,File System]
tags: [powershell,script,file server,file system,storage use]
---

### List size of each directory at the entered path
*Use this one if you have environment variables set*
```powershell
Enter-PSSession -ComputerName $env.PRIMARY_FS
$PATH = Read-Host -Prompt "Enter Directory Path"
$ARRAY = Get-ChildItem -Path $PATH | Where-Object {$_.PSIsContainer -eq $true}
foreach ($item in $ARRAY) {
    $RESULT = "{0:N2} GB" -f ((gci $PATH/$item -Recurse -ErrorAction SilentlyContinue | measure Length -s).sum /1Gb)
    write-host $item";"$RESULT
}

```
*This one if you need to input the server to connect to*
```powershell
$SERVER = Read-Host -Prompt "Enter Server Name"
Enter-PSSession -ComputerName $SERVER
$PATH = Read-Host -Prompt "Enter Directory Path"
$ARRAY = Get-ChildItem -Path $PATH | Where-Object {$_.PSIsContainer -eq $true}
foreach ($item in $ARRAY) {
    write-host $item
    "{0:N2} GB" -f ((gci $PATH/$item -Recurse -ErrorAction SilentlyContinue | measure Length -s).sum /1Gb)
}

```