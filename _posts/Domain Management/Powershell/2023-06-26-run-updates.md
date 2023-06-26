---
title: Run Remote Updates
date: 2023-06-26 20:00:00 -0500
categories: [Domain Management,Powershell]
tags: [powershell,script,install,updates]
---

### Install Dependencies
*Create System Array*
```powershell
$SERVERS = @("NODE01","NODE02","NODE03")
```
*Then run this script to install dependencies*
```powershell
Invoke-Command ($SERVERS) {
    If ($null -eq (Get-Module -Name PSWindowsUpdate -ListAvailable)){
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Install-Module PSWindowsUpdate -Force
        Import-Module PSWindowsUpdate
    }
}
```
*Check OS Version*
```powershell
$Results = @()
foreach ($SERVER in $SERVERS) {
    $Version = Invoke-Command ($SERVERS) { [Environment]::OSVersion } -ErrorAction SilentlyContinue
    if ($null -eq $Version) {
        $Results += [PSCustomObject]@{
            "ComputerName" = $SERVER
            "Version" = "(Device offline)"
        }
    } else {
        $Results += [PSCustomObject]@{
            "ComputerName" = $SERVER
            "Version" = $Version.Version.ToString()
        }
    }
}
$Results

```

*Install Updates* ***NOT WORKING REMOTELY***
```powershell
Invoke-WuJob -ComputerName $SERVERS -Script {ipmo PSWindowsUpdate; Install-WindowsUpdate -AcceptAll -AutoReboot | Out-File "C:\Windows\PSWindowsUpdate.log"} -RunNow -Confirm:$false -Verbose -ErrorAction Ignore
```