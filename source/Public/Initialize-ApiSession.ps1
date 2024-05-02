<#
.SYNOPSIS
    Initializes an API session by setting up web request headers, a user agent, and an optional base URI.

.DESCRIPTION
    The Initialize-ApiSession function sets up a session for interacting with APIs. It combines authentication and custom headers,
    sets a user agent, optionally configures a base URI, and initializes a web request session. It closes any existing API session
    before setting up a new one.

.PARAMETER BaseURI
    The base URI for the API. This is not mandatory but recommended if all requests will use the same base URI.

.PARAMETER AuthHeaders
    A hashtable of authentication headers. Default is an empty hashtable.

.PARAMETER CustomHeaders
    A hashtable of custom headers to be used in the API session. Default is an empty hashtable.

.PARAMETER UserAgent
    The user agent string to be used in the session. Defaults to "PowerShell API Client".

.PARAMETER WebSession
    An existing WebRequestSession object that can be reused. If not provided, a new session will be created.

.EXAMPLE
    $authHeaders = @{ "Authorization" = "Bearer your_token" }
    $session = Initialize-ApiSession -BaseURI "https://api.example.com" -AuthHeaders $authHeaders

.OUTPUTS
    Hashtable
    Returns a hashtable containing session details including time, base URI, authentication headers, and the web request session.
#>
function Initialize-ApiSession
{
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $false)]
        [string]$BaseURI,

        [Parameter()]
        [Hashtable]$AuthHeaders = @{},

        [Parameter()]
        [Hashtable]$CustomHeaders = @{},

        [Parameter()]
        [string]$UserAgent = "PowerShell API Client",

        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession
    )

    Close-ApiSession

    $CombinedHeaders = $AuthHeaders + $CustomHeaders
    if ($UserAgent)
    {
        $CombinedHeaders["User-Agent"] = $UserAgent
    }

    if ($BaseURI)
    {
        #Set-BaseUri -Uri $BaseURI
    }

    if (-not $WebSession)
    {
        $WebSession = Initialize-WebRequestSession -Headers $CombinedHeaders
    }

    $hash = @{
        Time        = (Get-Date)
        BaseUri     = $BaseURI
        AuthHeaders = $AuthHeaders
        WebSession  = $WebSession
    }

    Set-CurrentApiSession -SessionHash $hash
    Write-Verbose "API session initialized successfully."

    return (Get-CurrentApiSession)
}
