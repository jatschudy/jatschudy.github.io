---
title: Mass Delete Email
date: 2023-06-07 08:15:00 -0500
categories: [Domain Management,Exchange Online]
tags: [exchange,exo,powershell,script,email management]
---

```powershell
# Log in to Exchange
Connect-ExchangeOnline

#arrayMarketing variable is stored in powershell launch profile

$i = 1

foreach ($item in $arrayMarketing) {
write-host ("Starting trace of $item")
# Set Parameters
$SEND = $item
$endDate = (Get-Date).Date
$startDate = ($endDate).AddDays(-7)
$pageSize = 5000
$maxPage = 1000

# Logging
$logEveryXPages = 1
$outFilePath = ".\OneDrive - IGI Global\Automation\Global Chimp\messageTrace.csv"

# Initialize message variable
$allMessages = @()

$gmtParams = @{
	SenderAddress = $SEND
	#RecipientAddress = $SEND
	StartDate = $startDate
	EndDate = $endDate
	PageSize = $pageSize
	Page = 1
}
do {
	$gmtParams.Page = 1
	
	Write-Host "Starting Message trace until $($gmtParams.EndDate)"
	
	do {
	# Logging
		if ($gmtParams.page % $logEveryXPages -eq 0) {
			Write-Host "Processing Page $($gmtParams.Page)"
		}
	
	$currentMessages = Get-MessageTrace @gmtParams
	$gmtParams.Page++
	$currentMessages | Export-Csv -Path $outFilePath -Append
	if ($gmtParams.Page -gt $maxPage -and $null -ne $currentMessage) {
		$gmtParams.EndDate = $currentMessages.Received | Sort-Object | Select-Object -First 1
	}
	
	Start-Sleep -Seconds 1
	
	} until ( $null -eq $currentMessages -or $gmtParams.Page -gt $maxPage )
} until ( $null -eq $currentMessages )
}
```