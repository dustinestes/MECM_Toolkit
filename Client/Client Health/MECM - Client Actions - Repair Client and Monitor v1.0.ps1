#$ComputerNames = Read-Host "Enter the computer name: "
[System.Collections.ArrayList]$ComputerNames = "DSST-W10-DE-002","DSST-W10-DE-006"

$FilePathToMonitor = "C:\Windows\ccmsetup\logs\ccmsetups.log"
$FileName
$FilePathToRun = "C:\Windows\ccm\ccmrepair.exe"
$CommandToRun = { cmd.exe /c $FilePathToRun }

$EvalTimeDate = Get-Date -Format "MM/dd/yyyy HH:mm"
#$EvalTimeDate = "04/30/2021 13:02:00"

$CountOfComputers = ($ComputerNames).Count
$CountOfExecutions = 0


Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "-----------------------------------------------------------------------------"
Write-Host "  MECM - Client Actions - Repair Client and Monitor"
Write-Host "-----------------------------------------------------------------------------"
Write-Host ""
Write-Host "    Author:    Dustin Estes"
Write-Host "    Date:      September 21, 2020"
Write-Host "    Purpose:   Gets the specified property from the file provided and then"
Write-Host "               compares the property value to the specified value. It will"
Write-Host "               continue to loop and monitor this property so you can see"
Write-Host "               if/when the property changes on the file."
Write-Host ""
Write-Host "-----------------------------------------------------------------------------"
Write-Host ""
Write-Host ""

# Loop through each provided computer name
    ForEach ($Computer in $ComputerNames){
    
    $CountOfExecutions = $CountOfExecutions + 1

    # Write section header
        Write-Host "    _______________________________________________________________"
        Write-Host ""
        Write-Host "      Processing Operation                                $CountOfExecutions/$CountOfComputers"
        Write-Host "    _______________________________________________________________"
        Write-Host "          ComputerName            = "$Computer
        Write-Host "          Evaluation Time & Date  = "$EvalTimeDate
        Write-Host ""
        Write-Host ""

        # Check connectivity to computer
            Write-Host "          Checking Connectivity"

            If (Test-Connection -ComputerName $Computer -Count 1 -Quiet) {
                Write-Host "              - Successfully connected to $Computer" -ForegroundColor Green
                Write-Host ""
            }
            Else {
                Write-Host "              - Error: $Computer is unreachable" -ForegroundColor Red
                Write-Host "              - Discontinuing operation" -ForegroundColor Gray
                Write-Host ""
                Continue  # Stop processing this item in the loop but continue processing the next ones
            }


        # Get information before script execution
            Write-Host ""
            Write-Host "          Checking File Property"

            # Check for file first
                If (Invoke-Command -ComputerName $Computer -ScriptBlock {Test-Path $using:FilePathToMonitor}) {
                    Write-Host "              - Found:  file exists" -ForegroundColor Cyan
                    $FileLastWriteTime = Invoke-Command -ComputerName $Computer -ScriptBlock {Get-ItemProperty -Path $using:FilePathToMonitor | Select-Object -ExpandProperty LastWriteTime}
                    $FileLastWriteTimeStr = $FileLastWriteTime.ToString("MM/dd/yyyy HH:mm:ss")
                }
                Else {
                    Write-Host "              - ERROR: $FilePathToMonitor file does not exist" -ForegroundColor Red
                    do {
                        Write-Host "              - Waiting for 10 seconds before rechecking" -ForegroundColor Gray
                        Start-Sleep -Seconds 10
                    } until (Invoke-Command -ComputerName $Computer -ScriptBlock {Test-Path $using:FilePathToMonitor})
                    
                    Write-Host "              - Found: $FilePathToMonitor" -ForegroundColor Cyan
                }
            
        # Run command and evaluate the file property value
            Write-Host ""
            Write-Host "          Evaluate File Property and Run"
            Write-Host "              - Evaluation Time & Date = " $EvalTimeDate
            Write-Host "              - File Property value    = " $FileLastWriteTimeStr
            Write-Host "              - File to Run            = " $FilePathToRun
            Write-Host "              - Command to Run         = " $CommandToRun
            Write-Host ""
            
            # Evaluate write time and execute
                If ($FileLastWriteTime -lt $EvalTimeDate) {

                    # Execute the command
                        If (Invoke-Command -ComputerName $Computer -ScriptBlock {Test-Path -Path $using:FilePathToRun}) {
                            Write-Host "              - Found: $FilePathToRun" -ForegroundColor Cyan
                            $CurrentTime = Get-Date -Format "MM/dd/yyyy HH:mm"
                            Write-Host "              - Exection Time = " $CurrentTime
                            Invoke-Command -ComputerName $Computer -ScriptBlock $CommandToRun
                            $CurrentTime = Get-Date -Format "MM/dd/yyyy HH:mm"
                            Write-Host "              - Completion Time = " $CurrentTime
                        }
                        Else {
                            Write-Host "              - ERROR: File not found" -ForegroundColor Red
                        }

                    # Evaluate file property value against evaluation value
                        do {
                            $FileLastWriteTime = Invoke-Command -ComputerName $Computer -ScriptBlock {Get-ItemProperty -Path $using:FilePathToMonitor | Select-Object -ExpandProperty LastWriteTime}
                            $FileLastWriteTimeStr = $FileLastWriteTime.ToString("MM/dd/yyyy HH:mm:ss")
                            Write-Host "              - File property value less than evalutation value" -ForegroundColor Gray
                            Write-Host "              - Waiting for 10 seconds before rechecking" -ForegroundColor Gray
                            Start-Sleep -Seconds 10
                        } until ($FileLastWriteTime -gt $EvalTimeDate)
                }
    
                Write-Host "              - File property value is greater than the evaluation time" -ForegroundColor Cyan
                Write-Host "              - File Property value = " $FileLastWriteTimeStr






        <# Execute the file/command
            Write-Host ""
            Write-Host "          Checking for the File and Executing"
            Write-Host "              - File to check for: " $FilePathToRun

            If (Invoke-Command -ComputerName $Computer -ScriptBlock {Test-Path -Path $using:FilePathToRun}) {
                Write-Host "File Found" -ForegroundColor Green
                #Invoke-Command -ComputerName $Computer -ScriptBlock {cmd.exe /c $FilePathToRun}
            }
            Else {
                Write-Host "File not found"
            }


        # Get members after script execution
            Write-Host ""
            $FinalMembership = Invoke-Command -ScriptBlock {Get-LocalGroupMember -Group $using:GroupName} -ComputerName $Computer
            Write-Host "          Membership After"

            ForEach ($Member in $FinalMembership) {
                If ($Member -like $NewMemberName) {
                    Write-Host "              -"$Member -ForegroundColor Cyan
                }
                Else {
                    Write-Host "              -"$Member -ForegroundColor Gray
                }
            }
        #>
    }
    