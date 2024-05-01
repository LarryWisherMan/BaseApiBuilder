<#
.SYNOPSIS
Tests the current API session for validity and throws an error if the session is invalid.

.DESCRIPTION
The Test-ApiSession function checks if the current API session is initialized and if the web session within it is valid. If either condition is not met, the function throws an error that stops execution, indicating that the API session is not valid. This behavior ensures that subsequent API operations are not attempted on an invalid session.

.EXAMPLE
try {
    Test-ApiSession
    # Additional code to run on a valid session
} catch {
    Write-Error "Session validation failed: $_"
}

This example demonstrates how to call the Test-ApiSession function within a try/catch block to handle possible errors from an invalid API session.

.NOTES
This function is part of a PowerShell module designed to manage API sessions. It is crucial to use this function to ensure that an API session is properly initialized and valid before attempting to make API calls. The function will halt script execution if the session is found to be invalid.

.LINK
- Get-CurrentApiSession - For retrieving the current API session.
- New-ApiSession - For creating a new API session.
#>

function Test-ApiSession {
    [CmdletBinding()]
    [OutputType([void])]
    param ()

    $functionName = $(($MyInvocation.MyCommand).Name)
    $VerbosePrefix = "[${functionName}] -"

    # Check if the API session is initialized
    $currentSession = Get-CurrentApiSession
    if (-not $currentSession) {
        Write-Verbose "$VerbosePrefix API session is not initialized."
        Throw "API session is not initialized."
    }

    # Check if the web session is valid
    if (-not $currentSession.WebSession) {
        Write-Verbose "$VerbosePrefix Web session is not valid."
        Throw "Web session is not valid."
    }

    Write-Verbose "API session is valid."
}
