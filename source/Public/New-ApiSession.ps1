<#
.SYNOPSIS
Creates a new API session object.

.DESCRIPTION
The New-ApiSession function initializes a new, empty API session object as a script-scoped hashtable. This session object is used to store session-specific information such as authentication headers, base URI, and other relevant data for making API calls.

.EXAMPLE
New-ApiSession

This example demonstrates how to create a new API session object.

.NOTES
This function is part of the BaseApiBuilder module which provides a set of tools for interacting with RESTful APIs. It is the first step in establishing a session for API interactions.

#>

function New-ApiSession {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param ()

    $script:apiSession = @{}

}
