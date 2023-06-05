---
title: Exchange Online with Powershell
date: 2023-06-04 20:00:00 -0500
categories: [Domain Management,Exchange Online]
tags: [exchange,exo,powershell,script,email management]
---

### Connect with credentials
```powershell
# Install/Import required module
Install-Module -Name ExchangeOnlineManagement -AllowClobber -Force -Verbose
Import-Module ExchangeOnlineManagement

# Log in to Exchange
Connect-ExchangeOnline

```