<#
.SYNOPSIS
Uploads a file to Box from a local path or from memory.

.DESCRIPTION
Uploads a file to a specified Box folder. You can upload a file directly from a local path
or from an in-memory byte array, which is useful for generating files on the fly
without writing to disk.

.PARAMETER FilePath
(Local path upload) The path of the file on the local filesystem to upload.
Required when uploading from a file.

.PARAMETER FileBytes
(In-memory upload) The file content as a byte array. Required when uploading from memory.

.PARAMETER FileName
(In-memory upload) The name to give the file in Box. Required when using FileBytes.

.PARAMETER ParentFolderId
The Box folder ID where the file should be uploaded.

.EXAMPLE
# Upload a local file
Send-BoxFile -FilePath "C:\Temp\report.pdf" -ParentFolderId "123456"

.EXAMPLE
# Upload a CSV from memory
$csv = $data | ConvertTo-Csv -NoTypeInformation
$bytes = [System.Text.Encoding]::UTF8.GetBytes($csv -join "`n")
Send-BoxFile -FileBytes $bytes -FileName "report.csv" -ParentFolderId "123456"
#>

function Send-BoxFile {

    [CmdletBinding(DefaultParameterSetName = "FromPath")]
    param(
        # --- File Path Upload ---
        [Parameter(Mandatory, ParameterSetName = "FromPath")]
        [string]$FilePath,

        # --- In-Memory Upload ---
        [Parameter(Mandatory, ParameterSetName = "FromMemory")]
        [byte[]]$FileBytes,

        [Parameter(Mandatory, ParameterSetName = "FromMemory")]
        [string]$FileName,

        # --- Shared ---
        [Parameter(Mandatory)]
        [string]$ParentFolderId
    )

    switch ($PSCmdlet.ParameterSetName) {

        "FromPath" {
            if (-not (Test-Path -Path $FilePath -PathType Leaf)) {
                throw "File not found at path: $FilePath"
            }

            $FileBytes = [System.IO.File]::ReadAllBytes($FilePath)
            $FileName  = [System.IO.Path]::GetFileName($FilePath)
        }

        "FromMemory" {
        }
    }

    $Attributes = @{
        name   = $FileName
        parent = @{
            id = $ParentFolderId
        }
    } | ConvertTo-Json -Compress

    # --- Build multipart form body ---
    $boundary = [System.Guid]::NewGuid().ToString()
    $LF = "`r`n"

    $memStream = New-Object System.IO.MemoryStream
    $writer    = New-Object System.IO.StreamWriter($memStream)

    # --- attributes part ---
    $writer.Write("--$boundary$LF")
    $writer.Write("Content-Disposition: form-data; name=`"attributes`"$LF")
    $writer.Write("Content-Type: application/json$LF$LF")
    $writer.Write($Attributes + $LF)

    # --- file part ---
    $writer.Write("--$boundary$LF")
    $writer.Write("Content-Disposition: form-data; name=`"file`"; filename=`"$FileName`"$LF")
    $writer.Write("Content-Type: application/octet-stream$LF$LF")
    $writer.Flush()

    # Write raw file bytes
    $memStream.Write($FileBytes, 0, $FileBytes.Length)

    # --- closing boundary ---
    $writer.Write("$LF--$boundary--$LF")
    $writer.Flush()

    $bodyBytes = $memStream.ToArray()
    $memStream.Close()

    # --- Invoke API ---
    $IVRSplat = @{
        Uri     = "$($Script:Settings.UploadBaseURI)files/content"
        Method  = "POST"
        Headers = @{
            Authorization = "Bearer $($Script:BoxSession.AccessToken)"
            "Content-Type" = "multipart/form-data; boundary=$boundary"
        }
        Body = $bodyBytes
    }

    Invoke-RestMethod @IVRSplat
}
