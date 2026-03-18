<#
.SYNOPSIS
Makes a REST API call to the Box API.

.DESCRIPTION
Wrapper for Invoke-RestMethod that handles authentication,
headers, retries, and base URI handling for the Box API.

.PARAMETER RelativeURI
Relative URI of the Box endpoint.
Example: "folders/123456"

.PARAMETER Method
HTTP method (GET, POST, PUT, DELETE)

.PARAMETER Body
Hashtable body that will be converted to JSON.

.PARAMETER Upload
Switch indicating the upload API endpoint should be used.

.EXAMPLE
Invoke-BoxRestCall -RelativeURI "folders/123" -Method GET

.EXAMPLE
Invoke-BoxRestCall -RelativeURI "folders" -Method POST -Body $Body
#>

function Invoke-BoxRestCall {

    [CmdletBinding(DefaultParameterSetName='Body')]
    param (
        [Parameter(Mandatory)]
        [string]$RelativeURI,

        [Parameter(Mandatory)]
        [string]$Method,

        [hashtable]$Body,

        [switch]$Upload
    )

    begin {

        if ($null -eq $Script:BoxSession) {
            throw "No Box session established. Run New-BoxSession first."
        }

        if ($RelativeURI.StartsWith('/')) {
            $RelativeURI = $RelativeURI.Substring(1)
        }

        if ($Upload) {
            $BaseURI = "https://upload.box.com/api/2.0/"
        }
        else {
            $BaseURI = "https://api.box.com/2.0/"
        }
    }

    process {

        $IVRSplat = @{
            Headers = @{
                Authorization = "Bearer $($Script:BoxSession.AccessToken)"
                "Content-Type" = "application/json"
            }
            Method = $Method
            Uri = "$BaseURI$RelativeURI"
        }

        if ($Body) {
            $IVRSplat.Add("Body", ($Body | ConvertTo-Json -Depth 10))
        }

        Write-Verbose "Calling Box API: $Method $RelativeURI"

        try {

            $Result = Invoke-RestMethod @IVRSplat
            $Script:APICallCount++

            return $Result
        }
        catch {

            Write-Verbose "Box API call failed, retrying in 3 seconds..."
            Start-Sleep -Seconds 3

            $Result = Invoke-RestMethod @IVRSplat
            $Script:APICallCount++

            return $Result
        }
    }
}
