#########################################################################
# AUTHOR  : Dustin Estes - http://www.dustinestes.com
# DATE    : Mar. 10, 20134
# COMMENT : This script creates deployments for applications 
#           in SCCM and assigns them to one single Collection.
#########################################################################
 
#-------------------------------------------#
# ERROR REPORTING ALL
#-------------------------------------------#
	Set-StrictMode -Version latest 

#-------------------------------------------#
# Global Variables
#-------------------------------------------#
	$script_parent = Split-Path -Parent $MyInvocation.MyCommand.Definition 
	$csv_path      = $script_parent + "\create_deployments.input" 
	$sitecode      = (Get-CMSite).SiteCode
    $count		   = 0
	$ApplicationArray = Get-WMIObject -class SMS_Application -namespace "root\SMS\site_SP1" | Where {$_.IsLatest -eq "True"}
    
#-------------------------------------------#
# Begin Deployment Processing
#-------------------------------------------#
ForEach ($Application In $ApplicationArray)
{
    Write-Host "`r"
    $count++
	#-------------------------------------------#
	# Variables Based on Loop Item
	#-------------------------------------------#
		$SCCMDate1 = get-date -format yyyyMMddHHmmss
		$SCCMDate2 = $SCCMDate1 + “.000000+***”
		$Collection = get-wmiobject -class SMS_Collection -namespace "root\SMS\site_SP1" | Where {$_.Name -eq "Application Catalogue - All Software"}
		$AssignmentName = ($Application.LocalizedDisplayName + "_" + $Collection.Name + "_" + "Install")
		$RequireApproval = $true
		
		Write-Host "---------------------- Create Deployment #$count ----------------------"
		Write-Host "Application Name:     " $Application.LocalizedDisplayName
		Write-Host "Collection Name:      " $Collection.Name
		Write-Host "Target Collection ID: " $Collection.CollectionID
		Write-Host "Assignment Name:      " $AssignmentName
		Write-Host "-----------------------------------------------------------------------"

	#-------------------------------------------#
	# Create Deployment
	#-------------------------------------------#
		$newApplicationAssignmentClass = [wmiclass] "root\SMS\Site_$($sitecode):SMS_ApplicationAssignment"
			$newApplicationAssignment = $newApplicationAssignmentClass.CreateInstance()
			$newApplicationAssignment.ApplicationName 					=	$Application.LocalizedDisplayName
			$newApplicationAssignment.AssignmentName 					=	$AssignmentName
			$newApplicationAssignment.AssignedCIs                 		=	$Application.CI_ID
			$newApplicationAssignment.CollectionName                	=	$Collection.Name
			$newApplicationAssignment.CreationTime                  	=	$SCCMDate2
            $newApplicationAssignment.DesiredConfigType                 =	1
			$newApplicationAssignment.LocaleID                      	=	1033
			$newApplicationAssignment.NotifyUser                    	= 	$true
            $newApplicationAssignment.RequireApproval                  	= 	$RequireApproval
            $newApplicationAssignment.SourceSite                    	=	$Sitecode
			$newApplicationAssignment.StartTime                     	=	$SCCMDate2
			$newApplicationAssignment.SuppressReboot                	= 	$false
			$newApplicationAssignment.TargetCollectionID            	= 	$Collection.CollectionID											
			$newApplicationAssignment.OfferTypeID						= 	2
			$newApplicationAssignment.WoLEnabled  					 	=	$false
            $newApplicationAssignment.PersistOnWriteFilterDevices	 	=	$true
			$newApplicationAssignment.RebootOutsideOfServiceWindows 	=	$false
			$newApplicationAssignment.OverrideServiceWindows  		 	=	$false
			$newApplicationAssignment.UseGMTTimes 					 	=	$true
			[void] $newApplicationAssignment.Put()

	Write-Host "`r"
}