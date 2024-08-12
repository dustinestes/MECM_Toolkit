# VividRock - MECM - Task Sequence Toolkit - Logging

    Author:         Dustin Estes
    Created:        2018-01-08
    Copyright:      VividRock LLC | All Rights Reserved
    Website:	    https://www.vividrock.com
    Version:        1.0.0

    Description:    Provides a mechanism for storing logging info to a Task Sequence Variable for
                    output at the end of the Task Sequence.

    Prerequisites:
        1. Your Task Sequence must have the following
            - A step at the beginning with the "Initialize Logging" snippet below
            - A step at the end with the "Finalize Logging" snippet below
            - Any number of standard logging outputs between these two steps

    How to Use:
        2. Create Run PowerShell Script steps within the Task Sequence
        3. Ensure of the following settings
            Name: VR Log - [Step Name to Log]
            Description: A VividRock - Task Sequence Toolkit step for creating simplified logging
            Enter a PowerShell Script: Paste script snippets from below into the code editor
            PowerShell Execution Policy: Bypass

    Operation:
        The script functions as follows:
            1. Creates ComObjects to MECM Task Sequence Environment
            2. Commits provided log data to the log Task Sequence Variable
            3. Exits appropriately

    Exit Codes:
        Provide a table of the exit codes that are in the script so the reader can quickly identify the code to its
        reason for termination.
            0           The script processed successfully

&nbsp;

## Initialize Logging

This code snippet is used to initialize the logging within the Task Sequence and generates the Task Sequence Variable utilized by the subsequent logging steps.

> Note:
>
> This step must come at the beginning of the Task Sequence before any other logging steps occur otherwise the log will be incomplete

```powershell
<#-----------------------------------------------------------------------------------------------------------
   VividRock - MECM - Task Sequence Toolkit - Logging
-------------------------------------------------------------------------------------------------------------

    Author:         Dustin Estes
    Created:        2018-02-12
    Copyright:      VividRock LLC | All Rights Reserved
    Website:	    https://www.vividrock.com
    Version:        1.0.0

    Description:    This code snippet is used to initialize the logging within the Task Sequence and
                    generates the Task Sequence Variable utilized by the subsequent logging steps.

    Note:           This step must come at the beginning of the Task Sequence before any other logging steps
                    occur otherwise the log will be incomplete

-------------------------------------------------------------------------------------------------------------#>


<# ---------------------------------------------------------------------------------------------
    Initialize MECM Task Sequence Environment
------------------------------------------------------------------------------------------------
    Create COM Objects and get data from the MECM Environment
------------------------------------------------------------------------------------------------ #>
#Region

    # Create TSEnvironment ComObject
        $Object_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction SilentlyContinue

    # Get Log File Path
        $Log_OutputFile = $Object_TSEnvironment.Value("vr_Logging_PrimaryLog")

#EndRegion Initialize MECM Task Sequence Environment


<# ---------------------------------------------------------------------------------------------
    Construct Header
------------------------------------------------------------------------------------------------
    Constructs the header block with all of the data that should precede log entries
------------------------------------------------------------------------------------------------ #>
#Region

    # Log Header
        $Log_Header = @"
------------------------------------------------------------------------------------------------------
  VividRock - MECM - Task Sequence Toolkit - Logging
------------------------------------------------------------------------------------------------------

    Task SequenceName:  $($Object_TSEnvironment.Value("_SMSTSPackageName"))
    Start Date (UTC):   $($Object_TSEnvironment.Value("vr_Meta_DateStartUTC"))
    Start Time (UTC):   $($Object_TSEnvironment.Value("vr_Meta_TimeStartUTC"))
    Log File Path:      $($Object_TSEnvironment.Value("vr_Logging_PrimaryLog"))

------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------
  Device Data
------------------------------------------------------------------------------------------------------

    Manufacturer:     $($Object_TSEnvironment.Value("vr_Device_Manufacturer"))
    Model:            $($Object_TSEnvironment.Value("vr_Device_Model"))
    Chassis Type:     $($Object_TSEnvironment.Value("vr_Device_ChassisType"))
    DeviceType:       $($Object_TSEnvironment.Value("vr_Device_DeviceType"))
    Virtual:          $($Object_TSEnvironment.Value("vr_Device_Virtual"))
    Serial #:         $($Object_TSEnvironment.Value("vr_Device_SerialNumber"))
    Asset Tag:        $($Object_TSEnvironment.Value("vr_Device_AssetTag"))
    IP Addresses:     $($Object_TSEnvironment.Value("_SMSTSIPAddresses"))
    MAC Addresses:    $($Object_TSEnvironment.Value("_SMSTSMacAddresses"))
    Launch Mode:      $($Object_TSEnvironment.Value("_SMSTSLaunchMode"))
    Management Point: $($Object_TSEnvironment.Value("_SMSTSMP"))
    Boot Disk:        $($Object_TSEnvironment.Value("_SMSTSDiskLabel1"))

------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------
  Log Content
------------------------------------------------------------------------------------------------------

"@

#EndRegion Construct Header


<# ---------------------------------------------------------------------------------------------
    Set Task Sequence Variables
------------------------------------------------------------------------------------------------
    Set the specified value to the identified Task Sequence Variable
------------------------------------------------------------------------------------------------ #>
#Region

    # Set Header to Task Sequence Variable
        $Object_TSEnvironment.Value("vr_Logging_Content") = $Log_Header

#EndRegion Set Task Sequence Variables


<# ---------------------------------------------------------------------------------------------
    Output to File
------------------------------------------------------------------------------------------------
    Outputs the content to the Task Sequence Log File
------------------------------------------------------------------------------------------------ #>
#Region

    # Write to Task Sequence Log File
        if ((Test-Path -Path $(Split-Path -Path $Log_OutputFile)) -eq $false) {
            New-Item -Path $((Split-Path $Log_OutputFile).Replace("`"","")) -ItemType Directory -Force
        }

        Out-File -InputObject $Log_Header -FilePath $Log_OutputFile.Replace("`"","") -Force

#EndRegion Output to File
```

&nbsp;

## Finalize Logging

This code snippet is used to finalize the logging within the Task Sequence and convert the Task Sequence Variable content to a physical log file.

> Note:
>
> This step must come at the end of the Task Sequence after all other logging steps occur otherwise the log will be incomplete and will not output
&nbsp;

```powershell
<#-----------------------------------------------------------------------------------------------------------
   VividRock - MECM - Task Sequence Toolkit - Logging
-------------------------------------------------------------------------------------------------------------

    Author:         Dustin Estes
    Created:        2018-02-12
    Copyright:      VividRock LLC | All Rights Reserved
    Website:	    https://www.vividrock.com
    Version:        1.0.0

    Description:    This code snippet is used to finalize the logging within the Task Sequence and convert
                    the Task Sequence Variable content to a physical log file.

    Note:           This step must come at the end of the Task Sequence after all other logging steps occur
                    otherwise the log will be incomplete and will not output


-------------------------------------------------------------------------------------------------------------#>

# Provide Log Data

    # Define Based On Location in Task Sequence Steps
        $Status_TaskSequence = "Success/Failure"




# Don't Edit Below This Line
# -------------------------------------------------------------------------------------------------------------


<# ---------------------------------------------------------------------------------------------
    Initialize MECM Task Sequence Environment
------------------------------------------------------------------------------------------------
    Create COM Objects and get data from the MECM Environment
------------------------------------------------------------------------------------------------ #>
#Region

    # Create TSEnvironment ComObject
        $Object_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction SilentlyContinue

    # Get Log File Path
        $Log_OutputFile = $Object_TSEnvironment.Value("vr_Logging_PrimaryLog")

    # Set Date/Time Completion Variables
        $Object_TSEnvironment.Value("vr_Meta_DateStopUTC") = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
        $Object_TSEnvironment.Value("vr_Meta_TimeStopUTC") = (Get-Date).ToUniversalTime().ToString("HH:mm:ss")

#EndRegion Initialize MECM Task Sequence Environment


<# ---------------------------------------------------------------------------------------------
    Construct Footer
------------------------------------------------------------------------------------------------
    Constructs the Footer block with all of the data that should follow log entries
------------------------------------------------------------------------------------------------ #>
#Region

    # Log Footer
        $Log_Footer = @"
------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------
  Logging Complete
------------------------------------------------------------------------------------------------------

    Execution Status:   $($Status_TaskSequence)
    Finish Date (UTC):  $($Object_TSEnvironment.Value("vr_Meta_DateStopUTC"))
    Finish Time (UTC):  $($Object_TSEnvironment.Value("vr_Meta_TimeStopUTC"))

------------------------------------------------------------------------------------------------------
"@

#EndRegion Construct Footer


<# ---------------------------------------------------------------------------------------------
    Set Task Sequence Variables
------------------------------------------------------------------------------------------------
    Set the specified value to the identified Task Sequence Variable
------------------------------------------------------------------------------------------------ #>
#Region

    # Set Footer to Task Sequence Variable
        $Object_TSEnvironment.Value("vr_Logging_Content") += $("`n" + $Log_Footer)

#EndRegion Set Task Sequence Variables


<# ---------------------------------------------------------------------------------------------
    Output to File
------------------------------------------------------------------------------------------------
    Outputs the content to the Task Sequence Log File
------------------------------------------------------------------------------------------------ #>
#Region

    # Write to Task Sequence Log File
        if ((Test-Path -Path $(Split-Path -Path $Log_OutputFile)) -eq $false) {
            New-Item -Path $((Split-Path $Log_OutputFile).Replace("`"","")) -ItemType Directory -Force
        }

        Out-File -InputObject $Log_Footer -FilePath $Log_OutputFile.Replace("`"","") -Append -Force

#EndRegion Output to File
```

&nbsp;

## Add Log Entry

This code snippet is used every time you want to add an entry to the VividRock logging mechanism.

```powershell
<#-----------------------------------------------------------------------------------------------------------
   VividRock - MECM - Task Sequence Toolkit - Logging
-------------------------------------------------------------------------------------------------------------

    Author:         Dustin Estes
    Created:        2018-02-12
    Copyright:      VividRock LLC | All Rights Reserved
    Website:	    https://www.vividrock.com
    Version:        1.0.0

-------------------------------------------------------------------------------------------------------------#>

# Provide Log Data

    # Provide Message
        $Message_Content = ""

    # Provide Message Type
    #   Group   = "    $Message_Content"
    #   Step    = "      - $Message_Content"
    #   Status  = "          Status: $Message_Content"
        $Message_Type = ""




# Don't Edit Below This Line
# -------------------------------------------------------------------------------------------------------------


<# ---------------------------------------------------------------------------------------------
    Initialize MECM Task Sequence Environment
------------------------------------------------------------------------------------------------
    Create COM Objects and get data from the MECM Environment
------------------------------------------------------------------------------------------------ #>
#Region

    # Create TSEnvironment ComObject
        $Object_TSEnvironment = New-Object -ComObject Microsoft.SMS.TSEnvironment -ErrorAction SilentlyContinue

    # Get Log File Path
        $Log_OutputFile = $Object_TSEnvironment.Value("vr_Logging_PrimaryLog")

#EndRegion Initialize MECM Task Sequence Environment


<# ---------------------------------------------------------------------------------------------
    Construct Log Entry
------------------------------------------------------------------------------------------------
    Constructs the Log Entry block with all of the data that should be entered with it
------------------------------------------------------------------------------------------------ #>
#Region

    # Construct Time Stamp
        $Message_Timestamp = (Get-Date).ToUniversalTime().ToString("HH:mm:ss")

    # Construct Message Format
    switch ($Message_Type) {
        "Group"     { $Message_Content = $("    " + $Message_Content) }
        "Step"      { $Message_Content = $("      - " + $Message_Content) }
        "Status"    { $Message_Content = $("          Status: " + $Message_Content) }
        Default     { $Message_Content = $Message_Content }
    }

    # Log Log Entry
        $Log_LogEntry = @"
$($Message_TimeStamp)    $($Message_Content)
"@

#EndRegion Construct Footer


<# ---------------------------------------------------------------------------------------------
    Set Task Sequence Variables
------------------------------------------------------------------------------------------------
    Set the specified value to the identified Task Sequence Variable
------------------------------------------------------------------------------------------------ #>
#Region

    # Set Footer to Task Sequence Variable
        $Object_TSEnvironment.Value("vr_Logging_Content") += $("`n" + $Log_LogEntry)

#EndRegion Set Task Sequence Variables


<# ---------------------------------------------------------------------------------------------
    Output to File
------------------------------------------------------------------------------------------------
    Outputs the content to the Task Sequence Log File
------------------------------------------------------------------------------------------------ #>
#Region

    # Write to Task Sequence Log File
        if ((Test-Path -Path $(Split-Path -Path $Log_OutputFile)) -eq $false) {
            New-Item -Path $((Split-Path $Log_OutputFile).Replace("`"","")) -ItemType Directory -Force
        }

        Out-File -InputObject $Log_LogEntry -FilePath $Log_OutputFile.Replace("`"","") -Append -Force

#EndRegion Output to File
```
