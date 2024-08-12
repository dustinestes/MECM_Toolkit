#--------------------------------------------------------------------------------------------
# Parameters
#--------------------------------------------------------------------------------------------

# param (
#     [string]$ParameterName
# )

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Write Output Header Info to SMSTS.log
#--------------------------------------------------------------------------------------------
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  Task Sequence Toolkit - Certificate - Enroll in Certificate"
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "    Author:    Dustin Estes"
    Write-Host "    Company:   VividRock"
    Write-Host "    Date:      December 23, 2019"
    Write-Host "    Copyright: VividRock LLC - All Rights Reserved"
    Write-Host "    Purpose:   This script will attempt to enroll in the specified certificate"
    Write-Host "               template using the server specified."
    Write-Host "------------------------------------------------------------------------------"
    Write-Host ""
#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Set Variables
#--------------------------------------------------------------------------------------------
    # Create Com Object
        $MECMObject = New-Object -ComObject "UIResource.UIResourceMgr"

    # Set Variables
        $ElementCounter_Success = 0
        $ElementCounter_Error = 0
        $ElementCounter_Total = $MECMObject.GetCacheInfo().GetCacheElements().Count

#--------------------------------------------------------------------------------------------


#--------------------------------------------------------------------------------------------
# Main Execution
#--------------------------------------------------------------------------------------------
    # Get Cache Elements
        Write-Host "      - Get Cache Elements"

        try {
            $MECMCache_Elements = $MECMObject.GetCacheInfo().GetCacheElements()

            Write-Host "          Count: $($MECMCache_Elements.Count)"
        }
        catch {
            Write-Host "          Error: Failed to Get Cache Elements"
            Write-Host "          Command Name: "$Error[0].Exception.CommandName
            Write-Host "          Message: "$Error[0].Exception.Message
            Exit 1401
        }

    # Delete Cache Elements
        Write-Host "      - Delete Cache Elements"
        
        try {
            foreach ($Item in $MECMCache_Elements) {
                Write-Host "          Content ID: $($Item.ContentId)"
                Write-Host "          Version: $($Item.ContentVersion)"
                Write-Host "          Location: $($Item.Location)"
                Write-Host "          Last Reference Time: $($Item.LastReferenceTime)"
                Write-Host "          Size: $([math]::Round($Item.ContentSize / 1kb, 2)) MB"

                $MECMObject.GetCacheInfo().DeleteCacheElement([string]$($Item.CacheElementID))

                Write-Host "          Status: Delete Attempted"
                Write-Host ""
            }
        }
        catch {
            $ElementCounter_Error ++
            Write-Host "          Error: Failed to Delete Cache Element"
            Write-Host "          Command Name: "$Error[0].Exception.CommandName
            Write-Host "          Message: "$Error[0].Exception.Message
            # Exit 1402
        }

    # Output Status
        Write-Host "      - Output Status"
        
        try {
            $MECMCache_Elements_Validate = $MECMObject.GetCacheInfo().GetCacheElements()

            Write-Host "          Count: $($MECMCache_Elements_Validate.Count)"

            if ($MECMCache_Elements_Validate.Count -ne 0) {
                Write-Host "          Status: Error. Some Elements Not Deleted"
            }
            else {
                Write-Host "          Status: Success"
            }
        }
        catch {
            Write-Host "          Error: Failed to Output Status"
            Write-Host "          Command Name: "$Error[0].Exception.CommandName
            Write-Host "          Message: "$Error[0].Exception.Message
            Exit 1401
        }

#--------------------------------------------------------------------------------------------
# End of Script
#--------------------------------------------------------------------------------------------
    Write-Host ""
    Write-Host "------------------------------------------------------------------------------"
    Write-Host "  End of Script"
    Write-Host "------------------------------------------------------------------------------"

#--------------------------------------------------------------------------------------------