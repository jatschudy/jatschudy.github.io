> - Paste this block into powershell.  
> - The very last line will prompt you to change the new user's password.  There may be warnings about security.  These can be ignored.

```powershell
# Connect to the Domain Controller
Enter-PSSession -ComputerName $env.PRIMARY_DC;

# Import necessary module
Import-Module ActiveDirectory

# Gather Information
$NAME = Read-Host -Prompt "Enter First and Last name separated by a space: ";

# Create more variables form user input
$first,$last = ($NAME.tolower()).Split(" ");
$USERNAME = $first[0]+$last;
$first,$last = ($NAME).Split(" ");
$PASSWORD = (ConvertTo-SecureString "ch@ng3M3" -AsPlainText -Force)

# Create the user.  Not all attributes can be set here.  The rest are done later
New-ADUser `
 -Name $NAME `
 -SamAccountName  $USERNAME `
 -DisplayName $NAME `
 -AccountPassword $PASSWORD `
 -ChangePasswordAtLogon $true  `
 -Enabled $true

# Add to Groups
Add-ADGroupMember "Default Group" $USERNAME;

# General Tab
Set-ADUser -Identity $USERNAME -GivenName $first;
Set-ADUser -Identity $USERNAME -Surname $last;
Set-ADUser -Identity $USERNAME -Description $TITLE;
Set-ADUser -Identity $USERNAME -Office $env.OFFICE;
Set-ADUser -Identity $USERNAME -EmailAddress $USERNAME$env.MAIL_DOMAIN;
Set-ADUser -Identity $USERNAME -HomePage $env.HOMEPAGE;

# Address Tab
Set-ADUser -Identity $USERNAME -StreetAddress $env.STREEADDRESS;
Set-ADUser -Identity $USERNAME -City $env.CITY;
Set-ADUser -Identity $USERNAME -State $env.STATE;
Set-ADUser -Identity $USERNAME -PostalCode $env.ZIP;
# Set-ADUser -Identity $USERNAME -Country 'United States'; --Needs Fixed

# Account Tab
Set-ADUser -Identity $USERNAME -UserPrincipalName $USERNAME$env.MAIL_DOMAIN;
Set-ADUser -Identity $USERNAME -PasswordNeverExpires 1;

# Organization Tab
Set-ADUser -Identity $USERNAME -Title $TITLE;
set-ADUser -Identity $USERNAME -Department $DEPT;
Set-ADUser -Identity $USERNAME -Company $env.COMPANY;
# Set Manager not added yet

# Move User to proper OU, Not added yet.

#Reset the password.  There will be warnings about security
Set-ADAccountPassword -Identity $USERNAME -OldPassword $PASSWORD;
```