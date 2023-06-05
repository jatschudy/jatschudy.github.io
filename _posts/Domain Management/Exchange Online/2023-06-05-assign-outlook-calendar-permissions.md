---
title: Assign Outlook Calendar Permissions
date: 2023-06-04 20:00:00 -0500
categories: [Domain Management,Exchange Online]
tags: [exchange,exo,powershell,script,email management]
---

### Check Permissions

```powershell
$MAILBOX = Read-Host -Prompt "Email Address you are checking permissions for: "
Get-MailboxFolderPermission ($MAILBOX+":\calendar")

```

### Grant Editor Permissions
```powershell
$MAILBOX = Read-Host -Prompt "Email Address of calendar to share: "
$USER = Read-Host -Prompt "Email Address of user to receive access: "
Add-MailboxFolderPermission -Identity ($MAILBOX+":\calendar") -user $USER -AccessRights Editor

```