---
title: Marketing Mail Report
date: 2023-06-04 20:00:00 -0500
categories: [Automation,Reports]
tags: [automate,powershell,automation,script]
---

### Collect email from last 7 days
Run once for each account wanted.  It will compile all emails sent from that account and append them to a csv. Automating this to run on Saturday would be ideal but Connect-ExchangeOnline does not work correctly without initial user input.
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
$outFilePath = ".\messageTrace.csv"

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
### Message Trace
This will read through all records exported in the previous step and create a file with the details in a folder called "report".  These are used later in power automate.
```powershell
$csv = Import-CSV ".\messageTrace.csv"
$totalmbx = $csv.Count
$i = 0
$endDate = (Get-Date).Date
$startDate = ($endDate).AddDays(-6)

foreach ($RECORD in $csv) {
	
	$DATA = Get-MessageTraceDetail -MessageTraceID $RECORD.MessageTraceId -RecipientAddress $RECORD.RecipientAddress -StartDate $startDate -EndDate $endDate | select Event,Detail
	$name = $RECORD.MessageTraceId
	$DATA | Export-Csv -Path ".\report\$name.txt"
	$i++
	Write-Host "Progress: $i out of $totalmbx completed"
}

```