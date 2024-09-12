# Collect Parameters from SNOW Workflow
  Param([string]$Collection, [string]$User)

# Organization Specific Parameters
  $DomainPrefix = "VividRock"
  $DomainPrefix_Alt = "Development"
  $ProviderMachineName = $Computer
  $SiteCode = "[SiteCode]"
  $PSModulePath = "\\vividrock.com\repo\Scripts\PowerShell Modules\Microsoft Endpoint Configuration Manager\2403\bin\ConfigurationManager.psd1"

# Add Log Header
  SNCLog-DebugInfo "------------------------------------------------------------------------------"
  SNCLog-DebugInfo "  MECM Toolkit - Integrations - MECM Spoke - Remove from User Collection"
  SNCLog-DebugInfo "------------------------------------------------------------------------------"
  SNCLog-DebugInfo "    Author:     Dustin Estes"
  SNCLog-DebugInfo "    Company:    VividRock"
  SNCLog-DebugInfo "    Date:       May 09, 2024"
  SNCLog-DebugInfo "    Copyright:  VividRock LLC - All Rights Reserved"
  SNCLog-DebugInfo "    Purpose:    Remove a user to the specified collection within MECM."
  SNCLog-DebugInfo "    Links:      None"
  SNCLog-DebugInfo "    Template:   1.0"
  SNCLog-DebugInfo "------------------------------------------------------------------------------"
  SNCLog-DebugInfo ""
  SNCLog-DebugInfo "  Variables"
  SNCLog-DebugInfo "    - Parameters"
  SNCLog-DebugInfo "        Collection: $($Collection)"
  SNCLog-DebugInfo "        User: $($User)"
  SNCLog-DebugInfo "        SMS Provider: $($ProviderMachineName)"
  SNCLog-DebugInfo "        Site Code: $($SiteCode)"

# Validate Data
  SNCLog-DebugInfo "  Validation"

  SNCLog-DebugInfo "    - Collection"
  if ($Collection -in $null,"") {
    SNCLog-DebugInfo "        Status: Invalid Collection Name"
    Exit 1001
  }
  else {
    SNCLog-DebugInfo "        Status: Valid Collection Name"
  }

  SNCLog-DebugInfo "    - User"
  if ($User -in $null,"") {
    SNCLog-DebugInfo "        Status: Invalid User Name"
    Exit 1002
  }
  else {
    SNCLog-DebugInfo "        Status: Valid User Name"
  }

  SNCLog-DebugInfo "    - SMS Provider"
  if ($SMSProviderName -in $null,"") {
    SNCLog-DebugInfo "        Status: Invalid SMS Provider Name"
    Exit 1003
  }
  else {
    SNCLog-DebugInfo "        Status: Valid SMS Provider Name"
  }

  if (Test-Connection -ComputerName $SMSProviderName -Count 2 -Quiet) {
    SNCLog-DebugInfo "        Status: SMS Provider is Reachable"
  }
  else {
    SNCLog-DebugInfo "        Status: SMS Provider is Unreachable"
    Exit 1004
  }

# Perform MECM Operations
  SNCLog-DebugInfo "  Operation"

  # Import the ConfigurationManager.psd1 module
    SNCLog-DebugInfo "    - Import Configuration Manager Module"
    try {
      if ((Get-Module ConfigurationManager -ErrorAction SilentlyContinue) -in $null,"") {
        Import-Module -Name $PSModulePath -ErrorAction Stop
        SNCLog-DebugInfo "        Status: Success"
      }
      else {
        SNCLog-DebugInfo "        Status: Already Exists"
      }
    }
    catch {
      SNCLog-DebugInfo "        Error: $($PSItem.Exception.Message)"
      SNCLog-DebugInfo "        StackTrace: $($_.ScriptStackTrace)"
      Exit 2001
    }

  # Connect to the site's drive if it is not already present
    SNCLog-DebugInfo "    - Create PS Drive"
    try {
      if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -in $null,"") {
        New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $SMSProviderName -ErrorAction Stop
        SNCLog-DebugInfo "        Status: Success"
      }
      else {
        SNCLog-DebugInfo "        Status: Already Exists"
      }
    }
    catch {
      SNCLog-DebugInfo "        Error: $($PSItem.Exception.Message)"
      SNCLog-DebugInfo "        StackTrace: $($_.ScriptStackTrace)"
      Exit 2002
    }

  # Set the current location to be the site code.
    SNCLog-DebugInfo "    - Set Location"
    try {
      Set-Location "$($SiteCode):\"
      SNCLog-DebugInfo "        Status: Success"
    }
    catch {
      SNCLog-DebugInfo "        Error: $($PSItem.Exception.Message)"
      SNCLog-DebugInfo "        StackTrace: $($_.ScriptStackTrace)"
      Exit 2003
    }

# Format Username
#   Note: This should not use wildcards. Need to have the user's domain passed from SNOW since orgs can have more than one Domain managed in MECM.
  SNCLog-DebugInfo "    - Format Username"
  try {
    $Username = "$($DomainPrefix)\" + $User + " *"
    SNCLog-DebugInfo "        Status: Success"
    SNCLog-DebugInfo "        Username: $($Username)"
  }
  catch {
    SNCLog-DebugInfo "        Error: $($PSItem.Exception.Message)"
    SNCLog-DebugInfo "        StackTrace: $($_.ScriptStackTrace)"
    Exit 2004
  }

# Get ResourceID of User
    SNCLog-DebugInfo "    - Get Resource ID of User"
    try {
        $CM_User        = Get-CMUser -Name $Username -ErrorAction Stop
        [array]$CM_ResourceIDs = $CM_User.ResourceID
        SNCLog-DebugInfo "        Status: Success"
        SNCLog-DebugInfo "        Name: $($CM_User.Name)"
        SNCLog-DebugInfo "        Domain: $($CM_User.Domain)"
        SNCLog-DebugInfo "        Resource ID: $($CM_User.ResourceID)"
        SNCLog-DebugInfo "        Resource IDs: $($CM_ResourceIDs)"
    }
    catch {
        SNCLog-DebugInfo "        Error: $($PSItem.Exception.Message)"
        SNCLog-DebugInfo "        StackTrace: $($_.ScriptStackTrace)"
        Exit 2005
    }

# ---------------------------------------------------------------------------------------------------------------------------------
# We need to account for Users on an alternate domain who login to SNOW with their primary domain account.

# Get Alternate ResourceIDs of User
  SNCLog-DebugInfo "    - Get Alternate Resource IDs of User"
  try {
    $CM_User_Name   =             ($CM_User.Name -split {$_ -eq "(" -or $_ -eq ")"})[1]
    $CM_User_Alt    = Get-CMUser -Name "$($DomainPrefix_Alt)\*$($CM_User_Name)*"

    if ($CM_User_Alt -in $null,"") {
      SNCLog-DebugInfo "        Status: No Alternate Domain Account Found"
    }
    else {
      [array]$CM_ResourceIDs += $CM_User_Alt.ResourceID
      SNCLog-DebugInfo "        Status: Success"
      SNCLog-DebugInfo "        Name: $($CM_User_Alt.Name)"
      SNCLog-DebugInfo "        Domain: $($CM_User_Alt.Domain)"
      SNCLog-DebugInfo "        Resource ID: $($CM_User_Alt.ResourceID)"
      SNCLog-DebugInfo "        Resource IDs: $($CM_ResourceIDs)"
    }
  }
  catch {
    SNCLog-DebugInfo "        Error: $($PSItem.Exception.Message)"
    SNCLog-DebugInfo "        StackTrace: $($_.ScriptStackTrace)"
    Exit 2005
  }

# ---------------------------------------------------------------------------------------------------------------------------------
# Modify User Collection
  SNCLog-DebugInfo "    - Modify User Collection"
  try {
    Remove-CMUserCollectionDirectMembershipRule -CollectionName $Collection -ResourceId $CM_ResourceIDs -ErrorAction Stop
    SNCLog-DebugInfo "        Status: Success"
  }
  catch {
    SNCLog-DebugInfo "        Error: $($PSItem.Exception.Message)"
    SNCLog-DebugInfo "        StackTrace: $($_.ScriptStackTrace)"
    Exit 2006
  }

# End Script
  SNCLog-DebugInfo ""
  SNCLog-DebugInfo "------------------------------------------------------------------------------"
  SNCLog-DebugInfo "  Script Result: Success"
  SNCLog-DebugInfo "------------------------------------------------------------------------------"
  SNCLog-DebugInfo "  End of Script"
  SNCLog-DebugInfo "------------------------------------------------------------------------------"

  Exit 0
