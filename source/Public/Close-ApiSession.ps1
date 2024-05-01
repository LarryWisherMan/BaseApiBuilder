<#
.SYNOPSIS
Closes the current API session.

.DESCRIPTION
The Close-ApiSession function clears the current API session stored in a script-scoped variable, effectively ending the session. This is typically used to clean up session data after API interactions are complete.

.EXAMPLE
Close-ApiSession

This example demonstrates how to call the Close-ApiSession function to clear the current API session.

.NOTES
This function checks if the $script:apiSession variable is populated before attempting to clear it to prevent errors.

.LINK
Get-CurrentApiSession
Initialize-ApiSession

#>

function Close-ApiSession {
    if(-not $script:apiSession) {
        return
    }
    $script:apiSession.Clear()
}
