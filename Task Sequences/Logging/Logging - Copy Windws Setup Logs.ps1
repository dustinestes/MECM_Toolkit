#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

param (
  [string]$DestinationPath				# '"$($env:vr_Directory_Logs)\TaskSequences\Windows"'    Directory to copy the logs to
)

#--------------------------------------------------------------------------------------------
# Start-Transcript -Path "C:\VividRock\MECM Toolkit\Logs\Task Sequences\Logging - Copy Windows Setup Logs.log" -ErrorAction SilentlyContinue

#--------------------------------------------------------------------------------------------
# Header
#--------------------------------------------------------------------------------------------
#Region Header

  Write-Host "------------------------------------------------------------------------------"
  Write-Host "  MECM Toolkit - Task Sequences - Logging - Copy Windows Setup Logs"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host "    Author:     Dustin Estes"
  Write-Host "    Company:    VividRock"
  Write-Host "    Date:       October 16, 2025"
  Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
  Write-Host "    Purpose:   This script will attempt to locate all the log files associated"
  Write-Host "               with the different phases of the install process and then copy"
  Write-Host "               them to a central location for analysis."
  Write-Host "    Links:      [Links to Helpful Source Material]"
  Write-Host "    Template:   1.1"
  Write-Host "------------------------------------------------------------------------------"
  Write-Host ""

#EndRegion Header
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables

  Write-Host "  Variables"

  # Parameters
    $Param_DestinationPath  = $DestinationPath

  # Metadata
    $Meta_Script_Start_DateTime     = Get-Date
    $Meta_Script_Complete_DateTime  = $null
    $Meta_Script_Complete_TimeSpan  = $null
    $Meta_Script_Execution_User     = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Meta_Script_Result = $false,"Failure"

  # Preferences
    $ErrorActionPreference        = "Stop"
    $CMPSSuppressFastNotUsedCheck = $true

  # Names

  # Paths
  $Path_Windows_Logs = @(
    # Source Active Directory Domain Join Troubleshooting | Microsoft Learn
    "$($env:windir)\debug\netsetup.log"         	              # Domain join activities.

    # Source: Sysprep Log Files | Microsoft Learn
    "$($env:windir)\System32\Sysprep\Panther\setupact.log"	            # Sysprep logs for the Generalize pass.
    "$($env:windir)\System32\Sysprep\Panther\setuperr.log"	            # Sysprep logs for the Generalize pass.
    "$($env:windir)\System32\Sysprep\Panther\miglog.xml"	              # Sysprep logs for the Generalize pass.
    "$($env:windir)\System32\Sysprep\Panther\PreGatherPnPList.log"	    # Sysprep logs for the Generalize pass.
    "$($env:windir)\System32\Sysprep\Panther\PostGatherPnPList.log"	    # Sysprep logs for the Generalize pass.
    "$($env:windir)\Panther\setupact.log"	                              # Sysprep logs for the Specialize pass.
    "$($env:windir)\Panther\setuperr.log"	                              # Sysprep logs for the Specialize pass.
    "$($env:windir)\Panther\UnattendGC\setupact.log"	                  # Sysprep logs for the Unattended Windows Setup actions (OOBE) pass.
    "$($env:windir)\Panther\UnattendGC\setuperr.log"	                  # Sysprep logs for the Unattended Windows Setup actions (OOBE) pass.

    # Source: Windows Setup Log File Locations | Microsoft Learn
    # Down Level Phase
    "C:\WINDOWS\setupapi.log"                                 	  # Device changes, driver changes, and major system changes, such as service pack installations and hotfix installations. This log file is used only by Microsoft Windows XP and earlier versions.
    "C:\`$WINDOWS.~BT\Sources\Panther\setupact.log"               # Setup actions during the installation.
    "C:\`$WINDOWS.~BT\Sources\Panther\setuperr.log"               # Setup errors during the installation.
    "C:\`$WINDOWS.~BT\Sources\Panther\miglog.xml"                 # User directory structure. This information includes security identifiers (SIDs).
    "C:\`$WINDOWS.~BT\Sources\Panther\PreGatherPnPList.log"       # Initial capture of devices that are on the system during the downlevel phase.
    # Windows Preinstallation Environment Phase
    "X:\`$WINDOWS.~BT\Sources\Panther\setupact.log"	      		    # Setup actions during the installation.
    "X:\`$WINDOWS.~BT\Sources\Panther\setuperr.log"	      		    # Setup errors during the installation.
    "X:\`$WINDOWS.~BT\Sources\Panther\miglog.xml"	                # User directory structure. This information includes security identifiers (SIDs).
    "X:\`$WINDOWS.~BT\Sources\Panther\PreGatherPnPList.log"       # Initial capture of devices that are on the system during the downlevel phase.
    "X:\WINDOWS\Setupact.log"                                     # Progress of the initial options that are selected on the Windows installation screen.
    "C:\`$WINDOWS.~BT\Sources\Panther\setupact.log"	      		    # Setup actions during the installation.
    "C:\`$WINDOWS.~BT\Sources\Panther\setuperr.log"	      		    # Setup errors during the installation.
    "C:\`$WINDOWS.~BT\Sources\Panther\miglog.xml"	                # User directory structure. This information includes security identifiers (SIDs).
    "C:\`$WINDOWS.~BT\Sources\Panther\PreGatherPnPList.log"		    # Initial capture of devices that are on the system during the downlevel phase.
    # Online Configuration Phase
    "C:\WINDOWS\PANTHER\setupact.log"	                            # Setup actions during the installation.
    "C:\WINDOWS\PANTHER\setuperr.log"	                            # Setup errors during the installation.
    "C:\WINDOWS\PANTHER\miglog.xml"	                              # User directory structure. This information includes security identifiers (SIDs).
    "C:\WINDOWS\INF\setupapi.dev.log"	                            # Plug and Play devices and driver installations.
    "C:\WINDOWS\INF\setupapi.app.log"	                            # Application installations.
    "C:\WINDOWS\Panther\PostGatherPnPList.log"	                  # Capture of devices that are on the system after the online configuration phase.
    "C:\WINDOWS\Panther\PreGatherPnPList.log"	                    # Initial capture of devices that are on the system during the downlevel phase.
    # Windows Welcome Phase
    "C:\WINDOWS\PANTHER\setupact.log"	                            # Setup actions during the installation.
    "C:\WINDOWS\PANTHER\setuperr.log"	                            # Setup errors during the installation.
    "C:\WINDOWS\PANTHER\miglog.xml"	                              # User directory structure. This information includes security identifiers (SIDs).
    "C:\WINDOWS\INF\setupapi.dev.log"	                            # Plug and Play devices and driver installations.
    "C:\WINDOWS\INF\setupapi.app.log"	                            # Application installations.
    "C:\WINDOWS\Panther\PostGatherPnPList.log"	                  # Capture of devices that are on the system after the online configuration phase.
    "C:\WINDOWS\Panther\PreGatherPnPList.log"	                    # Initial capture of devices that are on the system during the downlevel phase.
    "C:\WINDOWS\Performance\Winsat\winsat.log"	                  # Windows System Assessment Tool performance testing results.
    # Rollback Phase
    "C:\`$WINDOWS.~BT\Sources\Panther\setupact.log"	              # Setup actions during the installation.
    "C:\`$WINDOWS.~BT\Sources\Panther\miglog.xml"	                # User directory structure. This information includes security identifiers (SIDs).
    "C:\`$WINDOWS.~BT\Sources\Panther\setupapi\setupapi.dev.log"	# Plug and Play devices and driver installations.
    "C:\`$WINDOWS.~BT\Sources\Panther\setupapi\setupapi.app.log"	# Application installations.
    "C:\`$WINDOWS.~BT\Sources\Panther\PreGatherPnPList.log"	      # Initial capture of devices that are on the system during the downlevel phase.
    "C:\`$WINDOWS.~BT\Sources\Panther\PostGatherPnPList.log"	    # Capture of devices that are on the system after the online configuration phase.
  )

  # Files

  # Hashtables

  # Arrays

  # Registry

  # WMI

  # Datasets
  $Dataset_Windows_Logs = @()

  # Temporary

  # Output to Log
    Write-Host "    - Parameters"
    foreach ($Item in $PSBoundParameters.GetEnumerator()) {
      Write-Host "        $($Item.Key.PadRight(($PSBoundParameters.Keys | Measure-Object -Property Length -Maximum).Maximum + 1)): $($Item.Value)"
    }
    Write-Host "    - Paths"
    foreach ($Item in (Get-Variable -Name "Path_*")) {
      Write-Host "        $(($Item.Name) -replace 'Path_',''): $($Item.Value)"
    }

  Write-Host "    - Complete"
  Write-Host ""

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Functions
#   Error Range: 1300 - 1399
#--------------------------------------------------------------------------------------------
#Region Functions

  Write-Host "  Functions"

  # Write Error Codes
    Write-Host "    - Write-vr_ErrorCode"
    function Write-vr_ErrorCode ($Code,$Exit,$Object) {
      # Code: XXXX   4-digit code to identify where in script the operation failed
      # Exit: Boolean option to define if  exits or not
      # Object: The error object created when the script encounters an error ($Error[0], $PSItem, etc.)

      begin {

      }

      process {
        Write-Host "        Error: $($Object.Exception.ErrorId)"
        Write-Host "        Command Name: $($Object.CategoryInfo.Activity)"
        Write-Host "        Message: $($Object.Exception.Message)"
        Write-Host "        Line/Position: $($Object.Exception.Line)/$($Object.Exception.Offset)"
      }

      end {
        switch ($Exit) {
          $true {
            Write-Host "        Exit: $($Code)"
            Stop-Transcript
            Exit $Code
          }
          $false {
            Write-Host "        Continue Processing..."
          }
          Default {
            Write-Host "        Unknown Exit option in Write-vr_ErrorCode parameter"
          }
        }
      }
    }

  Write-Host "    - Complete"
  Write-Host ""

#EndRegion Functions
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

	# Write-Host "  Environment"

	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Validation
#   Error Range: 1500 - 1599
#--------------------------------------------------------------------------------------------
#Region Validation

	Write-Host "  Validation"

  # Destination Path
		Write-Host "    - Destination Path"

		try {
			Write-Host "        Path: $($Param_DestinationPath)"

			if (Test-Path -Path $Param_DestinationPath) {
				Write-Host "        Status: Exists"
			}
			else {
				New-Item -Path $Param_DestinationPath -ItemType Directory -Force | Out-Null
				Write-Host "        Status: Created"
			}
		}
		catch {
			Write-vr_ErrorCode -Code 1501 -Exit $true -Object $PSItem
		}

  # Log Files
    Write-Host "    - Log Files"
  
    foreach ($Item in $Path_Windows_Logs) {
      try {
        $Temp_Object = [PSCustomObject]@{
          Path      = $Item
          Exists    = Test-Path -Path $Item
          Status    = $null
        }
        Write-Host "        $($Temp_Object.Path)"
        Write-Host "          Exists: $($Temp_Object.Exists)"

        $Dataset_Windows_Logs += $Temp_Object
      }
      catch {
        Write-vr_ErrorCode -Code 1502 -Exit $true -Object $PSItem
      }
    }
    Write-Host "        Status: Success"
    
	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Validation
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Data Gather
#   Error Range: 1600 - 1699
#--------------------------------------------------------------------------------------------
#Region Data Gather

	# Write-Host "  Data Gather"


	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Data Gather
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

	Write-Host "  Execution"

  # Copy Log Files
    Write-Host "    - Copy Log Files"

    foreach ($Item in $Dataset_Windows_Logs) {
      try {
        Write-Host "        $($Item.Path)"

        if ($Item.Exists) {
          # Create Directory Structure in Destination Path
          $Temp_DestinationPath = $Param_DestinationPath + ($Item.Path | Split-Path -NoQualifier | Split-Path -Parent)

          if ((Test-Path -Path $Temp_DestinationPath) -ne $true) {
						$Temp_PathRecurse = $null
            foreach ($Directory in ($Temp_DestinationPath -split "\\")) {
              $Temp_PathRecurse += $Directory + "\"
              if (Test-Path -Path $Temp_PathRecurse) {
                $Temp_Result = "Exists"
              }
              else {
                New-Item -Path $Temp_PathRecurse -ItemType Directory -ErrorAction Stop | Out-Null
                $Temp_Result = "Created"
              }
          
              Write-Host "          $($Temp_PathRecurse) = $($Temp_Result)"
            }
          }

          Copy-Item -Path $Item.Path -Destination $Temp_DestinationPath -Force | Out-Null
          $Item.Status = "Copied"
        }
        else {
					$Item.Status = "Skipped"
        }
        Write-Host "          Status: $($Item.Status)"
      }
      catch {
        Write-vr_ErrorCode -Code 1701 -Exit $true -Object $PSItem
      }
    }
    Write-Host "        Status: Success"

	# Determine Script Result
		$Meta_Script_Result = $true,"Success"

	Write-Host "    - Complete"
	Write-Host ""

#EndRegion Execution
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Output
#   Error Range: 1800 - 1899
#--------------------------------------------------------------------------------------------
#Region Output

	# Write-Host "  Output"

	# # [StepName]
	# 	Write-Host "    - [StepName]"

	# 	try {

	# 		Write-Host "        Status: Success"
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 18XX -Exit $true -Object $PSItem
	# 	}

	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Output
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Cleanup
#   Error Range: 1900 - 1999
#--------------------------------------------------------------------------------------------
#Region Cleanup

	# Write-Host "  Cleanup"

	# # Confirm Cleanup
	# 	Write-Host "    - Confirm Cleanup"

	# 	do {
	# 		$Temp_Cleanup_UserInput = Read-Host -Prompt "        Do you want to automatically clean up the unecessary content from this script? [Y]es or [N]o"
	# 	} until (
	# 		$Temp_Cleanup_UserInput -in "Y","Yes","N","No"
	# 	)

	# # [StepName]
	# 	Write-Host "    - [StepName]"

	# 	try {
	# 		if ($Temp_Cleanup_UserInput -in "Y", "Yes") {

	# 			Write-Host "        Status: Success"
	# 		}
	# 		else {
	# 			Write-Host "            Status: Skipped"
	# 		}
	# 	}
	# 	catch {
	# 		Write-vr_ErrorCode -Code 1901 -Exit $true -Object $PSItem
	# 	}

	# Write-Host "    - Complete"
	# Write-Host ""

#EndRegion Cleanup
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Footer
#--------------------------------------------------------------------------------------------
#Region Footer

	# Gather Data
		$Meta_Script_Complete_DateTime  = Get-Date
		$Meta_Script_Complete_TimeSpan  = New-TimeSpan -Start $Meta_Script_Start_DateTime -End $Meta_Script_Complete_DateTime

	# Output
		Write-Host "------------------------------------------------------------------------------"
		Write-Host "  Script Result: $($Meta_Script_Result[1])"
		Write-Host "  Script Started: $($Meta_Script_Start_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Script Completed: $($Meta_Script_Complete_DateTime.ToUniversalTime().ToString(`"yyyy-MM-dd HH:mm:ss`")) (UTC)"
		Write-Host "  Total Time: $($Meta_Script_Complete_TimeSpan.Days) days, $($Meta_Script_Complete_TimeSpan.Hours) hours, $($Meta_Script_Complete_TimeSpan.Minutes) minutes, $($Meta_Script_Complete_TimeSpan.Seconds) seconds, $($Meta_Script_Complete_TimeSpan.Milliseconds) milliseconds"
		Write-Host "------------------------------------------------------------------------------"
		Write-Host "  End of Script"
		Write-Host "------------------------------------------------------------------------------"

#EndRegion Footer
#--------------------------------------------------------------------------------------------

# Stop-Transcript
Return $Meta_Script_Result[0]