<#
.SYNOPSIS
Retrieves the authentication headers for the current API session.

.DESCRIPTION
The Get-AuthHeaders function returns the authentication headers stored in a script-scoped variable. These headers are used for making authenticated requests to the API. If the authentication headers are not set, the function will throw an error instructing to initialize an authentication session.

.EXAMPLE
$headers = Get-AuthHeaders

This example demonstrates how to retrieve the authentication headers for the current API session.

.NOTES
This function is part of the BaseApiBuilder module which provides a set of tools for interacting with RESTful APIs. It requires an active authentication session initialized by calling Initialize-AuthSession.

.LINK
Initialize-AuthSession - For initializing the authentication session.
Close-ApiSession - For closing the current API session.

#>

function Get-AuthHeaders {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns','')]
    [CmdletBinding()]
    param()
    if ($null -eq $script:apiSession.AuthHeaders) {
        Write-Error "Authentication is required. Please call Initialize-AuthSession."
        exit
    }
    return $script:apiSession.AuthHeaders
}
