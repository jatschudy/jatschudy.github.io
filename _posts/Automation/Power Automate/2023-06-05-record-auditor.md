---
title: Record Auditor
date: 2023-06-04 20:00:00 -0500
categories: [Automation,Power Automate]
tags: [automate,power automate,automation,script]
---

```
Excel.LaunchExcel.LaunchAndOpenUnderExistingProcess Path: $'''C:\\Users\\jtschudy\\OneDrive - IGI Global\\econtent automation\\Publisher Contact List UPDATED.xlsx''' Visible: True ReadOnly: False Instance=> ExcelInstance
Excel.SetActiveWorksheet.ActivateWorksheetByName Instance: ExcelInstance Name: $'''Color Code'''
Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''C''' StartRow: 2 ReadAsText: False CellValue=> totalEntries
Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''E''' StartRow: 2 ReadAsText: False CellValue=> startingRecord
SET LoopIndex TO startingRecord
Excel.SetActiveWorksheet.ActivateWorksheetByName Instance: ExcelInstance Name: $'''Master Publisher List'''
SET activeColumn TO $'''B'''
SET lastPub TO $'''lastPub'''
SET lastWeb TO $'''lastWeb'''
LOOP WHILE (LoopIndex) <= (totalEntries)
    Excel.ActivateCellInExcel.ActivateCell Instance: ExcelInstance Column: $'''D''' Row: LoopIndex
    MouseAndKeyboard.SendKeys.FocusAndSendKeysByInstanceOrHandle WindowInstance: ExcelInstance TextToSend: $'''{Apps}oo{Return}''' DelayBetweenKeystrokes: 10 SendTextAsHardwareKeys: False
    SET lastPub TO Publisher
    Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''C''' StartRow: LoopIndex ReadAsText: False CellValue=> Publisher
    SET lastWeb TO WebAddress
    Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''E''' StartRow: LoopIndex ReadAsText: False CellValue=> WebAddress
    Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''F''' StartRow: LoopIndex ReadAsText: False CellValue=> ContactName
    Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''G''' StartRow: LoopIndex ReadAsText: False CellValue=> ContactEmail
    Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''H''' StartRow: LoopIndex ReadAsText: False CellValue=> ContactTitle
    Excel.ReadFromExcel.ReadCell Instance: ExcelInstance StartColumn: $'''I''' StartRow: LoopIndex ReadAsText: False CellValue=> ContactPhone
    @@statistics_Input_Text: '5'
    @@statistics_Action_Submit: '3'
    Display.ShowCustomDialog CardTemplateJson: '''{
      \"type\": \"AdaptiveCard\",
      \"version\": \"1.4\",
      \"id\": \"AdaptiveCard\",
      \"body\": [
        {
          \"type\": \"Input.Text\",
          \"id\": \"Publisher\",
          \"value\": \"${Publisher_Value}\",
          \"label\": \"${Publisher_Label}\"
        },
        {
          \"type\": \"Input.Text\",
          \"id\": \"Contact Name\",
          \"value\": \"${Contact_Name_Value}\",
          \"label\": \"${Contact_Name_Label}\"
        },
        {
          \"type\": \"Input.Text\",
          \"id\": \"Email\",
          \"value\": \"${Email_Value}\",
          \"style\": \"email\",
          \"label\": \"${Email_Label}\"
        },
        {
          \"type\": \"Input.Text\",
          \"id\": \"Contact Title\",
          \"value\": \"${Contact_Title_Value}\",
          \"label\": \"${Contact_Title_Label}\"
        },
        {
          \"type\": \"Input.Text\",
          \"id\": \"Phone Number\",
          \"value\": \"${Phone_Number_Value}\",
          \"style\": \"tel\",
          \"label\": \"${Phone_Number_Label}\"
        }
      ],
      \"actions\": [
        {
          \"type\": \"Action.Submit\",
          \"id\": \"Submit\",
          \"title\": \"${Submit_Title}\"
        },
        {
          \"type\": \"Action.Submit\",
          \"id\": \"Purge\",
          \"title\": \"${Purge_Title}\"
        },
        {
          \"type\": \"Action.Submit\",
          \"id\": \"New Record\",
          \"title\": \"${New_Record_Title}\"
        }
      ]
    }''' CustomFormData=> CustomFormData ButtonPressed=> ButtonPressed @Publisher_Label: $'''Publisher''' @Publisher_Value: Publisher @Contact_Name_Label: $'''Contact Name''' @Contact_Name_Value: ContactName @Email_Label: $'''Email''' @Email_Value: ContactEmail @Contact_Title_Label: $'''Contact Title''' @Contact_Title_Value: ContactTitle @Phone_Number_Label: $'''Phone Number''' @Phone_Number_Value: ContactPhone @Submit_Title: $'''Submit''' @Purge_Title: $'''Purge Record''' @New_Record_Title: $'''New Record'''
    DateTime.GetCurrentDateTime.Local DateTimeFormat: DateTime.DateTimeFormat.DateAndTime CurrentDateTime=> CurrentDateTime
    SWITCH ButtonPressed
        CASE = $'''New Record'''
            LOOP WHILE (ButtonPressed) <> ($'''Done''')
                @@statistics_Input_Text: '6'
                @@statistics_Action_Submit: '2'
                Display.ShowCustomDialog CardTemplateJson: '''{
                  \"type\": \"AdaptiveCard\",
                  \"version\": \"1.4\",
                  \"id\": \"AdaptiveCard\",
                  \"body\": [
                    {
                      \"type\": \"Input.Text\",
                      \"id\": \"Publisher\",
                      \"value\": \"${Publisher_Value}\",
                      \"label\": \"${Publisher_Label}\"
                    },
                    {
                      \"type\": \"Input.Text\",
                      \"id\": \"Website Address\",
                      \"value\": \"${Website_Address_Value}\",
                      \"label\": \"${Website_Address_Label}\"
                    },
                    {
                      \"type\": \"Input.Text\",
                      \"id\": \"Contact Name\",
                      \"value\": \"\",
                      \"label\": \"${Contact_Name_Label}\"
                    },
                    {
                      \"type\": \"Input.Text\",
                      \"id\": \"Email\",
                      \"value\": \"\",
                      \"style\": \"email\",
                      \"label\": \"${Email_Label}\"
                    },
                    {
                      \"type\": \"Input.Text\",
                      \"id\": \"Contact Title\",
                      \"value\": \"\",
                      \"label\": \"${Contact_Title_Label}\"
                    },
                    {
                      \"type\": \"Input.Text\",
                      \"id\": \"Phone Number\",
                      \"value\": \"\",
                      \"style\": \"tel\",
                      \"label\": \"${Phone_Number_Label}\"
                    }
                  ],
                  \"actions\": [
                    {
                      \"type\": \"Action.Submit\",
                      \"id\": \"Add\",
                      \"title\": \"${Add_Title}\"
                    },
                    {
                      \"type\": \"Action.Submit\",
                      \"id\": \"Done\",
                      \"title\": \"${Done_Title}\"
                    }
                  ]
                }''' CustomFormData=> CustomFormData ButtonPressed=> ButtonPressed @Publisher_Label: $'''Publisher''' @Publisher_Value: lastPub @Website_Address_Label: $'''Website Address''' @Website_Address_Value: lastWeb @Contact_Name_Label: $'''Contact Name''' @Email_Label: $'''Email''' @Contact_Title_Label: $'''Contact Title''' @Phone_Number_Label: $'''Phone Number''' @Add_Title: $'''Add''' @Done_Title: $'''Done'''
                IF ButtonPressed <> $'''Done''' THEN
                    Variables.IncreaseVariable Value: totalEntries IncrementValue: 1
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Publisher'] Column: $'''C''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Website Address'] Column: $'''E''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Contact Name'] Column: $'''F''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Email'] Column: $'''G''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Contact Title'] Column: $'''H''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Phone Number'] Column: $'''I''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: $'''Clear for communications''' Column: $'''L''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: $'''%CurrentDateTime.Month%/%CurrentDateTime.Day%/%CurrentDateTime.Year%''' Column: $'''J''' Row: totalEntries
                    Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: $'''%CurrentDateTime.Month%/%CurrentDateTime.Day%/%CurrentDateTime.Year%''' Column: $'''B''' Row: totalEntries
                END
            END
        CASE = $'''Submit'''
            Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Publisher'] Column: $'''C''' Row: LoopIndex
            Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Contact Name'] Column: $'''F''' Row: LoopIndex
            Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Email'] Column: $'''G''' Row: LoopIndex
            Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Contact Title'] Column: $'''H''' Row: LoopIndex
            Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: CustomFormData['Phone Number'] Column: $'''I''' Row: LoopIndex
            Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: $'''Clear for communications''' Column: $'''L''' Row: LoopIndex
            Excel.WriteToExcel.WriteCell Instance: ExcelInstance Value: $'''%CurrentDateTime.Month%/%CurrentDateTime.Day%/%CurrentDateTime.Year%''' Column: $'''J''' Row: LoopIndex
            Variables.IncreaseVariable Value: LoopIndex IncrementValue: 1
        CASE = $'''Purge'''
            @@statistics_TextBlock: '1'
            @@statistics_Action_Submit: '2'
            Display.ShowCustomDialog CardTemplateJson: '''{
              \"type\": \"AdaptiveCard\",
              \"version\": \"1.4\",
              \"id\": \"AdaptiveCard\",
              \"body\": [
                {
                  \"type\": \"TextBlock\",
                  \"id\": \"Text block\",
                  \"text\": \"${Text_block_Text}\"
                }
              ],
              \"actions\": [
                {
                  \"type\": \"Action.Submit\",
                  \"id\": \"Confirm\",
                  \"title\": \"${Confirm_Title}\"
                },
                {
                  \"type\": \"Action.Submit\",
                  \"id\": \"Cancel\",
                  \"title\": \"${Cancel_Title}\"
                }
              ]
            }''' CustomFormData=> CustomFormData2 ButtonPressed=> ButtonPressed2 @Text_block_Text: $'''Are you sure?''' @Confirm_Title: $'''Confirm''' @Cancel_Title: $'''Cancel'''
            IF ButtonPressed2 = $'''Confirm''' THEN
                Excel.DeleteRow Instance: ExcelInstance Index: LoopIndex
            END
    END
    Excel.SaveExcel.Save Instance: ExcelInstance
END

```