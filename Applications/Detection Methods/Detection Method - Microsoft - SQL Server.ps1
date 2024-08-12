<#--------------------------------------------------------------------------------------------------------------------
    MECM Detection Method: Microsoft SQL Server
----------------------------------------------------------------------------------------------------------------------
    Author:  Dustin Estes
    Date:    September 14th, 2020

    This script will attempt to detect the version and edition of the SQL server software for each instance found.
    The logic will then determine if SQL Server is installed using the following logic:
        - Is "Detected Edition" value "equal to" the "Expected Edition" value provided below?
        AND
        - Is the "Detected Version" value "greater than or equal to" the "Expected Version" value provided below?

    The script then uses the following "Exit" logic to provide MECM with the output needed to state True or False
        Exit 0 = Expected Values detected
        Exit 1 = Expected Values not detected

----------------------------------------------------------------------------------------------------------------------#>
# Provide the Expected values for the Detection check
    $ExpectedEdition = "Enterprise Edition"
    $ExpectedVersion = "15.0.2000.5"

# Get all instances of SQL Server
    $instances = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances

# Process each instance found in the array
    foreach ($i in $instances) {
        $p = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$i
        $DetectedEdition = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Edition
        $DetectedVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Version

        If (($DetectedEdition -eq $ExpectedEdition) -and ([version]::Parse($DetectedVersion) -ge [version]::Parse($ExpectedVersion)) ){
            #write-host "Detected Edition = $DetectedEdition" -ForegroundColor Yellow
            #write-host "Detected Version = $DetectedVersion" -ForegroundColor Yellow
            write-host "Expected values found. SQL Server is installed." -ForegroundColor Green
            Exit 0
        }
        Else {

        }
}

