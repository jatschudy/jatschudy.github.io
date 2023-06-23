---
title: Failover Clustering
date: 2023-06-21 20:00:00 -0500
categories: [Domain Management,Hyper-V]
tags: [hypervisor,hyperv,hyper-v,powershell,script,virtualization,failover,cluster]
---

### Install Necessary Features
*Installs the failover clustering and enables the MultiPathIO features.  Upon completion, server will restart.*
```powershell
Invoke-Command -ComputerName HYPERV-TEST-01,HYPERV-TEST-02 -ScriptBlock {
    Install-WindowsFeature -Name Failover-Clustering -Restart
    Enable-WindowsOptionalFeature -Online -FeatureName MultiPathIO
    Restart-Computer -force
}

```

### Install HyperV Management Tools on Workstation
*Enable iSCSI Disk Support, set failover policy and enable path verification.  Upon completion, server will restart.*
**Failover Policy Options**
- **None**: Clears any currently configured default load balance policy.
- **FOO**: Fail Over Only. (Recommended)
- **RR**: Round Robin.
- **LQD**: Least Queue Depth.
- **LB**: Least Blocks.

```powershell
Invoke-Command -ComputerName HYPERV-TEST-01,HYPERV-TEST-02 -ScriptBlock {
    Enable-MSDSMAutomaticClaim -BusType "iSCSI"
    Set-MSDSMGlobalDefaultLoadbalancePolicy -Policy FOO
    Set-MPIOSetting -NewPathVerificationState Enabled
    Restart-Computer -force
}

```

### Configure iSCSI Service
*Connect to iSCSI Portal and list get target addresses*
```powershell
Invoke-Command -ComputerName HYPERV-TEST-01,HYPERV-TEST-02 -ScriptBlock {
    Set-Service -Name msiscsi -StartupType "Automatic"
    Start-Service msiscsi
    New-iscsitargetportal -TargetPortalAddress 192.168.1.2
    Get-IscsiTargetPortal | Update-IscsiTargetPortal
    Get-IscsiTarget
}

```

*Make the Connections*
```powershell
Invoke-Command -ComputerName HYPERV-TEST-01,HYPERV-TEST-02 -ScriptBlock {
    $ipAddress = (Get-NetIPAddress | Where-Object {$_.AddressState -eq "Preferred" -and $_.ValidLifetime -lt "24:00:00"}).IPAddress
    $targetAddress = '192.168.1.2'
    Connect-iscsitarget -nodeaddress iqn.2005-10.org.freenas.ctl:quorum -IsPersistent $true -InitiatorPortalAddress $ipAddress -TargetPortalAddress $targetAddress
    Connect-iscsitarget -nodeaddress iqn.2005-10.org.freenas.ctl:storage -IsPersistent $true -InitiatorPortalAddress $ipAddress -TargetPortalAddress $targetAddress
}
Invoke-Command -ComputerName HYPERV-TEST-01,HYPERV-TEST-02 -ScriptBlock {
    Get-iSCSIsession | Register-iSCSIsession
}
Invoke-Command -ComputerName HYPERV-TEST-01,HYPERV-TEST-02 -ScriptBlock {Get-IscsiTarget}

```

### Enable Format Drives
*Use Remote Desktop to access one of the nodes to do the following steps.  If all prior steps were followed, these steps only need performed on one node.*
1. Open RDP and remote to one of the nodes
2. Get to command line
3. Enter 'diskpart'

*You are now in diskpart.  The following commands will be repeated for each drive you need to format.  '#' will stand in for the disk number as this may vary.  Be careful not to format the wrong disk.*
1. list disk
2. Select Disk #
3. clean
4. create partition primary
5. format fs=ntfs