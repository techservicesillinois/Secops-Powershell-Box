<#
.SYNOPSIS
Retrieves Box folder metadata.

.DESCRIPTION
Gets metadata information for a specified Box folder.

.PARAMETER FolderId
The ID of the Box folder.

.EXAMPLE
Get-BoxFolder -FolderId "123456789"
#>

function Get-BoxFolderData {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FolderId
    )

    $Call = @{
        RelativeURI = "folders/$FolderId"
        Method      = "GET"
    }

    Invoke-BoxRestCall @Call
}