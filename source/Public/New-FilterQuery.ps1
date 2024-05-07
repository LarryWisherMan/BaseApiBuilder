<#
.SYNOPSIS
    Constructs a complete filter query string from a hashtable of filter conditions.

.DESCRIPTION
    The New-FilterQuery function constructs a comprehensive query string by processing a hashtable
    where each key-value pair represents a field and its associated conditions.
    It uses the Invoke-BuildCondition function to generate conditional strings for each field,
    and then combines these conditions into a single query string using logical 'and'.

.PARAMETER Filters
    A hashtable containing the fields and their corresponding conditions.
    Each key in the hashtable is a field name, and each value is another hashtable
    where the keys are operators (e.g., '=', '<', 'LIKE') and the values are the conditions
    to apply with those operators.

.EXAMPLE
    $filters = @{
        'Name' = @{
            'LIKE' = 'John%'
        }
        'Age' = @{
            '>=' = 30
        }
    }
    $query = New-FilterQuery -Filters $filters
    # Output: (Name LIKE 'John%') and (Age >= '30')

.NOTES
    This function relies on Invoke-BuildCondition to handle the creation of condition strings.
    Ensure that the filters and values provided are valid and that they are formatted correctly
    to avoid errors in the query construction.

.INPUTS
    Hashtable

.OUTPUTS
    String

.LINK
    Invoke-BuildCondition
    Invoke-EscapeFilterValue
#>
function New-FilterQuery
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Filters
    )

    $queryParts = @()
    foreach ($field in $Filters.Keys)
    {
        $details = $Filters[$field]
        $queryParts += Invoke-BuildCondition $field $details
    }

    $queryString = $queryParts -join ' and '
    return $queryString
}
