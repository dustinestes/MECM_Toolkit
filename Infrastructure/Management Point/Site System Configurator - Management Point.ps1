<# ------------------------------------------------------------------------------------------------------------------------------------------
    MECM Toolkit - Site System Configurator - Management Point
---------------------------------------------------------------------------------------------------------------------------------------------

    Author:     Dustin Estes
    Copyright:  VividRock LLC | All rights reserved
                THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    Created:    2016-02-18
    Version:    1.0

    Description:
        Script for configuring Management Points within an MECM site.

    Note:
        This has not been tested from a remote device or console; only from the Local Server.

    Prerequisites:
        None

    How to Use:
        Perform the following functions:
            1. Log on to the Site System Server
            2. Open PowerShell ISE in an Administrative context
            3. Paste the contents of this script into the script pane
            4. Execute this script in its entirety
            5. Follow the prompts in the console window providing feedback where necessary
            6. Perform the manual steps provided (if prompted)
            7. Confirm everything is completed so the script can cleanup

    Operation:
        The script functions as follows:
            -

    Exit Codes:
        Provide a table of the exit codes that are in the script so the reader can quickly identify the code to its
        reason for termination.
            0       The script processed successfully
         1001       User quit the script
         1011       Incorrect Operating System

    Future Features:
        1.

    Snippets
        # Step Name
            Write-Host "  - <step name>: " -NoNewline
            if (<analysis logic>) {
                Write-Host " Failure" -ForegroundColor Red
                Return
            }
            else {
                Write-Host " Success" -ForegroundColor Green
            }

        # Step Name
            Write-Host "  - <step name>: " -NoNewline
            try {
                <cmdlet action> -ErrorAction Stop | Out-Null
                Write-Host " Success" -ForegroundColor Green
            }
            catch {
                Write-Host " Failure  >  $($Error[0].Exception.Message)" -ForegroundColor Red
                $PSCmdlet.ThrowTerminatingError($PSItem)
            }

------------------------------------------------------------------------------------------------------------------------------------------ #>
Clear-Host


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Initialize
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for initializing the script
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    # Script Information
        $Script_Publisher           = "VividRock"
        $Script_Product             = "MECM Toolkit"
        $Script_Product_Module      = "Site System Configurator"
        $Script_Name                = "Management Point"
        $Script_Version             = "1.0"
        $Script_Exec_Timestamp      = $($(Get-Date).ToUniversalTime().ToString("yyyy-MM-dd_HHmmssZ"))

    # User Information
        $User_SecurityObject         = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    # Paths
        $Path_OutputFolder       = "$env:USERPROFILE\Downloads\$Script_Publisher\$Script_Product\$Script_Product_Module\$Script_Name\$Script_Exec_Timestamp\"

    # Logging
        $Path_TranscriptLogFile = $Path_OutputFolder + "\VividRock_ExecutionTranscript.log"
        Start-Transcript -Path $Path_TranscriptLogFile -Force

#EndRegion Initialize
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Set Variables
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for providing input prior to execution
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host "  Set Variables"

    # Configure Security
        $SecurityGroup_Name             = "Administrators"
        $SecurityGroup_DesiredMembers   = "DOMAIN\GRP.CM.SiteAdmins","DOMAIN\GRP.CM.SiteServers"

    # Validate Software
        $NETFramework_RequiredRelease   = "528040"
        $OperatingSystem_RequiredBuild  = "17763"

    # Enroll in Certificates
        $Certificates_TemplateNames = @(
            "WebServer"
        )
        $Certificates_TargetStore    = "cert:\LocalMachine\My"
        $Server_Name                = $env:COMPUTERNAME
        $Server_FQDN                = $env:COMPUTERNAME + "." + $ENV:USERDNSDOMAIN
        $Certificates_IISTemplate    = "WebServer"

    # Configure IIS
        $IIS_Website    = "Default Web Site"

    Write-Host "    - Complete"
    Write-Host ""

#EndRegion Set Variables
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Configure Security
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for performing security configurations
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host "Configure Security"

    # Get Group Members
        $Group_ActualMembers = Get-LocalGroupMember -Name $SecurityGroup_Name

    # Evaluate Memberships
        Write-Host "    - Add Identities to Local Administrator Group"

        foreach ($DesiredMember in $SecurityGroup_DesiredMembers) {
            Write-Host "        $($DesiredMember): " -NoNewLine

            if ($Group_ActualMembers.Name -contains $DesiredMember) {
                Write-Host "Already Exists" -ForegroundColor DarkGray
            }
            else {
                try {
                    Add-LocalGroupMember -Group $SecurityGroup_Name -Member $DesiredMember -ErrorAction Stop
                    Write-Host "Success" -ForegroundColor Green
                }
                catch {
                    Write-Host "Failed" -ForegroundColor Red
                    Pause
                }
            }
        }

#EndRegion Configure Security
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Validate Software
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for validating various software
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Validate Software"
    Write-Host ""

    # Operating System
        Write-Host "    - Operating System"

        # Define Variables
        #    $OperatingSystem_RequiredBuild       = "17763"

        # Get Data
            $OperatingSystem_Object         = Get-CimInstance -ClassName Win32_OperatingSystem

            switch ($OperatingSystem_Object.BuildNumber) {
                { $_ -ge 20348 } { $OperatingSystem_ActualVersion = 'Windows Server 2022'; break }
                { $_ -ge 17763 } { $OperatingSystem_ActualVersion = 'Windows Server 2019'; break }
                { $_ -ge 14393 } { $OperatingSystem_ActualVersion = 'Windows Server 2016'; break }
                default { $OperatingSystem_ActualVersion = $null; break }
            }

        # Validate
            Write-Host "          Expected Build:"$OperatingSystem_RequiredBuild
            Write-Host "          -----------------------------------------------------"
            Write-Host "          Detected Version:"$OperatingSystem_ActualVersion
            Write-Host "          Detected Build:"$OperatingSystem_Object.BuildNumber
            Write-Host "          -----------------------------------------------------"
            Write-Host "          Status: " -NoNewline

            if ($OperatingSystem_Object.BuildNumber -lt $OperatingSystem_RequiredBuild) {
                Write-Host "Non-compliant" -ForegroundColor Red
                $Remediate = $true
            }
            else {
                Write-Host "Compliant" -ForegroundColor Green
                $Remediate = $false
            }

        # Remediate
            if ($Remediate -eq $true) {
                Write-Host "          -----------------------------------------------------"
                Write-Host "          Reinstall the desired Operating System"
                    Return 1011
            }
            else {
                # Do nothing
            }

    # .NET Framework
        Write-Host "    - .NET Framework"

        # # Define Variables
        #     $NETFramework_RequiredRelease       = "528040"

        # Functions
            function Get-vrNETFramework {
                $vrSub_InstalledProduct      = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
                $vrSub_ActualRelease         = $vrSub_InstalledProduct.Release

                Return $vrSub_ActualRelease
            }

        # Get Data
            $NETFramework_ActualRelease = Get-vrNETFramework

            switch ($NETFramework_ActualRelease) {
                { $_ -ge 533320 } { $NETFramework_ActualVersion = '.NET Framework 4.8.1'; break }
                { $_ -ge 528040 } { $NETFramework_ActualVersion = '.NET Framework 4.8'; break }
                { $_ -ge 461808 } { $NETFramework_ActualVersion = '.NET Framework 4.7.2'; break }
                { $_ -ge 461308 } { $NETFramework_ActualVersion = '.NET Framework 4.7.1'; break }
                { $_ -ge 460798 } { $NETFramework_ActualVersion = '.NET Framework 4.7'; break }
                { $_ -ge 394802 } { $NETFramework_ActualVersion = '.NET Framework 4.6.2'; break }
                { $_ -ge 394254 } { $NETFramework_ActualVersion = '.NET Framework 4.6.1'; break }
                { $_ -ge 393295 } { $NETFramework_ActualVersion = '.NET Framework 4.6'; break }
                { $_ -ge 379893 } { $NETFramework_ActualVersion = '.NET Framework 4.5.2'; break }
                { $_ -ge 378675 } { $NETFramework_ActualVersion = '.NET Framework 4.5.1'; break }
                { $_ -ge 378389 } { $NETFramework_ActualVersion = '.NET Framework 4.5'; break }
                default { $NETFramework_ActualVersion = $null; break }
            }

        # Validate
            Write-Host "          Expected Release:"$NETFramework_RequiredRelease
            Write-Host "          -----------------------------------------------------"
            Write-Host "          Detected Version:"$NETFramework_ActualVersion
            Write-Host "          Detected Release:"$NETFramework_ActualRelease
            Write-Host "          -----------------------------------------------------"
            Write-Host "          Status: " -NoNewline

            if ($NETFramework_ActualRelease -lt $NETFramework_RequiredRelease) {
                Write-Host "Non-compliant" -ForegroundColor Red
                $Remediate = $true
            }
            else {
                Write-Host "Compliant" -ForegroundColor Green
                $Remediate = $false
            }

        # Remediate
            if ($Remediate -eq $true) {
                Write-Host "          -----------------------------------------------------"

                do {
                    Write-Host "          Manually Install .NET Framework and check again"
                    $Input_Rescan = Read-Host -Prompt "          Ready to rescan the device? [Y]es, [Q]uit" -ErrorAction Stop

                    if ($Input_Rescan -in "Q","Quit") {
                        Return 1001
                    }

                } until (
                    ($NETFramework_ActualRelease -ge $NETFramework_RequiredRelease) -and ($Input_Rescan -in "Y","Yes","N","No","Q","Quit")
                )
            }
            else {
                # Do nothing
            }

#EndRegion Validate Software
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Enroll in Certificates
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for enrolling in PKI certificates
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Enroll in Certificates"
    Write-Host ""

    # Enroll in Certificates
	    foreach ($Template in $Certificates_TemplateNames) {
		    try {
			    Write-Host "    - Certificate: "$Template

			    if ($Template -eq $Certificates_IISTemplate) {
				    $Enroll_Result = Get-Certificate -SubjectName $("CN=" + $Server_FQDN) -DnsName $Server_Name, $Server_FQDN -CertStoreLocation $Certificates_TargetStore -Template "$($Template)" -Url ldap: -ErrorAction Stop
			    }
			    else {
				    $Enroll_Result = Get-Certificate -CertStoreLocation $Certificates_TargetStore -Template "$($Template)" -Url ldap: -ErrorAction Stop
			    }

			    Write-Host "        Status:   "$Enroll_Result.Status
			    Write-Host "        Subject:  "$Enroll_Result.Certificate.Subject
                Write-Host "        Key Usage:"$Enroll_Result.Certificate.EnhancedKeyUsageList
			    Write-Host "        Issued:   "$Enroll_Result.Certificate.NotBefore
			    Write-Host "        Expires:  "$Enroll_Result.Certificate.NotAfter
			    Write-Host ""
		    }
		    catch {
			    Write-Host "    An error occurred"
			    $PSItem.Exception.Message
                Pause
		    }
	    }

    # Start UI for Validation
        Start-Process -FilePath certlm.msc

#EndRegion Enroll in Certificates
<# --------------------------------------------------------------------------------------------------------------------------------------- #>



<# ------------------------------------------------------------------------------------------------------------------------------------------
    Validate Roles & Features
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for validating windows roles and features
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Validate Roles & Features"
    Write-Host ""

    # Define Variables
        $Array_RolesFeatures = [ordered] @{
            # Role Service = Name

            # Add .NET Framework
                ".Net Framework 4.6" = "NET-Framework-45-Core"

            # Install Background Intelligent Transfer Service (BITS)
                "Background Intelligent Tranfser Service" = "BITS"
                "BITS IIS Server Extensions" = "BITS-IIS-Ext"
                "BITS RSAT Tools" = "RSAT-Bits-Server"

            # Add IIS Features
                "Web Server (IIS) Windows Authentication" = "Web-Windows-Auth"
                "Web Server (IIS) IIS 6 WMI Compatibility" = "Web-WMI"
                "Web Server (IIS) IIS 6 Metabase Compatibility" = "Web-Metabase"
                "Web Server (IIS) IIS Management Scripts and Tools" = "Web-Scripting-Tools"
                "Web Server (IIS) ISAPI Extensions" = "Web-ISAPI-Ext"
        }

    # Iterate Through Array
        foreach ($Item in $Array_RolesFeatures.GetEnumerator()) {
            Write-Host "    -"$Item.Key
            Write-Host "          Name: "$Item.Value
            Write-Host "          Status: " -NoNewLine

            try {
                if ($(Get-WindowsFeature -Name $Item.Value).Installed -eq $true) {
                    Write-Host "Already Installed" -ForegroundColor DarkGray
                }
                else {
                    $Install_Result = Install-WindowsFeature -Name $Item.Value -ErrorAction Stop
                    if ($Install_Result.Success -eq $true) {
                        Write-Host "Success" -ForegroundColor Green
                    }
                    else {
                        Write-Host "Failure" -ForegroundColor Red
                        Write-Host "------------------------------------"
                        $Error[0].ErrorDetails.Message
                        Write-Host "------------------------------------"
                        Pause
                    }

                    Write-Host "          Feature Result: "$Install_Result.FeatureResult
                    Write-Host "          Restart Needed: " -NoNewline
                    if ($Install_Result.RestartNeeded -eq "No") {
                        Write-Host "No"
                    }
                    else {
                        Write-Host ""$Install_Result.RestartNeeded -ForegroundColor Red
                        Pause
                    }
                }

                Start-Sleep -Seconds 5
            }
            catch {
                Write-Host "Failure" -ForegroundColor Red
                Pause
            }

            Write-Host ""
        }

#EndRegion Validate Roles & Features
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Configure IIS
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for configuring the IIS server role
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Configure IIS"
    Write-Host ""

    # Define Variables
        $IIS_Website    = "Default Web Site"

    # Get Certificate Information
        Write-Host "    - Get Certificate Thumbprint"
        Write-Host "          Template Name:"$Certificates_IISTemplate
        Write-Host "          Thumbprint: " -NoNewline

        try {
            $Certificates_Thumbprint = (Get-ChildItem $Certificate_TargetStore -ErrorAction Stop | Where-Object -FilterScript {($_.Extensions.Format(1)[0].split('(')[0] -replace "template=") -match $Certificates_IISTemplate}).Thumbprint
            Write-Host ""$Certificates_Thumbprint
            Write-Host "          Status: " -NoNewline
            Write-Host "Success" -ForegroundColor Green
        }
        catch {
            Write-Host "Error" -ForegroundColor Red
            Pause
        }

	    Write-Host ""

    # Create IIS Binding Using Certificate
        Write-Host "    - Create IIS Binding Using Certificate"
        Write-Host "          Site Name:   "$IIS_Website
        Write-Host "          Port Binding: *:443"
        Write-Host "          Protocol:     HTTPS"
        Write-Host "          Status:       " -NoNewline

        try {
            New-IISSiteBinding -Name $IIS_Website -BindingInformation "*:443:" -CertificateThumbPrint $Certificates_Thumbprint -CertStoreLocation $Certificate_TargetStore -Protocol https -ErrorAction Stop
            Write-Host "Success" -ForegroundColor Green
        }
        catch {
            Write-Host "Error" -ForegroundColor Red
            Pause
        }











#--------------------------------------------------------
# Define Variables
    $IIS_Website    = "Default Web Site"
#--------------------------------------------------------

    # Validate Request Filtering
        Write-Host "    - Validate Request Filtering"

        # Define Variables
            $IIS_RequestFiltering_Verbs_Expected = @{
                #VerbName       = ExpectedState  (Allow, Deny, NotExist)
                # "GET"           = "Allow"
                # "POST"          = "Allow"
                # "CCM_POST"      = "Allow"
                # "HEAD"          = "Allow"
                # "PROPFIND"      = "Allow"
                "TESTALLOW"     = "Allow"
                "TESTDENY"      = "Deny"
                "TESTREMOVE"    = "NotExist"
                "TESTCREATE1"   = "Allow"
                "TESTCREATE2"   = "Deny"
                "TESTMODIFY"    = "Allow"
                "TESTNOTEXIST"  = "NotExist"
            }

        # Get Data
            $IIS_Feature_RequestFiltering = Get-WindowsFeature -ErrorAction Stop | Where-Object -Property "Name" -eq "Web-Filtering"

        # Construct Custom Objects
            $IIS_RequestFiltering_Verbs_CustomObject = @()

            foreach ($Item in $IIS_RequestFiltering_Verbs_Expected.GetEnumerator()) {
                $Temp_Object = [PSCustomObject]@{
                    "Verb"              = $Item.Name
                    "ExpectedState"     = $Item.Value
                    "Exists"            = $null
                    "ActualState"       = $null
                    "Remediate"         = $null
                    "Status"            = $null
                }

                $IIS_RequestFiltering_Verbs_CustomObject += $Temp_Object
            }

        # Validate
            Write-Host "          Allow Verbs:"$(if (($IIS_RequestFiltering_Verbs_CustomObject | Where-Object -Property "ExpectedState" -eq "Allow" | Measure-Object).Count -le 0) {Write-Output "None"} else {Write-Output (($IIS_RequestFiltering_Verbs_CustomObject | Where-Object -Property "ExpectedState" -eq "Allow").Verb -join ", ")})
            Write-Host "          Deny Verbs:"$(if (($IIS_RequestFiltering_Verbs_CustomObject | Where-Object -Property "ExpectedState" -eq "Deny" | Measure-Object).Count -le 0) {Write-Output "None"} else {Write-Output (($IIS_RequestFiltering_Verbs_CustomObject | Where-Object -Property "ExpectedState" -eq "Deny").Verb -join ", ")})
            Write-Host "          Remove Verbs:"$(if (($IIS_RequestFiltering_Verbs_CustomObject | Where-Object -Property "ExpectedState" -eq "NotExist" | Measure-Object).Count -le 0) {Write-Output "None"} else {Write-Output (($IIS_RequestFiltering_Verbs_CustomObject | Where-Object -Property "ExpectedState" -eq "NotExist").Verb -join ", ")})
            Write-Host "          Feature: " -NoNewline

            # Check if Feature Installed
                if ($IIS_Feature_RequestFiltering.Installed -eq $false) {
                    Write-Host "Not Installed" -ForegroundColor DarkGray
                    Write-Host "          Skipping this step since request filtering is not installed" -ForegroundColor Yellow

                    $Remediate = $false
                }
                else {
                    Write-Host "Installed" -ForegroundColor Green

                    $Remediate = $true
                }

            # Check if Verb Exists and Get Actual State
                $IIS_RequestFiltering_Verbs_Actual = Get-WebConfiguration  -PSPath "IIS:\sites\$($IIS_Website)" -Filter "System.WebServer/Security/RequestFiltering/Verbs/*" -Recurse

                foreach ($Item in $IIS_RequestFiltering_Verbs_CustomObject) {
                    if ($Item.Verb -in $IIS_RequestFiltering_Verbs_Actual.Verb) {
                        $Item.Exists = $true

                        switch (($IIS_RequestFiltering_Verbs_Actual | Where-Object -Property Verb -eq $Item.Verb).Allowed) {
                            { $_ -eq $true } { $Item.ActualState = 'Allow'; break }
                            { $_ -eq $false } { $Item.ActualState = 'Deny'; break }
                            Default { $Item.ActualState = 'Unknown'; break}
                        }
                    }
                    else {
                        $Item.Exists = $false

                        $Item.ActualState = "NotExist"
                    }
                }

            # Check if Remediation is Needed
                foreach ($Item in $IIS_RequestFiltering_Verbs_CustomObject) {
                    if ($Item.ExpectedState -eq $Item.ActualState) {
                        $Item.Remediate = $false
                    }
                    else {
                        $Item.Remediate = $true
                    }
                }

        # Remediate
            Write-Host "          -----------------------------------------------------"
            foreach ($Item in $IIS_RequestFiltering_Verbs_CustomObject) {
                Write-Host "              $($Item.Verb): " -NoNewline

                if ($Item.Remediate -eq $true) {
                    try {
                        # Get Data
                            $IIS_RequestFiltering_Verbs_Collection = Get-IISConfigSection -CommitPath $($IIS_Website) -SectionPath 'system.webServer/security/requestFiltering' | Get-IISConfigCollection -CollectionName 'verbs'

                        # Delay IIS Commits for Changes
                            Start-IISCommitDelay -ErrorAction Stop

                        # Make Changes
                            switch ($Item.ExpectedState) {
                                {$_ -eq "Allow" } {
                                    # Modify Existing
                                        if ($Item.Exists -eq $true) {
                                            $IIS_RequestFiltering_Verbs_Element = Get-IISConfigCollectionElement -ConfigCollection $IIS_RequestFiltering_Verbs_Collection -ConfigAttribute @{ 'verb'=$($Item.Verb) }
                                            Set-IISConfigAttributeValue -ConfigElement $IIS_RequestFiltering_Verbs_Element -AttributeName "Allowed" -AttributeValue $true
                                        }
                                    # Create New
                                        else {
                                            New-IISConfigCollectionElement -ConfigCollection $IIS_RequestFiltering_Verbs_Collection -ConfigAttribute @{ 'verb'=$($Item.Verb);'allowed'=$true }
                                        }

                                    # Complete Actions
                                        $Item.Status = 'Allowed'
                                        Write-Host $Item.Status -ForegroundColor Green
                                        break
                                }
                                {$_ -eq "Deny" } {
                                    # Modify Existing
                                        if ($Item.Exists -eq $true) {
                                            $IIS_RequestFiltering_Verbs_Element = Get-IISConfigCollectionElement -ConfigCollection $IIS_RequestFiltering_Verbs_Collection -ConfigAttribute @{ 'verb'=$($Item.Verb) }
                                            Set-IISConfigAttributeValue -ConfigElement $IIS_RequestFiltering_Verbs_Element -AttributeName "Allowed" -AttributeValue $false
                                        }
                                    # Create New
                                        else {
                                            New-IISConfigCollectionElement -ConfigCollection $IIS_RequestFiltering_Verbs_Collection -ConfigAttribute @{ 'verb'=$($Item.Verb);'allowed'=$false }
                                        }

                                    # Complete Actions
                                        $Item.Status = 'Denied'
                                        Write-Host $Item.Status -ForegroundColor Green
                                        break
                                }
                                {$_ -eq "NotExist" } {
                                    # Remove Existing
                                        if ($Item.Exists -eq $true) {
                                            $IIS_RequestFiltering_Verbs_Element = Get-IISConfigCollectionElement -ConfigCollection $IIS_RequestFiltering_Verbs_Collection -ConfigAttribute @{ 'verb'=$($Item.Verb) }
                                            Set-IISConfigAttributeValue -ConfigElement $IIS_RequestFiltering_Verbs_Element -AttributeName "Allowed" -AttributeValue $false
                                        }
                                    # Create New
                                        else {
                                            New-IISConfigCollectionElement -ConfigCollection $IIS_RequestFiltering_Verbs_Collection -ConfigAttribute @{ 'verb'=$($Item.Verb);'allowed'=$false }
                                        }

                                    # Complete Actions


                                    Remove-IISConfigCollectionElement -ConfigCollection $IIS_RequestFiltering_Verbs_Collection -ConfigAttribute @{ 'verb'=$($Item.Verb) } -Confirm:$false -ErrorAction Stop

                                    $Item.Status = 'Removed'

                                    Write-Host $Item.Status -ForegroundColor Green
                                    break
                                }
                                Default { $Item.Status = 'Unknown'; break}
                            }

                        # Commit Changes to IIS
                            Stop-IISCommitDelay -ErrorAction Stop
                    }
                    catch {
                        Write-Host "Failure" -ForegroundColor Red
                        Pause
                    }
                }
                else {
                    $Item.Status = 'Already Compliant'
                    Write-Host "Already Compliant" -ForegroundColor DarkGray
                }
            }























    # Start UI for Validation
        Start-Process -FilePath inetmgr.exe

#EndRegion Configure IIS
<# --------------------------------------------------------------------------------------------------------------------------------------- #>
