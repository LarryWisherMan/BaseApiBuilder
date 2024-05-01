<#
.SYNOPSIS
   Converts a PSCredential object's password to plain text.

.DESCRIPTION
   The ConvertTo-PlainText function takes a PSCredential object as input and converts the secure string password to plain text.

.PARAMETER Credential
   The PSCredential object whose password is to be converted to plain text. This is a mandatory parameter.

.EXAMPLE
   $cred = Get-Credential
   ConvertTo-PlainText -Credential $cred

   This example demonstrates how to use the ConvertTo-PlainText function. It first prompts the user for a username and password (Get-Credential), then converts the password to plain text.

.NOTES
   Be careful when using this function, as it can expose sensitive password information in plain text.
#>
function ConvertTo-PlainText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    try {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)
        $PlainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    }
    finally {
        if ($null -ne $bstr) {
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }

    return $PlainTextPassword
}
