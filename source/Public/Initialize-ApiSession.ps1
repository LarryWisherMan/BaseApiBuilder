<#
.SYNOPSIS
Initializes an API session with given credentials.

.DESCRIPTION
The Initialize-ApiSession function is designed to authenticate and establish a session for API calls. It takes a PSCredential object as input, which should contain the API credentials. The function attempts to initialize an authentication session and set up a web request session with custom headers, including handling for the 'Accept' header to ensure it defaults to 'application/json'. If successful, it sets the current API session for subsequent API calls.

.PARAMETER APICreds
The credentials required to authenticate with the API. This should be a PSCredential object containing the API's username and password.

.EXAMPLE
$creds = Get-Credential
Initialize-ApiSession -APICreds $creds

This example demonstrates how to prompt the user for credentials and then use those credentials to initialize an API session.

.NOTES
This function is part of a module designed to facilitate interaction with RESTful APIs by managing sessions, authentication, and request headers.

.LINK
- Get-CurrentApiSession - Retrieves the current API session.
- Close-ApiSession - Closes the current API session and clears any stored session information.

#>

function Initialize-ApiSession {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory = $false)]
        [PSCredential]$APICreds
    )

    if ($APICreds) {

        # Initialize the authentication session and retrieve headers
        $CustomHeaders = Initialize-AuthSession -Credentials $APICreds
        if ($null -eq $CustomHeaders) {
            Write-Error "Failed to initialize authentication session."
            return $false
        }

        # Add default Accept header if not already present
        if (-not $CustomHeaders.ContainsKey("accept")) {
            $CustomHeaders["accept"] = "application/json"
        }

        # Initialize the WebRequestSession with custom headers
        $Session = Initialize-WebRequestSession -CustomHeaders $CustomHeaders
        if ($null -eq $Session) {
            Write-Error "Failed to initialize web request session."
            return $false
        }

        # Set the current API session using the newly created session
        Set-CurrentApiSession -NewSession $Session

        Write-Verbose "API session initialized successfully."
        return $true
    }

    else { return $false }
}
