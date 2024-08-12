# Collect Parameters from SNOW Workflow
Param([string]$collection="TEST - AM - SNOW - Application Deployment", [string]$user="*\[UserName] *")

# Import SNOW's Microsoft Endpoint Manager module
    Import-Module "$executingScriptDirectory\MicrosoftEndpointConfigurationManagerSpoke\MicrosoftEndpointManagerMain" -DisableNameChecking

# Copy the environment variables to their parameters
    # Note: Not sure why this is here. This appears to be looking for environment variables that are defined on the mid-server.
    #       Params are already passed to the script. Is this for overriding/testing variables in the script?
    # if (test-path env:\SNC_collection) {
    # $collection  = $env:SNC_collection
    # $user = $env:SNC_user
    # }

# Add Log Info
    # Note: Not sure where these cmdlets are being imported from or how they exist in the scope of the script execution. They don't exist in the global scope on the MID Server.
    SNCLog-ParameterInfo @("Running AddToUserCollection", $collection, $user)

# Validate Data
    # Note: Validation should occur even before doing things like creating a session. If the data does not exist then there would be no need to create and destroy a session that would never have been used.
    # Note: Why doesn't the validation actually exit if the Collection or User parameter is empty?
    # Note: This should not be an ElseIf because both conditions are not mutually exclusive. It could be that both params are empty.
    if (($collection -eq $null) -or ($collection -eq "")) {
        Write-Host "Empty collection name"
        # Note: If this value is blank, it should error out at this point since we can't pass null values to any cmdlets
        # Write-Error -Message "Validation Error: Collection Name parameter is "
        # Exit 1001
    }
    if (($user -eq $null) -or ($user -eq "")) {
        Write-Host "Empty user name"
        # Note: If this value is blank, it should error out at this point since we can't pass null values to any cmdlets
        # Exit 1002
    }

# -----------------------------------------------------------------------------------
#   Why is the following not performed on the MID server and requires creating remote sessions?
#      - These operations are SNOW related, so I would think it should use SNOW server resources
#      - This connects to the top tier Primary Site Server that performs all operations in environment, it could really just be performed on any device that houses the MECM Console/Cmdlets (MID Server)
# -----------------------------------------------------------------------------------

# Create Connection
    # Note: Not sure why this utilizes a custom PS Cmdlet for "create" PSSession when "New-PSSession" is already a built-in cmdlet
    # $session = Create-PSSession -sccmServerName $computer -credential $cred

# Perform MECM Operations
    # Note: This text should be changed to better reflect the action being taken
    # Note: Not sure where these cmdlets are being imported from or how they exist in the scope of the script execution. They don't exist in the global scope on the MID Server.
    SNCLog-DebugInfo "`tInvoking Invoke-Command -ScriptBlock `$'{function:Add-ToUserCollection}' -ArgumentList $collection, $user"

    # Note: This does not need to be a function because the action performed is on a single object and not an iteration of an array of items
    # Note: This is the default code that is run by MECM Console to create connection for PowerShell / PowerShell ISE for remote cmdlet execution
        # Define or get site code
            $SiteCode = "[SiteCode]"

        # Import the ConfigurationManager.psd1 module
            if ((Get-Module ConfigurationManager) -eq $null) {
                Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams
            }

        # Connect to the site's drive if it is not already present
            if ((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
                New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
            }

        # Set the current location to be the site code.
            Set-Location "$($SiteCode):\" @initParams

        # Note: This is not necessary if there is not going to be a function used
            $collection = $args[0]
            # Note: This is a dangerous wildcard format to use because it has the potential to be greedy and grab users with similar names from different domains
            $username = "*\" + $args[1] + " *"

        # Get ResourceID of Collection
            $id = (Get-CMUser -Name $username).ResourceID

        # Add User to Collection
            Add-CMUserCollectionDirectMembershipRule -CollectionName $collection -ResourceId $id

# Cleanup
    if($session -ne $null) {
        Remove-PSSession -session $session
    }