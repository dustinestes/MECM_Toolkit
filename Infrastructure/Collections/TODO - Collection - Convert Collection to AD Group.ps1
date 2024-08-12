# ------------------------------------------------------------------------------------------------------------------------------
#   Mirror MECM Collections to Active Directory Groups
# ------------------------------------------------------------------------------------------------------------------------------
# To Do
#    - Add a progress bar for the processing of the chunks so large datasets provide user with confirmation its working

# Create Hash Tables
    Write-Host "Creating Hash Tables"

    Write-Host "    - Hash Table: AD_Groups"
    $AD_Groups = @{
        Test = @{
            Name = "Endpoint Engineering - MECM - Test"
            DisplayName = "Endpoint Engineering - MECM - Test"
            SamAccountName = "EE-MECM-Test"
            Description = "Used to apply Group Policy settings to the specified members to mimic our IT/UAT/PROD servicing rings within MECM."
            Path = "OU=Groups,DC=VividRock,DC=com"
            GroupCategory = "Security"
            GroupScope = "Universal"
            ManagedBy = "IT Endpoint Engineering"
        }
        IT = @{
            Name = "Endpoint Engineering - MECM - IT"
            DisplayName = "Endpoint Engineering - MECM - IT"
            SamAccountName = "EE-MECM-IT"
            Description = "Used to apply Group Policy settings to the specified members to mimic our IT/UAT/PROD servicing rings within MECM."
            Path = "OU=Groups,DC=VividRock,DC=com"
            GroupCategory = "Security"
            GroupScope = "Universal"
            ManagedBy = "IT Endpoint Engineering"
        }
        UAT = @{
            Name = "Endpoint Engineering - MECM - UAT"
            DisplayName = "Endpoint Engineering - MECM - UAT"
            SamAccountName = "EE-MECM-UAT"
            Description = "Used to apply Group Policy settings to the specified members to mimic our IT/UAT/PROD servicing rings within MECM."
            Path = "OU=Groups,DC=VividRock,DC=com"
            GroupCategory = "Security"
            GroupScope = "Universal"
            ManagedBy = "IT Endpoint Engineering"
        }
        PROD = @{
            Name = "Endpoint Engineering - MECM - PROD"
            DisplayName = "Endpoint Engineering - MECM - PROD"
            SamAccountName = "EE-MECM-PROD"
            Description = "Used to apply Group Policy settings to the specified members to mimic our IT/UAT/PROD servicing rings within MECM."
            Path = "OU=Groups,DC=VividRock,DC=com"
            GroupCategory = "Security"
            GroupScope = "Universal"
            ManagedBy = "IT Endpoint Engineering"
         }
    }
    Write-Host  "          Success: Hashtable created successfully"


    Write-Host "    - Hash Table: MECM_Collections"
    $MECM_Collections = @{
        Test = "DEV - DESTES - Test AD Script"
        IT   = "LIE - Primary - Workstations - All - IT"
        UAT  = "LIE - Primary - Workstations - All - UAT"
        PROD = "LIE - Primary - Workstations - All - Prod"
    }
    Write-Host  "          Success: Hashtable created successfully"

# Create Groups
    Write-Host "Creating Active Directory Groups"

    foreach ($Group in $AD_Groups.GetEnumerator()) {
        Write-Host "    - Checking if group exists: $($Group.Value.Name)"

        try {
            if (Get-ADGroup -Filter "Name -eq `"$($Group.Value.Name)`"" -ErrorAction Stop) {
                Write-Host "          Skipped: Group already exists"
            }
            else {
                Write-Host "          Creating: Group does not exist"

                try {
                    $Parameters = $Group.Value
                    New-ADGroup @Parameters -WhatIf -ErrorAction Stop
                    Write-Host  "          Success: The AD group was created"
                }
                catch {
                    Write-Error "          Error: Failed to create the AD group"
                    throw $_
                }
            }
        }
        catch {
            Write-Error "          Error: Failed while querying AD for the specified group"
            throw $_
        }
    }

# Establish the MECM Environment
    Write-Host "Establishing MECM Environment"

    try {
        # Site configuration
            $MECM_SiteCode = "[SiteCode]"
            $MECM_SMSProvider = "[ServerFQDN]"

        # Import the ConfigurationManager.psd1 module
            Write-Host "    - Importing the MECM PowerShell Modules"

            if ((Get-Module ConfigurationManager) -eq $null) {
                Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
            }

        # Connect to the site's drive if it is not already present
            Write-Host "    - Connecting to MECM SMS Provider"

            if ((Get-PSDrive -Name $MECM_SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
                New-PSDrive -Name $MECM_SiteCode -PSProvider CMSite -Root $MECM_SMSProvider
            }

        # Set the current location to be the site code.
            Write-Host "    - Setting the PSDrive for PowerShell Access"

            $Restore_PreviousLocation = Get-Location
            Set-Location "$($MECM_SiteCode):\"
    }
    catch {
        Write-Error "          Error: Failed to connect to the MECM SMS Provider"
        throw $_
    }

# Add Members
    foreach ($Group in $AD_Groups.GetEnumerator()) {
        Write-Host "Adding Members: $($Group.Value.Name)"

        # Remove Existing Members from Active Directory Group
            Write-Host "    - Remove Existing Active Directory Group Members"

            try {
                Write-Host "          Group Name: $($Group.Value.Name)"

                # Get AD Information
                    $AD_GroupDN = (Get-ADGroup -Filter "Name -eq `"$($Group.Value.Name)`"" -ErrorAction Stop).DistinguishedName
                    $AD_GroupMembership = Get-ADComputer -Filter "memberof -eq `"$($AD_GroupDN)`""

                    Write-Host "          Member Count: $($AD_GroupMembership.Count)"
                # Process Data
                    if ($null -eq $AD_GroupMembership) {
                        Write-Host "          Skipped: No members found in the Active Directory group"
                    }
                    else {
                        # Divide Array into Chunks
                            $Count_Incrementer = [pscustomobject] @{ Value = 0 }
                            $Group_Size = 100

                            $Group_Objects = $AD_GroupMembership | Group-Object -Property { [math]::Floor($Count_Incrementer.Value++ / $Group_Size) }

                            Write-Host "          Chunk Count: $($Group_Objects.Count)"
                            Write-Host "          Chunk Size: $($Group_Size)"

                            foreach ($Group_Object in $Group_Objects) {
                                Remove-ADGroupMember -Identity $AD_GroupDN -Members $Group_Object.Group.DistinguishedName -Confirm:$false -ErrorAction Stop

                                if ($Count_Incrementer -eq 5) {
                                    Pause
                                }
                            }

                    Write-Host "          Success: Members removed from the Active Directory group"
                }
            }
            catch {
                Write-Error "          Error: Failed to remove members from Active Directory group"
                throw $_
            }

        # Pull Members from Collections
            Write-Host "    - Getting MECM Collection Membership"

            try {
                Write-Host "          Collection Name: $($MECM_Collections.$($Group.Name))"
                $MECM_Members = (Get-CMCollectionMember -CollectionName $MECM_Collections.$($Group.Name) -ErrorAction Stop)
                Write-Host "          Success: Members collected from MECM Collection"
            }
            catch {
                Write-Error "          Error: Failed to get members from MECM Collection"
                throw $_
            }

        # Get Computer Objects from Active Directory
        # These items are grabbed from AD and not MECM so that we can be sure we get only valid items that still exist in AD
            Write-Host "    - Getting Computer Objects from Active Directory that Match MECM Collection Membership"
                try {
                    $AD_ComputerObjects = @()

                    foreach ($Computer in $MECM_Members) {
                        $AD_ComputerObject = (Get-ADComputer -Filter "Name -eq `"$($Computer.Name)`" " -ErrorAction Stop)

                        if ($null -eq $AD_ComputerObject.DistinguishedName) {
                            # Do not add to object. This will cause the Add-ADGroupMember to fail
                        }
                        else {
                            $AD_ComputerObjects += [PSCustomObject]@{
                                Name = $Computer.Name
                                DistinguishedName = $AD_ComputerObject.DistinguishedName
                            }
                        }
                    }

                    Write-Host "          Success: Computer objects collected from Active Directory"
                }
                catch {
                    Write-Error "          Error: Failed to get computer objects from Active Directory"
                    throw $_
                }

        # Add Members to Active Directory Group
            Write-Host "    - Adding Members to Active Directory Group"

            try {
                Write-Host "          Group Name: $($Group.Value.Name)"
                Write-Host "          Member Count: $($AD_ComputerObjects.Count)"

                # Get Domain Controller with ADWS Enabled
                    $AD_DomainController = (Get-ADDomainController -Discover -Service ADWS).Name

                # Divide Array into Groups
                    $Count_Incrementer = [pscustomobject] @{ Value = 0 }
                    $Group_Size = 100

                    $Group_Objects = $AD_ComputerObjects | Group-Object -Property { [math]::Floor($Count_Incrementer.Value++ / $Group_Size) }

                    Write-Host "          Chunk Count: $($Group_Objects.Count)"
                    Write-Host "          Chunk Size: $($Group_Size)"

                    foreach ($Group_Object in $Group_Objects) {
                        Add-ADGroupMember -Identity $AD_GroupDN -Members $Group_Object.Group.DistinguishedName -Server $AD_DomainController -ErrorAction Stop

                        if ($Count_Incrementer -eq 5) {
                            Pause
                        }
                    }

                Write-Host "          Success: Members added to Active Directory group"
            }
            catch {
                Write-Error "          Error: Failed to add members to Active Directory group"
                throw $_
            }
    }

# Return to Previous Location
    Set-Location -Path $Restore_PreviousLocation.Path

