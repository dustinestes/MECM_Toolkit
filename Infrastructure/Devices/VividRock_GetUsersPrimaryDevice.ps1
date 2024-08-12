Clear-Host
Import-Module 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'
CD PRD:

$script_parent = Split-Path -Parent $MyInvocation.MyCommand.Definition
$input_path    = $script_parent + "\VividRock_GetUsersPrimaryDevice.txt"

$Users = get-content $input_path

Write-Host "User `t Computer"
Foreach ($User in $Users) 
{
$Username = "univ-wea.com\" + $User + "*"
$UserResourceID = (Get-CMUser -Name $Username).ResourceID
$ComputerResourceIDs = (Get-CMUserDeviceAffinity -UserId $UserResourceID).ResourceID

    Foreach ($ComputerResourceID in $ComputerResourceIDs)
    {
        $ComputerName = (Get-CMDevice -id $ComputerResourceID).Name
        Write-Host "$User `t $ComputerName"
    }
}