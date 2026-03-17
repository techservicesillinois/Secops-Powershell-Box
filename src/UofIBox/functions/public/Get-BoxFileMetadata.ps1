<#
.SYNOPSIS
Retrieves metadata for a Box file.

.DESCRIPTION
Returns file information including size, name, and owner.

.PARAMETER FileId
The ID of the Box file.

.EXAMPLE
Get-BoxFile -FileId "123456789"
#>

function Get-BoxFileMetadata {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FileId
    )

    $Call = @{
        RelativeURI = "files/$FileId"
        Method      = "GET"
    }

    Invoke-BoxRestCall @Call
}