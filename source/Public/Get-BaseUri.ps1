<#
.SYNOPSIS
Retrieves the base URI for the current API session.

.DESCRIPTION
The Get-BaseUri function returns the base URI stored in a script-scoped variable if it has been set. If the base URI is not set, it throws an error instructing the user to initialize it using Set-BaseUri.

.EXAMPLE
$baseUri = Get-BaseUri

This example demonstrates how to retrieve the base URI for the current API session.

.NOTES
This function is part of the BaseApiBuilder module which provides a set of tools for interacting with RESTful APIs. It requires the base URI to be initialized before calling this function.

.LINK
Set-BaseUri - For initializing the base URI for the API session..

#>

function Get-BaseUri {
    [CmdletBinding()]
    param ()

    # Check if the apiSession is initialized and contains the BaseUrl
    if ($script:apiSession -and $script:apiSession.Contains("BaseUri") -and $null -ne $script:apiSession.BaseUri) {
        return $script:apiSession["BaseUri"]
    }
    else {
        Write-Error "BaseUri is not set. Please initialize it using Set-BaseUri."
        return $null
    }
}
