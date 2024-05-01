<#
.SYNOPSIS
Retrieves the current API session.

.DESCRIPTION
The Get-CurrentApiSession function returns the current API session object stored in a script-scoped variable. This session object can be used to manage and maintain state across multiple API calls within the same session.

.EXAMPLE
$session = Get-CurrentApiSession

This example demonstrates how to retrieve the current API session and store it in a variable.

.NOTES
This function is part of the BaseApiBuilder module which provides a set of tools for interacting with RESTful APIs. It is essential for managing the lifecycle of an API session.

.LINK
Initialize-ApiSession - For initializing a new API session.
Close-ApiSession - For closing the current API session.
Get-ApiWebSession - For retrieving the web session object.
Get-AuthHeaders - For retrieving authentication headers for the current session.
#>

function Get-CurrentApiSession {
    return $script:apiSession
}
