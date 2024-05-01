<#
.SYNOPSIS
Initializes a web request session with custom headers and user agent.

.DESCRIPTION
The Initialize-WebRequestSession function creates a new web request session object, sets a default user agent, applies any custom headers provided, and optionally sets credentials for authentication. It also initializes a cookie container for the session to manage cookies across requests.

.PARAMETER CustomHeaders
A hashtable of custom headers to be added to the web request session. Default is an empty hashtable.

.PARAMETER UserAgent
The user agent string to be used for the web request session. Default is "PowerShell API Client".

.PARAMETER Credentials
Optional credentials (PSCredential object) for authentication with the web request session.

.EXAMPLE
$customHeaders = @{ "Authorization" = "Bearer token" }
$session = Initialize-WebRequestSession -CustomHeaders $customHeaders

This example initializes a web request session with a custom Authorization header.

.EXAMPLE
$creds = Get-Credential
$session = Initialize-WebRequestSession -Credentials $creds

This example initializes a web request session with credentials for authentication.

.NOTES
This function is useful for setting up a web request session with specific requirements, such as custom headers or authentication, before making web requests.

.LINK
https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/new-object
#>

function Initialize-WebRequestSession {
    [CmdletBinding()]
    param(
        [hashtable]$CustomHeaders = @{},
        [string]$UserAgent = "PowerShell API Client",
        [PSCredential]$credentials
    )

    # Create a new web request session object
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    # Set the default user agent and any custom headers provided
    $session.Headers.Add("User-Agent", $UserAgent)
    foreach ($key in $CustomHeaders.Keys) {
        $session.Headers.Add($key, $CustomHeaders[$key])
    }

    if ($credentials) { $session.Credentials = $credentials }

    # Initialize a new cookie container to manage cookies across requests
    $session.Cookies = New-Object System.Net.CookieContainer

    # Optionally, specify security protocols (uncomment if needed)
    # [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 | [Net.SecurityProtocolType]::Tls11 | [Net.SecurityProtocolType]::Tls

    # Return the configured session
    return $session
}
