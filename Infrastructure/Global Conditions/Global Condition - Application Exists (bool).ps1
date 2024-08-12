<# -----------------------------------------------------------------------------------------------------------------------------
    Global Condition Logic - Application Existential (bool)
--------------------------------------------------------------------------------------------------------------------------------

    Author:         Dustin Estes
    Created:        2017-03-13
    Copyright:      VividRock LLC | All Rights Reserved
    Website:	    https://www.vividrock.com
    Version:        1.6

    Purpose: Used to detect an applications installation based on registry values found and return a boolean value.

    Function: 
        1. 	Searches the specified registry locations in the hash table to populate a list of keys 
        2. 	Checks the property values of each key returned to see if both the Publisher and DisplayName are like the values specified 

----------------------------------------------------------------------------------------------------------------------------- #>

    # Specify the Detection Variables
    #   Wildcards Supported: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about-wildcards?view=powershell-7.2
        $AppPublisher = "Adobe Systems Incorporated"
        $AppDisplayName = "Adobe Acrobat Reader*"

    # Registry Locations: 32-bit, 64-bit, and Current User Installation 
        $RegistryLocations = @( 
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", 
            "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" 
        )

<# -----------------------------------------------------------------------------------------------------------------------------
    Do Not Edit Below This Line
----------------------------------------------------------------------------------------------------------------------------- #>
    # Set Default Value Before Processing
        $OverallDetection = $false

    # Perform the Detection
        foreach ($RegistryLocation in $RegistryLocations) {

        # Ensure Registry Key Exists Before Continuing
            if ((Test-Path -Path $RegistryLocation) -eq $true) {
                $Keys = Get-Childitem $RegistryLocation

                foreach ($Key in $Keys) {
                    # Find and Match Publisher & DisplayName 
                        if (($Key.GetValue("Publisher") -like $AppPublisher) -and ($Key.GetValue("DisplayName") -like $AppDisplayName)) {
                            $OverallDetection = $true
                        }
                }
            }
        }

<# -----------------------------------------------------------------------------------------------------------------------------
    Add Sub-detection Logic Modules Below This Line (If Needed)
----------------------------------------------------------------------------------------------------------------------------- #>










<# -----------------------------------------------------------------------------------------------------------------------------
    Detection Results
--------------------------------------------------------------------------------------------------------------------------------
    Final detection results based on the return and logic of the install main module and the sub-detection logic modules
----------------------------------------------------------------------------------------------------------------------------- #>
    # Return Output
        if ($OverallDetection -eq $true) {
            Return $true
        }
        elseif ($OverallDetection -eq $false) {
            Return $false
        }
