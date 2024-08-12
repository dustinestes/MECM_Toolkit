$Exclusion = Get-CMCollection -CollectionType Device -Name "LIE - # Troubleshooting - Exclude - Software Updates - All"
$Collections = Get-CMCollection -CollectionType Device -Name "SU - Workstations - Windows 7 - Wave *"

foreach ($Item in $Collections) {
    Add-CMDeviceCollectionExcludeMembershipRule -CollectionId $Item.CollectionID -ExcludeCollectionId $Exclusion.CollectionID
}






# ----------------------------------------------------------------------

$CollectionName = "Cisco Call Center Project - ZOOM Client & Codec"
$Computers = get-content $input_path

Write-Host "---------------------------------------------------------------"
Write-Host "  SCCM - Add Machines to Collection "
Write-Host "---------------------------------------------------------------"
Write-Host " "
Write-Host "  Collection: " $CollectionName
Write-Host " "

Foreach ($Computer in $Computers)
    {
        Write-Host "    $Computer"
        add-cmdevicecollectiondirectmembershiprule -collectionname $CollectionName -resourceid (Get-CMDevice -name $Computer).ResourceID
    }
