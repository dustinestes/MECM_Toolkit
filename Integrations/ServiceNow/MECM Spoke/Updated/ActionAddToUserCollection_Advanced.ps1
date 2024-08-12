# Collect Parameters from SNOW Workflow
Param([string]$Collection, [string]$User)

    # Organization Specific Parameters
        $DomainPrefix = "VividRock"
        $ProviderMachineName = "[ServerFQDN]"
        $SiteCode = "[SiteCode]"
        $PSModulePath = "\\vividrock.com\repo\Scripts\PowerShell Modules\Microsoft Endpoint Configuration Manager\Test\bin\ConfigurationManager.psd1"

# Add Log Header
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  MECM Spoke - Add User to Collection"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:     Dustin Estes"
    Write-Host "    Company:    VividRock"
    Write-Host "    Date:       May 09, 2024"
    Write-Host "    Copyright:  VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:    Add a user to the specified collectin within MECM."
    Write-Host "    Links:      None"
    Write-Host "    Template:   1.0"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
    Write-Host "  Variables"
    Write-Host "    - Parameters"
    Write-Host "        Collection: $($Collection)"
    Write-Host "        User: $($User)"
    Write-Host "        sccmServerName (Computer): $($Computer)"
    Write-Host "        Site Code: $($SiteCode)"
    Write-Host "        SMS Provider: $($ProviderMachineName)"

# Validate Data
    Write-Host "  Validation"

    Write-Host "    - Collection"
    if ($Collection -in $null,"") {
        Write-Host "        State: Invalid collection name"
        Write-Error -Message "Validation Error: Collection Name parameter is null or empty"
        Exit 1001
    }
    else {
        Write-Host "        State: Valid"
    }

    Write-Host "    - User"
    if ($User -in $null,"") {
        Write-Host "        State: Invalid user name"
        Write-Error -Message "Validation Error: Collection Name parameter is null or empty"
        Exit 1002
    }
    else {
        Write-Host "        State: Valid"
    }

# Perform MECM Operations
    Write-Host "  Operation"

    # Import the ConfigurationManager.psd1 module
        try {
            if ((Get-Module ConfigurationManager -ErrorAction Stop) -in $null,"") {
                Import-Module -Name $PSModulePath -ErrorAction Stop
            }
        }
        catch {
            throw "$($PSItem.Exception.Message)"
            Exit 2001
        }

    # Connect to the site's drive if it is not already present
        try {
            if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction Stop) -in $null,"") {
                New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName -ErrorAction Stop
            }
        }
        catch {
            throw "$($PSItem.Exception.Message)"
            Exit 2002
        }

    # Set the current location to be the site code.
        try {
            Set-Location "$($SiteCode):\"
        }
        catch {
            throw "$($PSItem.Exception.Message)"
            Exit 2003
        }

    # Format Username
    #   Note: This should not use wildcards. Need to have the user's domain passed from SNOW since orgs can have more than one Domain managed in MECM.
        try {
            $Username = "$($DomainPrefix)\" + $User + " *"
        }
        catch {
            throw "$($PSItem.Exception.Message)"
            Exit 2004
        }

    # We need to account for Users on multiple domains.

    # Get ResourceID of Collection
        try {
            $id = (Get-CMUser -Name $Username).ResourceID
        }
        catch {
            throw "$($PSItem.Exception.Message)"
            Exit 2005
        }

    # Add User to Collection
        try {
            Add-CMUserCollectionDirectMembershipRule -CollectionName $Collection -ResourceId $id -ErrorAction Stop
        }
        catch {
            throw "$($PSItem.Exception.Message)"
            Exit 2006
        }

