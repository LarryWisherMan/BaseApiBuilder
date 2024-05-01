<#
.SYNOPSIS
Sets the base URI for API calls.

.DESCRIPTION
The Set-BaseUri function is used to set the base URI for subsequent API calls. It stores the base URI in a script-scoped variable for use by other functions in the module.

.PARAMETER Uri
The base URI to be used for API calls. This parameter is mandatory.

.EXAMPLE
Set-BaseUri -Uri "https://api.example.com"

This example sets the base URI to "https://api.example.com" for all subsequent API calls.

.NOTES
This function is part of a PowerShell module designed to simplify interactions with RESTful APIs by managing session state, including authentication and base URIs.

.LINK
- Initialize-AuthSession - For initializing the authentication session.
- New-ApiSession - For creating a new API session object.
#>

function Set-BaseUri {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Uri
    )

    # Ensure the apiSession variable is initialized
    if (-not $script:apiSession) {
        $script:apiSession = @{}
    }

    # Set the BaseUrl in the apiSession
    $script:apiSession["BaseUri"] = $Uri
    Write-Verbose "BaseUri set to: $Uri"
}
