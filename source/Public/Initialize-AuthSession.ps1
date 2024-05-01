<#
.SYNOPSIS
Initializes an authentication session for API calls.

.DESCRIPTION
The Initialize-AuthSession function is designed to create an authentication session using either an API key or user credentials. It returns a hashtable with the necessary authorization headers for making authenticated API requests. If an API key is provided, it uses Bearer authentication; otherwise, it uses Basic authentication with the provided credentials.

.PARAMETER ApiKey
The API key for Bearer authentication. This parameter is optional and mutually exclusive with the Credentials parameter.

.PARAMETER Credentials
The user credentials for Basic authentication. This parameter is optional and mutually exclusive with the ApiKey parameter.

.EXAMPLE
$authSession = Initialize-AuthSession -ApiKey 'your_api_key_here'
This example demonstrates how to initialize an authentication session using an API key.

.EXAMPLE
$creds = Get-Credential
$authSession = Initialize-AuthSession -Credentials $creds
This example demonstrates how to initialize an authentication session using user credentials.

.NOTES
This function requires either an ApiKey or Credentials parameter to be provided. If neither or both are provided, it will result in an error.

.LINK
Get-AuthHeaders - For retrieving authentication headers for the current session.
#>

function Initialize-AuthSession {
    param(
        [string]$ApiKey = $null,
        [PSCredential]$Credentials = $null
    )

    if ($ApiKey) {
        $authSession = @{ Authorization = "Bearer $ApiKey" }
        return $authSession
    }
    elseif ($Credentials) {
        if ($network) { $Pass = $($Credentials.GetNetworkCredential().Password) }
        else { $Pass = (ConvertTo-PlainText -Credential $Credentials) }
        $authSession = @{ Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($Credentials.UserName):$($Pass)")) }
        return $authSession
    }
    else {
        Write-Error "No valid authentication method provided."
    }
}
