<#
.SYNOPSIS
Sets the current API session with new parameters.

.DESCRIPTION
The Set-CurrentApiSession function updates the global API session object with new parameters such as ApiKey, Credentials, CustomHeaders, or a new WebRequestSession. It allows for dynamic updates to the session's authentication method, custom headers, or the entire web request session object.

.PARAMETER ApiKey
The API key for Bearer authentication. This parameter is optional.

.PARAMETER Credentials
The user credentials for Basic authentication. This parameter is optional.

.PARAMETER CustomHeaders
A hashtable of custom headers to be added to the web request session. This parameter is optional.

.PARAMETER NewSession
A new web request session object to replace the current session. This parameter is optional.

.EXAMPLE
Set-CurrentApiSession -ApiKey 'your_api_key_here'

This example demonstrates how to update the API session with a new API key for Bearer authentication.

.EXAMPLE
$creds = Get-Credential
Set-CurrentApiSession -Credentials $creds

This example demonstrates how to update the API session with new user credentials for Basic authentication.

.EXAMPLE
$customHeaders = @{ "Custom-Header" = "Value" }
Set-CurrentApiSession -CustomHeaders $customHeaders

This example demonstrates how to add custom headers to the current API session.

.EXAMPLE
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
Set-CurrentApiSession -NewSession $session

This example demonstrates how to replace the current web request session with a new session object.

.NOTES
This function is part of a PowerShell module designed to simplify interactions with RESTful APIs by managing session state, including authentication, custom headers, and web request sessions.

.LINK
- Initialize-WebRequestSession - For initializing a new web request session.
- New-ApiSession - For creating a new API session object.
#>

function Set-CurrentApiSession {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$ApiKey,

        [Parameter(Mandatory = $false)]
        [PSCredential]$Credentials,

        [Parameter(Mandatory = $false)]
        [hashtable]$CustomHeaders = @{},

        [Parameter(Mandatory = $false)]
        [Microsoft.PowerShell.Commands.WebRequestSession]$NewSession
    )

    # Check if a new session object is provided
    if ($NewSession) {
        $script:apiSession.WebSession = $NewSession
        $script:apiSession.AuthHeaders = @{Authorization = $NewSession.Headers.Authorization }

        Write-Verbose "New web request session set."
    }

    # Check if the apiSession is already initialized
    if (-not $script:apiSession) {
        Write-Error "API session is not initialized. Please initialize the session before setting it."
        return
    }

    # Update the Authorization header if an ApiKey or Credentials are provided
    if ($ApiKey) {
        $script:apiSession.WebSession.Headers["Authorization"] = "Bearer $ApiKey"
    }
    elseif ($Credentials) {
        $base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($Credentials.UserName) + ':' + ($Credentials.GetNetworkCredential().Password)))
        $script:apiSession.WebSession.Headers["Authorization"] = "Basic $base64Auth"
    }

    if($CustomHeaders){# Add or update custom headers in the WebRequestSession
        foreach ($key in $CustomHeaders.Keys) {
            $script:apiSession.AuthHeaders[$key] = $CustomHeaders[$key]
        }
    }

    if($NewSession -and $customHeaders){# Add or update custom headers in the WebRequestSession
        foreach ($key in $CustomHeaders.Keys) {
            $script:apiSession.WebSession.Headers[$key] = $CustomHeaders[$key]
        }
    }

    Write-Verbose "API session updated successfully."
}
