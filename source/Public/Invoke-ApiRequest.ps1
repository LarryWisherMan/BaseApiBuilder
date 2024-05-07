<#
.SYNOPSIS
    Invokes an API request to a specified endpoint.

.DESCRIPTION
    The Invoke-ApiRequest function sends an HTTP request to the specified API endpoint. It can handle various HTTP methods and allows for additional query parameters and request body content.

.PARAMETER UriPrefix
    The base URI prefix for the API endpoint.

.PARAMETER Endpoint
    The specific API endpoint to which the request will be sent.

.PARAMETER QueryParams
    A hashtable of query parameters to be appended to the endpoint. Default is an empty hashtable.

.PARAMETER Method
    The HTTP method to be used for the request. Default is "Get".

.PARAMETER Body
    The content body of the request, used with methods like POST or PUT.

.EXAMPLE
    $response = Invoke-ApiRequest -UriPrefix "https://api.example.com" -Endpoint "data" -Method "Get"

    This example sends a GET request to https://api.example.com/data.

.EXAMPLE
    $body = @{name="John"; age=30} | ConvertTo-Json
    $response = Invoke-ApiRequest -UriPrefix "https://api.example.com" -Endpoint "users" -Method "Post" -Body $body

    This example sends a POST request to https://api.example.com/users with a JSON body containing name and age.

.OUTPUTS
    Object
    Returns the response from the API request.

.NOTES
    Ensure that the API endpoint and UriPrefix are correctly configured within the function.

.LINK
    For more information on HTTP methods: https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
#>

function Invoke-ApiRequest {
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$UriPrefix,

        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter()]
        [hashtable]$QueryParams = @{},

        [Parameter()]
        [string]$Method = "Get",

        [Parameter()]
        [string]$Body
    )

    $BaseURI = Get-BaseUri
    $CombinedUri = Join-Path $UriPrefix $Endpoint
    $Uri = New-ApiUri -BaseUri $BaseURI -Endpoint $CombinedUri -QueryParams $QueryParams

    $webSession = Get-ApiWebSession

    # Prepare the parameters hashtable for Invoke-RestMethod
    $restParams = @{
        Uri         = $Uri
        Method      = $Method
        WebSession  = $webSession
    }

    # Conditionally add the Body parameter if it's provided
    if ($Body) {
        $restParams['Body'] = $Body
    }

    # Execute the API request
    $response = Invoke-RestMethod @restParams
    return $response
}
