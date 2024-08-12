<# ------------------------------------------------------------------------------------------------------------------------------------------
    VividRock - MECM Toolkit - Site System Configurator - Distribution Point
---------------------------------------------------------------------------------------------------------------------------------------------

    Author:     Dustin Estes
    Copyright:  VividRock LLC | All rights reserved
                THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    Created:    2016-02-18
    Version:    1.0

    Description:
        Script for configuring Distribution Points within an MECM site.

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
            0           The script processed successfully

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
        $Script_Name                = "Distribution Point"
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



<# ------------------------------------------------------------------------------------------------------------------------------------------
    Set Variables
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for providing input prior to execution
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host "  Set Variables"

    # Security Rights
        $Group_DesiredMembers = "VividRock\GRP.CM.SiteAdmins","VividRock\GRP.CM.SiteServers"

    # Prepare Disk Drives
        $Volume_DesiredDriveLetter = "E:"
        $Volume_DesiredDriveLabel = "Distribution Point Content"
        $FilterCriteria_VolumeSize = 300
        $FilterCritera_VolumeDriveLetter = $Volume_DesiredDriveLetter,"",$null
        $FilterCriteria_VolumeDriveType = 3

    # Certificate Information
	    $TemplateNames = @(
		    ""
            ""
	    )
	    $Certificate_TargetStore    = "cert:\LocalMachine\My"
	    $Server_Name                = $env:COMPUTERNAME
	    $Server_FQDN                = $env:COMPUTERNAME + "." + $ENV:USERDNSDOMAIN
        $Certificate_IISTemplate    = ""

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
        $Group_ActualMembers = Get-LocalGroupMember -Name "Administrators"

    # Evaluate Memberships
        Write-Host "    - Add Identities to Local Administrator Group"

        foreach ($DesiredMember in $Group_DesiredMembers) {
            Write-Host "        $($DesiredMember): " -NoNewLine

            if ($Group_ActualMembers.Name -contains $DesiredMember) {
                Write-Host "Already Exists" -ForegroundColor DarkGray
            }
            else {
                try {
                    Add-LocalGroupMember -Group "Administrators" -Member $DesiredMember -ErrorAction Stop
                    Write-Host "Member Added Successfully" -ForegroundColor Green
                }
                catch {
                    Write-Host "Failed to Add Member" -ForegroundColor Red
                }
            }
        }

#EndRegion Configure Security
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Prepare Disk Drives
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for configuring the disk drives
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Prepare Disk Drives"
    Pause
    Write-Host ""

    # Get All Volumes
        # $Volumes_All = Get-Volume | Where-Object -FilterScript {($_.DriveLetter -notin $FilterCritera_Volumes) -and ($_.DriveType -ne "CD-ROM")}
        $Volumes_All = Get-CimInstance -ClassName Win32_Volume | Where-Object -Property DriveType -NE "5"

    # Configure Data Drive:
        Write-Host "    - Configure Data Drive"
        foreach ($Volume in $Volumes_All) {
                Write-Host "        Drive:   "$Volume.Caption
                Write-Host "        Size >= $($FilterCriteria_VolumeSize) GB?: " -NoNewline

            if ($($Volume.Capacity / 1gb) -ge $FilterCriteria_VolumeSize) {
                Write-Host " True" -ForegroundColor Green

                Write-Host "        Letter = $($Volume_DesiredDriveLetter)?: " -NoNewline
                if ($($Volume.DriveLetter) -eq $Volume_DesiredDriveLetter) {
                    Write-Host " True" -ForegroundColor Green
                }
                else {
                    Write-Host "False" -ForegroundColor Gray
                    try {
                        $Volume | Set-CimInstance -Property @{
                            DriveLetter = "$($Volume_DesiredDriveLetter)";
                            Label = "$($Volume_DesiredDriveLabel)"
                        }
                        Write-Host "        Drive Configured Successfully" -ForegroundColor Cyan
                    }
                    catch {
                        Write-Host "        Failed to Add Member" -ForegroundColor Cyan
                    }
                }

                Write-Host "        Label = $($Volume_DesiredDriveLabel)?: " -NoNewline
                if ($($Volume.Label) -eq $Volume_DesiredDriveLabel) {
                    Write-Host " True" -ForegroundColor Green
                }
                else {
                    Write-Host "False" -ForegroundColor Gray
                    try {
                        $Volume | Set-CimInstance -Property @{
                            Label = "$($Volume_DesiredDriveLabel)"
                        }
                        Write-Host "        Configured Successfully" -ForegroundColor Cyan
                    }
                    catch {
                        Write-Host "        Failed to Configure" -ForegroundColor Cyan
                    }
                }
            }
            else {
                Write-Host " False" -ForegroundColor Red
                Write-Host "        Status:  " -NoNewLine
                Write-host " Not Applicable" -ForegroundColor DarkGray
            }

            Write-Host ""
        }

    # Add NO_SMS_ON_DRIVE File
        Write-Host "    - Add NO_SMS_ON_DRIVE.sms File to All Other Drives"
        foreach ($Volume in $Volumes_All) {
            if (($Volume.DriveLetter -notin $FilterCritera_VolumeDriveLetter) -and ($Volume.DriveType -eq $FilterCriteria_VolumeDriveType)) {
                Write-Host "        $($Volume.DriveLetter)" -NoNewline
                try {
                    if (Test-Path -Path $($Volume.DriveLetter + "\NO_SMS_ON_DRIVE.sms") -PathType Leaf) {
                        Write-Host " Already Exists" -ForegroundColor DarkGray
                    }
                    else {
                        New-Item -Path $($Volume.DriveLetter + "\") -Name "NO_SMS_ON_DRIVE.sms" -ItemType File -Force -ErrorAction Stop | Out-Null
                        Write-Host " Success" -ForegroundColor Green
                    }
                }
                catch {
                    Write-Host " Failure" -ForegroundColor Red
                }
            }
        }

    # Start UI for Validation
        Start-Process -FilePath explorer.exe

#EndRegion Prepare Disk Drives
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Enroll in Certificates
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for enrolling in PKI certificates
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Enroll in Certificates"
    Pause
    Write-Host ""

    # Enroll in Certificates
	    foreach ($Template in $TemplateNames) {
		    try {
			    Write-Host "    - Certificate: "$Template

			    if ($Template -eq $Certificate_IISTemplate) {
				    $Enroll_Result = Get-Certificate -SubjectName $("CN=" + $Server_FQDN) -DnsName $Server_Name, $Server_FQDN -CertStoreLocation $Certificate_TargetStore -Template "$($Template)" -Url ldap: -ErrorAction Stop
			    }
			    else {
				    $Enroll_Result = Get-Certificate -CertStoreLocation $Certificate_TargetStore -Template "$($Template)" -Url ldap: -ErrorAction Stop
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
		    }
	    }

    # Start UI for Validation
        Start-Process -FilePath certlm.msc

#EndRegion Enroll in Certificates
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Add Roles & Features
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for adding windows roles and features
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Add Roles & Features"
    Pause
    Write-Host ""

    # Define Variables
        $Array_RolesFeatures = [ordered] @{
            # Role Service = Name

            # Add .NET Framework
                ".Net Framework 4.6" = "NET-Framework-45-Core"
                ".Net TCP Port Sharing" = "NET-WCF-TCP-PortSharing45"

            # Add Remote Differential
                "Remote Differential Compression" = "RDC"

            # Install File Server
                "File and Storage Services" = "FS-FileServer"

            # Install Windows Deployment Services
                "Windows Deployment Services" = "WDS"
                "WDS Deployment Server" = "WDS-Deployment"
                "WDS Transport Server" = "WDS-Transport"
                "WDS RSAT Tools" = "WDS-AdminPack"

            # Install Background Intelligent Transfer Service (BITS)
                "Background Intelligent Tranfser Service" = "BITS"
                "BITS IIS Server Extensions" = "BITS-IIS-Ext"
                "BITS RSAT Tools" = "RSAT-Bits-Server"

            # Add IIS Features
                "Web Server (IIS) Security" = "Web-Security"
                "Web Server (IIS) Request Filtering" = "Web-Filtering"
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

#EndRegion Add Roles & Features
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Configure IIS
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for configuring the IIS server role
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Configure IIS"
    Pause
    Write-Host ""

    # Get Certificate Information
        Write-Host "    - Get Certificate Thumbprint"
        Write-Host "          Template Name:"$Certificate_IISTemplate
        Write-Host "          Thumbprint: " -NoNewline

        try {
            $Certificate_Thumbprint = (Get-ChildItem $Certificate_TargetStore -ErrorAction Stop | Where-Object -FilterScript {($_.Extensions.Format(1)[0].split('(')[0] -replace "template=") -match $Certificate_IISTemplate}).Thumbprint
            Write-Host ""$Certificate_Thumbprint
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
        Write-Host "          Site Name:    Default Web Site"
        Write-Host "          Port Binding: *:443"
        Write-Host "          Protocol:     HTTPS"
        Write-Host "          Status:       " -NoNewline

        try {
            New-IISSiteBinding -Name "Default Web Site" -BindingInformation "*:443:" -CertificateThumbPrint $Certificate_Thumbprint -CertStoreLocation $Certificate_TargetStore -Protocol https -ErrorAction Stop
            Write-Host "Success" -ForegroundColor Green
        }
        catch {
            Write-Host "Error" -ForegroundColor Red
            Pause
        }

    # Start UI for Validation
        Start-Process -FilePath inetmgr.exe

#EndRegion Configure IIS
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Install MECM Roles
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for installing the MECM Site System Roles
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Install Site System Role"
    Pause
    Write-Host ""

    # Connect to MECM Environment
    # IMPORTANT: Run from Primary Site Server
    # Site configuration
        $MECM_SiteCode = "[SiteCode]" # Site code
        $MECM_ProviderMachineName = "[ServerFQDN]" # SMS Provider machine name

    # Import the ConfigurationManager.psd1 module
        if((Get-Module ConfigurationManager) -eq $null) {
            Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
        }

    # Connect to the site's drive if it is not already present
        if((Get-PSDrive -Name $MECM_SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
            New-PSDrive -Name $MECM_SiteCode -PSProvider CMSite -Root $MECM_ProviderMachineName
        }

    # Set the current location to be the site code.
        Set-Location "$($MECM_SiteCode):\"

    # Parameters
        $MECM_SiteSystemServerName  = Read-Host -Prompt "Input Distribution Point name FQDN"

    # Add the Server to the Hierarchy
        New-CMSiteSystemServer -SiteSystemServerName $MECM_SiteSystemServerName -SiteCode $MECM_SiteCode

    # Pause to Allow Change to Take Effect
        Start-Sleep -Seconds 30
        Pause
        Write-Host ""
        Write-host "Install Distribution Point Role"

    # Add Roles to the New Server
        $Date_CertExpiry = [DateTime]::Now.AddYears(30)
        #$Object_SiteSystemServer = Get-CMSiteSystemServer -SiteSystemServerName $MECM_SiteSystemServerName

        $Splat_AddDP = @{
            ClientConnectionType = "Intranet"
            EnableSsl = $true
            MinimumFreeSpaceMB = 1024
            PrimaryContentLibraryLocation = "E"
            PrimaryPackageShareLocation = "E"
            SiteCode = "[SiteCode]"
        }

        Add-CMDistributionPoint @Splat_AddDP -SiteSystemServerName $MECM_SiteSystemServerName -CertificateExpirationTimeUtc $Date_CertExpiry


#EndRegion Name
<# --------------------------------------------------------------------------------------------------------------------------------------- #>


<# ------------------------------------------------------------------------------------------------------------------------------------------
    Finalize
---------------------------------------------------------------------------------------------------------------------------------------------
    Section for finalizing the script
------------------------------------------------------------------------------------------------------------------------------------------ #>
#Region

    Write-Host ""
    Write-host "Finalize"
    Pause
    Write-Host ""
    Write-Host "  - Restart this VM (will automatically occur after you press enter)"
    Write-Host "  - Install the MECM Role"
    Write-Host "  - Validate Installation"

    Write-Host ""
    Pause

    Restart-Computer

#EndRegion Finalize
<# --------------------------------------------------------------------------------------------------------------------------------------- #>
