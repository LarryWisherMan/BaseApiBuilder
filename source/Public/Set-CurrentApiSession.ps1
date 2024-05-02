<#
.SYNOPSIS
    Sets the current API session to a specified session hash.

.DESCRIPTION
    The Set-CurrentApiSession function updates the global variable $script:apiSession with a new session hash.
    This session hash typically includes session details such as the base URI, headers, and other configurations.

.PARAMETER SessionHash
    A hashtable containing the session details to be set as the current API session.

.EXAMPLE
    $sessionDetails = @{
        Time       = (Get-Date)
        BaseUri    = 'https://api.example.com'
        AuthHeaders = @{ Authorization = "Bearer your_token_here" }
    }
    Set-CurrentApiSession -SessionHash $sessionDetails
    This example sets the current API session to the specified session details.

.OUTPUTS
    None. This function updates a global variable and does not output directly.

.NOTES
    This function is typically used in scripts where API session details need to be maintained across multiple function calls.
#>
function Set-CurrentApiSession
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [hashtable]$SessionHash
    )

    $script:apiSession = $SessionHash
    Write-Verbose "API session updated successfully."
}
