<#
.SYNOPSIS
    Constructs a conditional string for querying based on specified field and details.

.DESCRIPTION
    The Invoke-BuildCondition function generates a query condition string dynamically based on the input field and details provided.
    It constructs the condition by iterating over each operation in the details hashtable and formatting it into a string
    that can be used in a query statement.

.PARAMETER field
    The field name which the conditions will be applied to.

.PARAMETER details
    A hashtable where keys are the operation (like '=', '<', '>', 'LIKE', etc.) and values are the conditions to be applied.
    These values can be a single value or an array of values for the specified operation.

.EXAMPLE
    $details = @{
        '='  = 'Windows'
        '!=' = 'Linux'
    }
    $condition = Invoke-BuildCondition -field 'OS' -details $details
    # Output: (OS = 'Windows' or OS != 'Linux')

.EXAMPLE
    $details = @{
        'LIKE' = @('Windows%', 'Linux%')
    }
    $condition = Invoke-BuildCondition -field 'OS' -details $details
    # Output: (OS LIKE 'Windows%' or OS LIKE 'Linux%')

.NOTES
    Ensure that the values in the details parameter are correct and that any strings that need to be escaped
    are handled prior to calling this function, using the 'Escape-FilterValue' function to avoid query errors.

.INPUTS
    String, Hashtable

.OUTPUTS
    String

.LINK
    Invoke-EscapeFilterValue
#>

function Invoke-BuildCondition([string]$field, [hashtable]$details)
{
    $condition = ""
    foreach ($op in $details.Keys)
    {
        $values = $details[$op]
        if ($values -isnot [array])
        {
            $values = @($values)  # Ensure $values is always an array
        }
        $subConditions = @($values | ForEach-Object {
                $value = Invoke-EscapeFilterValue $_
                "$field $op '$value'"
            })
        if ($subConditions.Count -gt 1)
        {
            $conditionPart = '(' + ($subConditions -join ' or ') + ')'
        }
        else
        {
            $conditionPart = $subConditions[0]
        }
        $condition += "$conditionPart and "
    }
    return $condition.TrimEnd(' and ')
}
