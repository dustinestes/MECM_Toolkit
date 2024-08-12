# Get Data
    $BoundaryGroups = Get-CMBoundaryGroup | Sort-Object -Property Name

# Output Boundary Group Names
    foreach ($Item in $BoundaryGroups) {
        Write-Host "$($Item.Name)"
    }

# Set Servers for All Boundary Groups
    foreach ($Item in $BoundaryGroups) {
        $ServersToAdd = "[servername].[domain].com","[servername].[domain].com"
        Write-Host "$($Item.Name)"

        foreach ($Item2 in $ServersToAdd) {
        $Temp_Server = Get-CMSiteSystemServer -SiteSystemServerName $Item2
            Set-CMBoundaryGroup -InputObject $Item -AddSiteSystemServer $Temp_Server
        }
    }