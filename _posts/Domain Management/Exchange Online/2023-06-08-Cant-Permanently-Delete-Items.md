---
title: Can't Permanently Delete Items
date: 2023-06-07 08:15:00 -0500
categories: [Domain Management,Exchange Online]
tags: [exchange,exo,powershell,script,email management]
---

### Scenario
The user is unable to delete email from their mailbox.  Any attempt to do so produces a message stating "You can't permanently delete these items" and informs them to try deleting the "Recoverable Items" folder.  Emptying that folder does not help.

*You will need 

### Reduce Recovery Capability
Once done deleting you will want to return these settings to their original state

```powershell
# Connect to Exchange
Connect-ExchangeOnline

$MAILBOX = read-host -Prompt "Enter the user's email address"

# Display current settings
get-mailbox $MAILBOX | FL SingleItemRecoveryEnabled,RetainDeletedItemsFor
$CONFIRM = read-host -Prompt "Do you want to change this user's settings? Y/N"

if ($CONFIRM -eq "Y") -or ($CONFIRM -eq "y") {
    Set-Mailbox $MAILBOX -RetainDeletedItemsFor 1.00:00:00
    Set-Mailbox $MAILBOX -SingleItemRecoveryEnabled $False
    Start-ManagedFolderAssistant $MAILBOX
    get-mailbox $MAILBOX | FL SingleItemRecoveryEnabled,RetainDeletedItemsFor
}
else {
    write-host "No changes have been made."
}
```

### Restore Recovery Settings
```powershell
# Connect to Exchange
Connect-ExchangeOnline

$MAILBOX = read-host -Prompt "Enter the user's email address"

# Display current settings
get-mailbox $MAILBOX | FL SingleItemRecoveryEnabled,RetainDeletedItemsFor
$CONFIRM = read-host -Prompt "Do you want to change this user's settings? Y/N"

if ($CONFIRM -eq "Y") -or ($CONFIRM -eq "y") {
    Set-Mailbox $MAILBOX -RetainDeletedItemsFor 14.00:00:00
    Set-Mailbox $MAILBOX -SingleItemRecoveryEnabled $True
    Start-ManagedFolderAssistant $MAILBOX
    get-mailbox $MAILBOX | FL SingleItemRecoveryEnabled,RetainDeletedItemsFor
}
else {
    write-host "No changes have been made."
}
```