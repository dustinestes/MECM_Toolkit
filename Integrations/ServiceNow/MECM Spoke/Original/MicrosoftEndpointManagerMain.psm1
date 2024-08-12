<# 
 .Synopsis
 Microsoft Endpoint Manager Module

 .Description
  Contains common PowerShell functions for Microsoft Endpoint Manager support

 Requires -Version 3.0
#>

<# 
 .Synopsis
  Create Microsoft Endpoint Manager session.

 .Description
  Returns the created PowerShell session object to be used.

 .Parameter Microsoft Endpoint Manager Server Name
  The hostname of the Microsoft Endpoint Manager server.

 .Parameter credential
  The credential object used to access the server.

 .Example
   # Create a powershell session.
   Create-PSSession -sccmServerName $theServer -credential $userCredential;

 Requires -Version 3.0
#>
function Create-PSSession {
	param(
		[Parameter(Mandatory=$true)] [string]$sccmServerName,
		[Parameter(Mandatory=$true)] $credential
	);

        SNCLog-ParameterInfo @("Running Create-PSSession", $sccmServerName, $credential)

        $session = New-PSSession -ComputerName $sccmServerName -ConfigurationName Microsoft.PowerShell32 -Credential $credential;

	# Return the created session
	$session;
}