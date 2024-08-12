# Set Variables
    # Names
        $Name_TS_Step               = "Create - Client Variables"

    # Paths
        $Path_TS_LogFile            = "C:\VR\MECM\Logs\Client\SMSTSLog\smsts.log"

    # Patterns
        $Pattern_Log_StartMessage   = "*Start executing an instruction. Instruction name: *$Name_TS_Step*"
        $Pattern_Log_StopMessage    = "*Successfully completed the action *$Name_TS_Step*"
        $Regex_Log_Message          = '(?<=LOG\[).+?(?=\])'

    # Arrays
        $Array_Log_CapturedLines    = @()

# Get Data
    $Content_TS_LogFile             = Get-Content -Path $Path_TS_LogFile

# Parse Data
    foreach ($Item in $Content_TS_LogFile) {
        if ($Item -like $Pattern_Log_StartMessage) {
            $Temp_Log_StartLine = $Item.ReadCount
        }

        if ($Item -like $Pattern_Log_StopMessage) {
            $Temp_Log_EndLine = $Item.ReadCount
            #Break
        }
    }

    $Temp_Counter = $Temp_Log_StartLine - 1
    do {
        $Temp_Line_Number   = $Content_TS_LogFile[$Temp_Counter].ReadCount
        $Temp_Line_LogText  = [regex]::Matches($Content_TS_LogFile[$Temp_Counter], $Regex_Log_Message).Value
        $Temp_Line_Concat   =  "$($Temp_Line_Number): $($Temp_Line_LogText)"
        Write-Host $Temp_Line_Concat
        $Array_Log_CapturedLines += $Temp_Line_Concat
        $Temp_Counter += 1
    } until (
        $Temp_Counter -ge $Temp_Log_EndLine
    )


# Output Data

