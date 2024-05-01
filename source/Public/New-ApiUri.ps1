<#
.SYNOPSIS
Creates a new API URI based on base URI, endpoint, and query parameters.

.DESCRIPTION
The New-ApiUri function constructs a complete URI for API calls. It takes a base URI, an endpoint, and an optional hashtable of query parameters, then returns the constructed URI. If query parameters include nested hashtables, they are converted into a filter string format.

.PARAMETER BaseUri
The base URI of the API.

.PARAMETER Endpoint
The specific endpoint to be appended to the base URI.

.PARAMETER QueryParams
An optional hashtable of query parameters to be appended to the URI. Supports nested hashtables for complex filters.

.EXAMPLE
$baseUri = "https://api.example.com"
$endpoint = "data"
$queryParams = @{ "filter" = "active"; "sort" = "name" }
$uri = New-ApiUri -BaseUri $baseUri -Endpoint $endpoint -QueryParams $queryParams

This example constructs a URI for the "data" endpoint on "https://api.example.com", with a filter for active items and sorting by name.

.NOTES
This function is part of a PowerShell module designed to simplify API interactions by generating URIs dynamically based on provided parameters.

.LINK
- Get-AuthHeaders - For retrieving authentication headers for API calls.
- Initialize-ApiSession - For initializing a new API session.
#>

function New-ApiUri
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param(
        [string]$BaseUri,
        [string]$Endpoint,
        [hashtable]$QueryParams
    )

    $uriBuilder = New-Object System.UriBuilder $BaseUri
    $uriBuilder.Path += $Endpoint

    # Build the query string from the hashtable
    $query = $QueryParams.GetEnumerator() | Where-Object {
        # Exclude null or empty values
        $null -ne $_.Value -and ($_.Value -isnot [string] -or -not [string]::IsNullOrEmpty($_.Value))
    } | ForEach-Object {
        $key = [Uri]::EscapeDataString($_.Key)
        $value = $_.Value

        # Handle complex filters stored in a nested hashtable
        if ($value -is [hashtable])
        {
            # Convert hashtable to a filter string (e.g., "key1='value1' and key2='value2'")
            $filterConditions = $value.GetEnumerator() | Where-Object {
                $null -ne $_.Value -and ($_.Value -isnot [string] -or -not [string]::IsNullOrEmpty($_.Value))
            } | ForEach-Object {
                $filterKey = $_.Key
                $filterValue = $_.Value
                "$filterKey='$filterValue'"
            }
            $value = $filterConditions -join ' and '
        }

        # Prepare the key-value pair for the query string if not empty
        if (-not [string]::IsNullOrEmpty($value))
        {
            $value = [Uri]::EscapeDataString($value)
            "$key=$value"
        }
    }

    # Only join non-empty entries
    $uriBuilder.Query = ($query | Where-Object { $_ }) -join '&'

    # Return the complete URI
    return $uriBuilder.Uri.AbsoluteUri
}
