# MECM Toolkit - Task Sequences - Features - News & Interests

&nbsp;

## Table of Contents

- [MECM Toolkit - Task Sequences - Features - News \& Interests](#mecm-toolkit---task-sequences---features---news--interests)
  - [Table of Contents](#table-of-contents)
  - [Disable News \& Interests](#disable-news--interests)

&nbsp;

## Disable News & Interests

```powershell
# -------------------------------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
# -------------------------------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Disable News & Interests"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      April 05, 2018"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   Removes all of the identified appx applications from Windows."
    Write-Host "    Reference: "
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
# -------------------------------------------------------------------------------------------------------------------

<# -------------------------------------------------------------------------------------------------------------------
    Define Variables
----------------------------------------------------------------------------------------------------------------------
    Define the variables used within the script
------------------------------------------------------------------------------------------------------------------- #>
#Region

    Write-Host "  Define Variables"

    $Registry_Path          = "HKLM:\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
    $Registry_Property      = "ShellFeedsTaskbarViewMode"
    $Registry_PropertyType  = "DWORD"
    $Registry_Value         = "2"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Define Variables
# -------------------------------------------------------------------------------------------------------------------


<# -------------------------------------------------------------------------------------------------------------------
    Apply Registry Settings
----------------------------------------------------------------------------------------------------------------------
    Apply registry settings to the default users profile during imaging to apply to all new users
------------------------------------------------------------------------------------------------------------------- #>
#Region

    Write-Host "  Apply Registry Settings"

    # Load Default User Registry Hive
        Write-Host "    - Load Default User Registry Hive"
        $Return = & REG LOAD HKLM\DEFAULT C:\Users\Default\NTUSER.DAT
        Write-Host "        Return: $($Return[0])"

    # Create or Update Registry
        if (!(Test-Path -Path $Registry_Path)) {
            # Create Missing Property
                Write-Host "    - Create Missing Property"
                $Item = New-Item -Path $Registry_Path -Force
                New-ItemProperty -Path $Registry_Path -Name $Registry_Property -PropertyType $Registry_PropertyType -Value $Registry_Value -Force | Out-Null

            # Close Open Handles
                $Item.Handle.Close()
        }
        else {
            # Update Existing Property
                Write-Host "    - Update Existing Property"
                Set-ItemProperty -Path $Registry_Path -Name $Registry_Property -Value $Registry_Value -Force
        }

        Write-Host "    - Complete"
        Write-Host ""

#EndRegion Apply Registry Settings
# -------------------------------------------------------------------------------------------------------------------

<# -------------------------------------------------------------------------------------------------------------------
    Cleanup
----------------------------------------------------------------------------------------------------------------------
    Perform cleanup tasks before exiting the script
------------------------------------------------------------------------------------------------------------------- #>
#Region

    Write-Host "  Cleanup"

    # Garbage Collection
        Write-Host "    - Garbage Collection"
        [gc]::Collect()

    # Unload Default User Registry Hive
        Write-Host "    - Unload Default User Registry Hive"
        Start-Sleep -Seconds 10
        $Return = & REG UNLOAD HKLM\DEFAULT
        Write-Host "        Return: $($Return[0])"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Cleanup
# -------------------------------------------------------------------------------------------------------------------
```