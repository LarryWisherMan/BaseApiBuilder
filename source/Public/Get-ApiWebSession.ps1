<#
.SYNOPSIS
Retrieves the current API web session.

.DESCRIPTION
The Get-ApiWebSession function returns the web session object stored in a script-scoped variable. This session object can be used for making authenticated web requests to the API.

.EXAMPLE
$session = Get-ApiWebSession

This example demonstrates how to retrieve the current API web session and store it in a variable.

.NOTES
This function is part of the BaseApiBuilder module which provides a set of tools for interacting with RESTful APIs.

.LINK
Initialize-ApiSession - For initializing a new API session.
Close-ApiSession - For closing the current API session.
#>

Function Get-ApiWebSession {

    return $script:apiSession.WebSession

}
