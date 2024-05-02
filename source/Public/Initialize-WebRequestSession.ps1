<#
.SYNOPSIS
    Initializes and returns a web request session object with custom headers and credentials.

.DESCRIPTION
    The Initialize-WebRequestSession function creates a new web request session, configuring it with optional headers,
    credentials, and a cookie container to manage cookies across requests. This session can be used with various
    cmdlets that require a WebRequestSession parameter.

.PARAMETER Headers
    A hashtable containing headers to be added to the web request session. Default is an empty hashtable.

.PARAMETER Credentials
    A PSCredential object containing user credentials for the web request session.

.EXAMPLE
    $headers = @{ "Authorization" = "Bearer token" }
    $creds = Get-Credential
    $session = Initialize-WebRequestSession -Headers $headers -Credentials $creds
    Invoke-WebRequest -Uri "https://example.com" -WebSession $session

.OUTPUTS
    Microsoft.PowerShell.Commands.WebRequestSession
    Returns a WebRequestSession object configured with headers, credentials, and cookie management.
#>
function Initialize-WebRequestSession
{
    [CmdletBinding()]
    param(
        [Parameter()]
        [hashtable]$Headers = @{},

        [Parameter()]
        [PSCredential]$Credentials
    )

    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    foreach ($key in $Headers.Keys)
    {
        $session.Headers.Add($key, $Headers[$key])
        Write-Verbose "Added header: $key with value: $($Headers[$key])"
    }

    if ($Credentials)
    {
        $session.Credentials = $Credentials
        Write-Verbose "Credentials set for the session."
    }

    $session.Cookies = New-Object System.Net.CookieContainer
    Write-Verbose "Cookie container initialized."

    # [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 | [Net.SecurityProtocolType]::Tls11 | [Net.SecurityProtocolType]::Tls
    Write-Verbose "Web request session object created."

    return $session
}
