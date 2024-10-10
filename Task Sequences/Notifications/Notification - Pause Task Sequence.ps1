#--------------------------------------------------------------------------------------------
# Variables
#   Error Range: 1200 - 1299
#--------------------------------------------------------------------------------------------
#Region Variables
  Write-Host "  - Set Variables"

  $Title    = "VividRock - MECM Toolkit - Notification"
  $Message  = @"
Task Sequence environment paused for development and troubleshooting.

Click OK to continue the Task Sequence, Cancel to terminate it.

"@
  $Timeout  = 0
  $Settings = 1 + 64 + 4096

  Write-Host "      Status: Success"

#EndRegion Variables
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Environment
#   Error Range: 1400 - 1499
#--------------------------------------------------------------------------------------------
#Region Environment

# Close Progress Dialog UI
  Write-Host "  - Close TS ProgressUI"
  try {
    (New-Object -ComObject Microsoft.SMS.TsProgressUI).CloseProgressDialog()
    Write-Host "      Status: Success"
  }
  catch {
    Write-Host "      Status: Error - Unable to close the TS ProgressUI"
  }

#EndRegion Environment
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Execution
#   Error Range: 1700 - 1799
#--------------------------------------------------------------------------------------------
#Region Execution

# Display Notification
  Write-Host "  - Display Notification"
  try {
    $Return = (New-Object -ComObject Wscript.Shell).Popup($Message,$Timeout,$Title,$Settings)
    Write-Host "      Status: Success"
  }
  catch {
    Write-Host "      Status: Unable to display notification"
    Exit 1701
  }

# Process Return Input
  Write-Host "  - Process Return Input"
  try {
    switch ($Return) {
      1 { Write-Host "      Input: 1 - OK Button Pressed"; Write-Host "      Exit Code: 0"; Exit 0 }
      2 { Write-Host "      Input: 2 - Cancel Button Pressed"; Write-Host "      Exit Code: 1"; Exit 1 }
      Default { Write-Host "      Input: Unknown - Button Not Mapped to switch logic"; Write-Host "      Exit Code: 100"; Exit 100 }
    }
    Write-Host "      Status: Success"
  }
  catch {
    Write-Host "      Status: Unable to process return input"
    Exit 1702
  }

#EndRegion Execution
#--------------------------------------------------------------------------------------------
