---
title: Record Auditor
date: 2023-07-21 13:37:00 -0500
categories: [Automation,Power Automate]
tags: [automate,power automate,automation,script,schedule]
---

#### Overview
This is a barebones script that can be used in desktop automate to run every day at a set time.  Create a text file and save it somewhere that the automate flow can read from it.  Place a phrase with no spaces in it.  This is the text file to read from in the first step of the automate flow.  Now create a scheduled task to pop up a message that is the same as what you placed in the text file.  When Automate sees that message on the screen it reads that text and begins.  This is a workaround to have a daily run automation flow without having a paid for subscription.

```script
LOOP LoopIndex FROM 1 TO 1000 STEP 0
    File.ReadTextFromFile.ReadText File: $'''C:\\Users\\%username%\\key.txt''' Encoding: File.TextFileEncoding.UTF8 Content=> KeyPhrase
    WAIT (OCR.WaitForTextOnScreen.TextOnScreenToAppearWithWindowsOcr TextToFind: KeyPhrase IsRegex: False WindowsOcrLanguage: OCR.WindowsOcrLanguage.English SearchForTextOn: OCR.SearchTarget.EntireScreen ImageWidthMultiplier: 1 ImageHeightMultiplier: 1 TextLocationX=> LocationOfTextFoundX TextLocationY=> LocationOfTextFoundY)
    WAIT 65
    DateTime.GetCurrentDateTime.Local DateTimeFormat: DateTime.DateTimeFormat.DateOnly CurrentDateTime=> CurrentDateTime
    SWITCH CurrentDateTime.DayOfWeek
        CASE = $'''Monday'''
        CASE = $'''Tuesday'''
        CASE = $'''Wednesday'''
        CASE = $'''Thursday'''
        CASE = $'''Friday'''
        CASE = $'''Saturday'''
        CASE = $'''Sunday'''
    END
END
```