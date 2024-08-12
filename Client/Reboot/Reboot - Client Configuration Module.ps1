<# -----------------------------------------------------------------------------------------------------------------------------
        MECM - Pending Reboot Reset
    --------------------------------------------------------------------------------------------------------------------------------

        Version: 1.0

        Purpose:
            Used to reset the reboot countdown on a device that has a pending reboot related to MECM actions such as:
                - Application Deployment
                - Software Updates
                - Task Sequences
                - Etc.

        How to Use:
            Either run from PowerShell manually or add to MECM as an application and use the deployment logic there.

        To Do:
            - Export Windows Event Logs (for auditing/troubleshooting)
            - Export MECM logs (for auditing/troubleshooting)
            - Export Registry key values and MECM SDK output (for auditing/troubleshooting)
            - Copy logs to network share/central log repository (for auditing/troubleshooting)
            - Clear Registry keys associated with reboot
            - Restart MECM agent
            - Create flag file or setting for MECM application to detect on

        Function:
            1.

    ----------------------------------------------------------------------------------------------------------------------------- #>


<# ---------------------------------------------------------------------------------------------
    Notification
------------------------------------------------------------------------------------------------
    Functions for creating notifications for the user
------------------------------------------------------------------------------------------------ #>
#Region

    # Send a toast notification to the user
    function New-vr_ToastNotification {
        [cmdletbinding()]
        Param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
            [string]
            $Title,
            [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
            [string]
            $Message
        )

        begin {

        }

        process {
            # Construct the Toast notification using XML and DOM constructors
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
                $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

                $RawXml = [xml] $Template.GetXml()
                ($RawXml.toast.visual.binding.text | Where-Object {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($Title)) > $null
                ($RawXml.toast.visual.binding.text | Where-Object {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($Message)) > $null

                $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
                $SerializedXml.LoadXml($RawXml.OuterXml)

                $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
                $Toast.Tag = "PowerShell"
                $Toast.Group = "PowerShell"
                $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(5)

                $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
                $Notifier.Show($Toast);
        }

        end {

        }
    }

#EndRegion Notification


<# ---------------------------------------------------------------------------------------------
    Testing
------------------------------------------------------------------------------------------------
    Functions for testing MECM reboots
------------------------------------------------------------------------------------------------ #>
#Region

    # Create a non-mandatory reboot state
    function Set-vr_MECM_Reboot_NonMandatory {
        param (

        )

        begin {
            # Set RebootBy deadline
                $RebootBy_Time = 0
        }

        process {
            # Set Registry values for testing a pending reboot
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootBy' -Value $RebootBy_Time -PropertyType QWord -Force -ErrorAction SilentlyContinue
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootValueInUTC' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'NotifyUI' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'HardReboot' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindowTime' -Value 0 -PropertyType QWord -Force -ErrorAction SilentlyContinue
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindow' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'PreferredRebootWindowTypes' -Value @("4") -PropertyType MultiString -Force -ErrorAction SilentlyContinue
                New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'GraceSeconds' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue
        }

        end {
            # Restart MECM Agent so it will process the Registry changes
                Restart-Service ccmexec -force
        }
    }

    # Create a mandatory reboot state
    function Set-vr_MECM_Reboot_Mandatory {
        param (

        )

        begin {
            $RebootBy_Time = [DateTimeOffset]::Now.ToUnixTimeSeconds()
        }

        process {
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootBy' -Value $RebootBy_Time -PropertyType QWord -Force -ErrorAction SilentlyContinue
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'RebootValueInUTC' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'NotifyUI' -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'HardReboot' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindowTime' -Value 0 -PropertyType QWord -Force -ErrorAction SilentlyContinue
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'OverrideRebootWindow' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'PreferredRebootWindowTypes' -Value @("4") -PropertyType MultiString -Force -ErrorAction SilentlyContinue
            New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Name 'GraceSeconds' -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue
        }

        end {
            # Restart MECM Agent so it will process the Registry changes
                Restart-Service ccmexec -force
        }
    }

#EndRegion Testing


<# ---------------------------------------------------------------------------------------------
    Remediation
------------------------------------------------------------------------------------------------
    Functions for remediating MECM reboots
------------------------------------------------------------------------------------------------ #>
#Region

    # Cancel a pending reboot
    function Stop-vr_MECM_Reboot {
        param (

        )

        begin {

        }

        process {
            # Delete pending reboot Registry entries
                Remove-Item -path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -Force -ErrorAction SilentlyContinue
                Remove-Item -path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Updates Management\Handler\UpdatesRebootStatus\*' -Force -ErrorAction SilentlyContinue
                Remove-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired' -name * -Force -ErrorAction SilentlyContinue

            # Use Shutdown command to abort current shutdown timer
                shutdown /a /m \\LOCALHOST
        }

        end {
            # Restart MECM Agent so it will process the Registry changes
                Restart-Service ccmexec -force
        }
    }


    # Change a pending reboot from mandatory to non-mandatory
    function Switch-vr_MECM_Reboot_PendingToNonMandatory {
        param (

        )

        begin {
            # Set RebootBy deadline
                $RebootBy_Time = 0
        }

        process {
            # Remove deadline date from the RebootBy Registry property
                Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -name 'RebootBy' -value $RebootBy_Time
                Remove-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -name 'GraceStartTimeStamp' -Force -ErrorAction SilentlyContinue
        }

        end {
            # Restart MECM Agent so it will process the Registry changes
                Restart-Service ccmexec -force
        }
    }

    # Change the pending mandatory reboot deadline to a time in the future
    # Note: could not get this to work, may need to remove more registry keys
    # function New-vr_MECM_Reboot_MandatoryDeadline {
    #     [cmdletbinding()]
    #     Param (
    #         [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
    #         [string]
    #         $Hours = 1,
    #         [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
    #         [string]
    #         $Minutes
    #     )

    #     begin {
    #         # Set RebootBy deadline to a future time provided by parameter
    #             $RebootBy_Time = ([DateTimeOffset]::Now.AddHours($Hours).AddMinutes($Minutes)).ToUnixTimeSeconds()
    #     }

    #     process {
    #         # Remove previous timestamps to reset countdown
    #             Remove-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -name 'GraceStartTimeStamp' -Force -ErrorAction Continue
    #             Remove-ItemProperty -path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -name 'InitiatedTimeStamp' -Force -ErrorAction Continue

    #         # Set RebootBy registry value to a new time in the future
    #             Set-Itemproperty -path 'HKLM:\SOFTWARE\Microsoft\SMS\Mobile Client\Reboot Management\RebootData' -name 'RebootBy' -value $RebootBy_Time
    #     }

    #     end {
    #         # Restart MECM Agent so it will process the Registry changes
    #             Restart-Service ccmexec -force
    #     }
    # }

#EndRegion Remediation


<# ---------------------------------------------------------------------------------------------
    Information Gathering
--------------------------------------------------------------------------------------------- #>
#Region
function Get-vr_MECM_Reboot_Status {
    param (

    )

    begin {

    }

    process {
        #Detect pending reboot:
            Invoke-CimMethod -Namespace root/ccm/ClientSDK -ClassName CCM_ClientUtilities -MethodName DetermineIfRebootPending
    }

    end {

    }
}
#EndRegion Name

