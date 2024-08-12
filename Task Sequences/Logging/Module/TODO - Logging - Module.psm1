<#---------------------------------------------------------------------------------------
    VividRock - Precipice 
-----------------------------------------------------------------------------------------
    Module:         Logging
    
    Author:         Dustin Estes
    Company:        VividRock
    Website:        www.vividrock.com

    Created:        06-12-2015
    Version:        1.0
    
    Description:    Provides logging support for Task Sequences within MECM. THe various
                    functions provided within this script format the output so that it 
                    opens properly within the CMTrace/One Trace log viewing tool.


    Version History
        v1.0 -  Tool was created and tested
                Added switch parameter for Header, Body, Footer to better format output
                Added Indent Levels for organizing data within the body of the logs
                Added a switch for writing CSV output as well for importing into Excel

    To Dos
        1. Add a function to generate a "watcher" service that monitors the 
        2. Move UTCDatTime function to separate module for this kind of data

---------------------------------------------------------------------------------------#>


<#---------------------------------------------------------------------------------------
    VARIABLES
---------------------------------------------------------------------------------------#>
	# Clear Variables
        $Error.clear()


<#---------------------------------------------------------------------------------------
    MODULE/SNAPIN/DOT SOURCING/REQUIREMENTS
---------------------------------------------------------------------------------------#>


<#---------------------------------------------------------------------------------------
    HELP
---------------------------------------------------------------------------------------#>
    <#
        .SYNOPSIS
            Testing
        .DESCRIPTION
        .PARAMETER
        .PARAMETER
        .INPUTS
        .OUTPUTS
        .EXAMPLE
        .EXAMPLE
        .LINK
    #>


<#---------------------------------------------------------------------------------------
    FUNCTIONS
---------------------------------------------------------------------------------------#>
function Get-UTCDateTime {
    [CmdletBinding()]
        Param(
            [parameter(Mandatory=$true)]
            [ValidateSet("Date","Time")]
            [String]$Output
        )

        # Get current date and time in correct format
            $Now = Get-Date
            $Format = $Now.ToUniversalTime().Tostring("MM-dd-yyyy HH:mm:ss.fff")
            
            $Array = $Format.Split(" ")

        # Process requested output and return
            if ($Output -eq "Date") {
                Return $Array[0]
            }
            elseif ($Output -eq "Time") {
                Return $Array[1]
            }
            else {
                Write-Host "ERROR: Incorrect value supplied"
            }
    
}


Function Write-VRLog {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [String]$Message,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Header", "Body", "Footer")]
        [String]$Style="Body",
        [Parameter(Mandatory=$false)]
        [String]$IndentLevel="0",
        [parameter(Mandatory=$false)]
        [String]$Component=$MyInvocation.MyCommand,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Info", "Warning", "Error")]
        [String]$Type="Info",
        [parameter(Mandatory=$false)]
        [String]$File="Undefined",
        [parameter(Mandatory=$true)]
        [String]$LogPath,
        [parameter(Mandatory=$false)]
        [switch]$OutCSV
    )
    

    <#---------------------------------------------------------------------------------------
        VARIABLES
    ---------------------------------------------------------------------------------------#>
        # Convert names to their corresponding value
            $TypeInt = switch ($Type) {
                "Info" { "1" }
                "Warning" { "2" }
                "Error" { "3" }
                default { "1" }
            }

        # Concatenate indentions to match indent level
            if ($IndentLevel -eq "0") {
                $Indent = ""
            }
            else {
                $i = 0
                $Indent = $null

                do {
                    $Indent = $Indent + "    "
                    $i = $i + 1
                } until ($i -eq $IndentLevel)
            }

        # Hash of the various log line components that are used to concatenate the entry
            $CONCATENATION_HASH = @{
                MessagePrefix = "<!"
                MessageOpen = "[LOG["
                Message = $Message
                MessageClose = "]LOG]"
                MessageSuffix = "!>"
                MetadataPrefix = "<"
                TimePrefix = "time=`""
                Time = (Get-UTCDateTime -Output Time)
                TimeSuffix = "+000`""
                DatePrefix = "date=`""
                Date = (Get-UTCDateTime -Output Date)
                DateSuffix = "`""
                ComponentPrefix = "component=`""
                Component = $Component
                ComponentSuffix = "`""
                ContextPrefix = "context=`""
                Context = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
                ContextSuffix = "`""
                TypePrefix = "type=`""
                Type = $TypeInt
                TypeSuffix = "`""
                ThreadPrefix = "thread=`""
                Thread = $([Threading.Thread]::CurrentThread.ManagedThreadId)
                ThreadSuffix = "`""
                FilePrefix = "file=`""
                File = $File
                FileSuffix = "`""
                MetadataSuffix = ">"
                Divider = "-------------------------------------------------------------------------------------------------------------------------------------------------------------"
                Indent = $Indent
            }

    <#---------------------------------------------------------------------------------------
        NESTED FUNCTIONS
    ---------------------------------------------------------------------------------------#>

        function Write-Divider {
            $Messagetring = $CONCATENATION_HASH.MessagePrefix + $CONCATENATION_HASH.MessageOpen + $CONCATENATION_HASH.Divider + $CONCATENATION_HASH.MessageClose + $CONCATENATION_HASH.MessageSuffix
            $MetadataString = $CONCATENATION_HASH.MetadataPrefix + $CONCATENATION_HASH.TimePrefix + $CONCATENATION_HASH.Time + $CONCATENATION_HASH.TimeSuffix + " " + $CONCATENATION_HASH.DatePrefix + $CONCATENATION_HASH.Date + $CONCATENATION_HASH.DateSuffix + " " + $CONCATENATION_HASH.ComponentPrefix + $CONCATENATION_HASH.Component + $CONCATENATION_HASH.ComponentSuffix + " " + $CONCATENATION_HASH.ContextPrefix + $CONCATENATION_HASH.Context + $CONCATENATION_HASH.ContextSuffix + " " + $CONCATENATION_HASH.TypePrefix + $CONCATENATION_HASH.Type + $CONCATENATION_HASH.TypeSuffix + " " + $CONCATENATION_HASH.ThreadPrefix + $CONCATENATION_HASH.Thread + $CONCATENATION_HASH.ThreadSuffix + " " + $CONCATENATION_HASH.FilePrefix + $CONCATENATION_HASH.File + $CONCATENATION_HASH.FileSuffix + $CONCATENATION_HASH.MetadataSuffix
            $DividerString = $Messagetring + $MetadataString
            
            Add-Content -Path $LogPath -Value $DividerString
        }
    <#---------------------------------------------------------------------------------------#>


    <#---------------------------------------------------------------------------------------
        MAIN EXECUTION
    ---------------------------------------------------------------------------------------#>
        # Write the line to the log file
            # Concatenate the parameters and hash table values
                $Messagetring = $CONCATENATION_HASH.MessagePrefix + $CONCATENATION_HASH.MessageOpen + $CONCATENATION_HASH.Indent + $CONCATENATION_HASH.Message + $CONCATENATION_HASH.MessageClose + $CONCATENATION_HASH.MessageSuffix
                $MetadataString = $CONCATENATION_HASH.MetadataPrefix + $CONCATENATION_HASH.TimePrefix + $CONCATENATION_HASH.Time + $CONCATENATION_HASH.TimeSuffix + " " + $CONCATENATION_HASH.DatePrefix + $CONCATENATION_HASH.Date + $CONCATENATION_HASH.DateSuffix + " " + $CONCATENATION_HASH.ComponentPrefix + $CONCATENATION_HASH.Component + $CONCATENATION_HASH.ComponentSuffix + " " + $CONCATENATION_HASH.ContextPrefix + $CONCATENATION_HASH.Context + $CONCATENATION_HASH.ContextSuffix + " " + $CONCATENATION_HASH.TypePrefix + $CONCATENATION_HASH.Type + $CONCATENATION_HASH.TypeSuffix + " " + $CONCATENATION_HASH.ThreadPrefix + $CONCATENATION_HASH.Thread + $CONCATENATION_HASH.ThreadSuffix + " " + $CONCATENATION_HASH.FilePrefix + $CONCATENATION_HASH.File + $CONCATENATION_HASH.FileSuffix + $CONCATENATION_HASH.MetadataSuffix
                $ConcatenatedString = $Messagetring + $MetadataString
                
            try {
                if ($Style -eq "Header") {
                    Write-Divider
                }

                if (($Style -eq "Header") -or ($Style -eq "Body")) {
                    Add-Content -Path $LogPath -Value $ConcatenatedString
                }

                if (($Style -eq "Header") -or ($Style -eq "Footer")) {
                    Write-Divider
                }
            }
            catch {
                Write-Host "Error writing to log file"
            }

        # Write the line to a CSV if the switch is enabled
            if ($OutCSV) {
                # Remove extension of log file to create identically named CSV
                    $CSVPath = $LogPath.Substring(0, $LogPath.LastIndexOf('.'))
                    $CSVFile = $CSVPath + ".csv"

                # Concatenate CSV string
                    $ConcatenatedCSV = $CONCATENATION_HASH.Message + "," + $CONCATENATION_HASH.Time + "," + $CONCATENATION_HASH.Date + "," + $CONCATENATION_HASH.Component + "," + $CONCATENATION_HASH.Context + "," + $CONCATENATION_HASH.Type + "," + $CONCATENATION_HASH.Thread + "," + $CONCATENATION_HASH.File

                # Write header to file if it does not exist
                    if (-Not (Test-Path -Path $CSVFile)) {
                        $CSVHeader = "Message,Time,Date,Component,Context,Type,Thread,File"
                        Add-Content -Path $CSVFile -Value $CSVHeader        
                    }

                # Write line to file
                    Add-Content -Path $CSVFile -Value $ConcatenatedCSV
            }
}
    
    
Function Write-TSVariableValue {

        [CmdletBinding()]
        Param(
            [parameter(Mandatory=$true)]
            [String]$LogPath,
            [parameter(Mandatory=$true)]
            [String]$VariableName,
            [parameter(Mandatory=$false)]
            [String]$Component="Write-TSVariableValue",
            [Parameter(Mandatory=$false)]
            [ValidateSet("Info", "Warning", "Error")]
            [String]$Type="Info"
        )
        
        BEGIN {}
	    PROCESS {
            # Gather Variable Values
                # $Message = param value
                # $LogPath = param value
                $Time = $(Get-Date -Format "HH:mm:ss.fff")
                $Date = $(Get-Date -Format "MM-dd-yyyy")
                # $Component = param value
                $Context = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
                # $Type = param value
                $Thread = $([Threading.Thread]::CurrentThread.ManagedThreadId)
                $File = "VividRock_MECM-TaskSequenceLogging.psm1"
                
                switch ($Type) {
                    "Info" { [int]$Type = 1 }
                    "Warning" { [int]$Type = 2 }
                    "Error" { [int]$Type = 3 }
                }

        
            # Create a log entry
                $ConcatenatedMessage = "<![LOG[$Message]LOG]!><time=`"$Time`" date=`"$Date`" component=`"$Component`" context=`"$Context`" type=`"$Type`" thread=`"$Thread`" file=`"$File`""
    
    
            # Write the line to the log file
                try {
                    Add-Content -Path $LogPath -Value $ConcatenatedMessage
                }
                catch {
                    Write-Host "Error writing to log file"
                }    

        }
	    END {}

}
    

Function Install-VRLoggingService {

    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [String]$ServiceName,

        [parameter(Mandatory=$true)]
        [String]$ScriptLocation,

        [parameter(Mandatory=$false)]
        [String]$Component="Write-TSVariableValue",

        [Parameter(Mandatory=$false)]
        [ValidateSet("Info", "Warning", "Error")]
        [String]$Type="Info"
    )
    


    BEGIN {}
    PROCESS {
        # Gather Variable Values
            switch ($Type) {
                "Info" { [int]$Type = 1 }
                "Warning" { [int]$Type = 2 }
                "Error" { [int]$Type = 3 }
            }


        # Execute the function work
            try {
                
            }
            catch {
                
            }    

    }
    END {}

}


Function Start-VRLoggingService {

    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [String]$ServiceName,

        [parameter(Mandatory=$true)]
        [String]$ScriptLocation,

        [parameter(Mandatory=$false)]
        [String]$Component="Write-TSVariableValue",

        [Parameter(Mandatory=$false)]
        [ValidateSet("Info", "Warning", "Error")]
        [String]$Type="Info"
    )
    


    BEGIN {}
    PROCESS {
        # Gather Variable Values
            switch ($Type) {
                "Info" { [int]$Type = 1 }
                "Warning" { [int]$Type = 2 }
                "Error" { [int]$Type = 3 }
            }


        # Execute the function work
            try {
                
            }
            catch {
                
            }    

    }
    END {}

}

Function Stop-VRLoggingService {

    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [String]$ServiceName,

        [parameter(Mandatory=$true)]
        [String]$ScriptLocation,

        [parameter(Mandatory=$false)]
        [String]$Component="Write-TSVariableValue",

        [Parameter(Mandatory=$false)]
        [ValidateSet("Info", "Warning", "Error")]
        [String]$Type="Info"
    )
    


    BEGIN {}
    PROCESS {
        # Gather Variable Values
            switch ($Type) {
                "Info" { [int]$Type = 1 }
                "Warning" { [int]$Type = 2 }
                "Error" { [int]$Type = 3 }
            }


        # Execute the function work
            try {
                
            }
            catch {
                
            }    

    }
    END {}

}


Function Uninstall-VRLoggingService {

    [CmdletBinding()]
    Param(
        [parameter(Mandatory=$true)]
        [String]$ServiceName,

        [parameter(Mandatory=$true)]
        [String]$ScriptLocation,

        [parameter(Mandatory=$false)]
        [String]$Component="Write-TSVariableValue",

        [Parameter(Mandatory=$false)]
        [ValidateSet("Info", "Warning", "Error")]
        [String]$Type="Info"
    )
    


    BEGIN {}
    PROCESS {
        # Gather Variable Values
            switch ($Type) {
                "Info" { [int]$Type = 1 }
                "Warning" { [int]$Type = 2 }
                "Error" { [int]$Type = 3 }
            }


        # Execute the function work
            try {
                
            }
            catch {
                
            }    

    }
    END {}

}