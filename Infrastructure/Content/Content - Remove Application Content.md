# MECM Toolkit - Application Management - Remove Content from Distribution Points and Groups

The following code snippets are for managing the content on Distribution Points and Groups.

&nbsp;

## Remove Specified App Content from All DPs and Groups

This snippet uses PowerShell cmdlet results to populate array objects for the DPs and Groups. It does not filter them so all objects returned are targeted. This is done so that the

- Dynamic, does not statically define DPs or Groups so any new additions will always be included
- Uses an application list input file that only requires a list of Software Names as they appear in the Console
- Outputs to both the console as well as a defined transcript file
- Has proper try/catch logic as well as logic to determine when the process was not necessary due to no content existing

&nbsp;

### Snippet

&nbsp;


```powershell
# Start Logging
    Start-Transcript -Path "C:\Users\destes-admin\Downloads\Content_Removal.log"

# Set Variables
    $Application_ListToRemove = "C:\Users\destes-admin\Downloads\Applications.txt"

    $DistributionPoints_Individual = @(
        (Get-CMDistributionPoint).NetworkOSPath -replace "\\",""
    )

    $DistributionPoints_Groups = @(
        (Get-CMDistributionPointGroup).Name
    )

# Write Header
    Write-Host "Removing Application Content"

# Get List of Application Names Exported from MECM Console
    Write-Host "  - Getting List of Applications"

    try {
        $Applications = Get-Content -Path $Application_ListToRemove
        Write-Host "      Success: Application list compiled"
    }
    catch {
        Write-Host "Error: Could not get list of applications"
        throw $_
    }

# Iterate Through Application Names
    foreach ($Application in $Applications) {
        # Perform Checks
            # Task Sequence Reference

            # Deployments

        # Remove Application
            try {
                Write-Host "  - $($Application)"
                Remove-CMContentDistribution -ApplicationName $Application -DisableContentDependencyDetection -DistributionPointGroupName $DistributionPoints_Groups -DistributionPointName $DistributionPoints_Individual -Force

                Write-Host "      Success: Content successfully removed"
            }
            catch [System.InvalidOperationException] {
                Write-Host "      Skipped: No Content found for the specified application"
            }
            catch {
                Write-Host "      Error: Could not remove content from DPs / DP Groups"
            }
    }

# End Logging
    Stop-Transcript
```
