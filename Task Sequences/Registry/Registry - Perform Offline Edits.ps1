#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
    [string]$OSDrive            # '%OSDTargetSystemDrive%'
)

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Registry - Perform Offline Edits"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 24, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will open the system registry on the target OS drive"
    Write-Host "               and apply any changes that you have defined."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    Write-Host "  Set Variables"

    # Paths
        $Registry_Hive_Name         = "SYSTEM"  # SOFTWARE,SYSTEM
        $Registry_Hive_FilePath     = "$OSDrive\Windows\System32\config\$Registry_Hive_Name"
        $Registry_Hive_LoadPath     = "HKLM\OfflineTemp"


    # Output to Log
        Write-Host "      - OS Drive: $($OSDrive)"
        Write-Host "      - Hive Name: $($Registry_Hive_Name)"
        Write-Host "      - Hive File Path: $($Registry_Hive_FilePath)"
        Write-Host "      - Hive Load Path: $($Registry_Hive_LoadPath)"

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validate Data
#--------------------------------------------------------------------------------------------

    Write-Host "  Validate Data"

    # Validate Registry Hive File Exists
        Write-Host "      - Registry Hive File Exists"

        If (Test-Path $Registry_Hive_FilePath) {
            Write-Host "          Success: Hive File Exists"
        }
        Else {
            Write-Host "          Error: Hive File Not Exists"
            Exit 1201
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Create Environment
#--------------------------------------------------------------------------------------------

    Write-Host "  Create Environment"

    # Load Registry Hive
        Write-Host "      - Load Registry Hive"

        try {
            reg load $Registry_Hive_LoadPath $Registry_Hive_FilePath | Out-Null
            Write-Host "          Success: Loaded Registry Hive"
        }
        catch {
            Write-Host "          Error: Failed to Load Registry Hive"
            Exit 1301
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Modify Registry
#--------------------------------------------------------------------------------------------

    Write-Host "  Modify Registry"

    # Enable NetJoinLegacyAccountReuse
        Write-Host "      - Enable NetJoinLegacyAccountReuse"

        try {
            # Define Variables
                #$Temp_RegistryPath  = "$($Registry_Hive_LoadPath.Replace("\",":\"))\System\CurrentControlSet\Control\LSA"
                $Temp_RegistryPath  = "$($Registry_Hive_LoadPath.Replace("\",":\"))\ControlSet001\Control\LSA"
                $Temp_PropertyName  = "NetJoinLegacyAccountReuse"
                $Temp_PropertyValue = "1"
                $Temp_PropertyType  = "DWORD"

            # Output to Log
                $Temp_Variables = Get-Variable "Temp_*"
                foreach ($Item in $Temp_Variables) {
                    Write-Host "      - $($item.Name): $($Item.Value)"
                }

            # Add/Modify Property Value Pair
                New-ItemProperty -Path $Temp_RegistryPath -Name $Temp_PropertyName -Value $Temp_PropertyValue -PropertyType $Temp_PropertyType -Force -ErrorAction Stop | Out-Null

            Write-Host "          Success: Enabled NetJoinLegacyAccountReuse"
        }
        catch {
            Write-Host "          Error: Failed to Enable NetJoinLegacyAccountReuse"
            Write-Host $Error[0]
            Exit 1401
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup Environment
#--------------------------------------------------------------------------------------------

    Write-Host "  Cleanup Environment"

    # Remove Variables
        Write-Host "      - Remove Variables"

        try {
            Get-Variable -Name "Registry*" | Remove-Variable
            Write-Host "          Success: Variables Removed"
        }
        catch {
            Write-Host "          Error: Failed to Remove Variables"
            Exit 1501
        }

    # Run Garbage Collector
        Write-Host "      - Run Garbage Collector"

        try {
            [gc]::collect()
            [gc]::WaitForPendingFinalizers()
            Start-Sleep -Seconds 5 -ErrorAction Stop
            Write-Host "          Success: Garbage Collection Complete"
        }
        catch {
            Write-Host "          Error: Failed to Run Garbage Collector"
            Exit 1502
        }

    # Unload Registry Hive
        Write-Host "      - Unload Registry Hive"

        try {
            Set-Location -Path "X:\" -ErrorAction Stop
            reg unload "HKLM\OfflineTemp" | Out-Null
            Write-Host "          Success: Registry Hive Unloaded"
        }
        catch {
            Write-Host "          Error: Failed to Unload Registry Hive"
            Exit 1503
        }

    Write-Host "      - Complete"
    Write-Host ""

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# End of Script
#--------------------------------------------------------------------------------------------

    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#--------------------------------------------------------------------------------------------
