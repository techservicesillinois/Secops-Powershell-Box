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

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$FileId
    )

    if ($PSCmdlet.ShouldProcess("File $FileId", "Delete")) {
        $Call = @{
            RelativeURI = "files/$FileId"
            Method      = "DELETE"
        }
    Invoke-BoxRestCall @Call
    }
}