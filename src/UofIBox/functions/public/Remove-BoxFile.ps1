<#
.SYNOPSIS
Deletes a Box file.

.DESCRIPTION
Removes a file from Box permanently.

.PARAMETER FileId
The ID of the file to delete.

.EXAMPLE
Remove-BoxFile -FileId "123456789"
#>

function Remove-BoxFile {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FileId
    )

    $Call = @{
        RelativeURI = "files/$FileId"
        Method      = "DELETE"
    }

    Invoke-BoxRestCall @Call
}