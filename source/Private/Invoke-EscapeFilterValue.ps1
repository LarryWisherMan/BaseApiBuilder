<#
.SYNOPSIS
    Escapes special characters in a string for use in filter queries.

.DESCRIPTION
    The Invoke-EscapeFilterValue function escapes characters that have special significance
    in query languages, such as backslashes (\), asterisks (*), and double quotes (").
    This is necessary to prevent these characters from being processed as control characters
    in queries, ensuring the string is treated as literal text.

.PARAMETER value
    The string value that needs escaping.

.EXAMPLE
    $escapedValue = Invoke-EscapeFilterValue -value 'C:\Temp\*file*.txt'
    # Output: 'C:\\Temp\\*file*\\.txt'

.EXAMPLE
    $userInput = '"SELECT * FROM users WHERE name LIKE "%Smith%"'
    $safeInput = Invoke-EscapeFilterValue -value $userInput
    # Output: '\"SELECT * FROM users WHERE name LIKE \"%Smith%\"'

.NOTES
    This function is typically used before incorporating user input into a query string
    to avoid SQL injection or similar query manipulation issues.

.INPUTS
    String

.OUTPUTS
    String

.LINK
    Invoke-BuildCondition
#>

function Invoke-EscapeFilterValue([string]$value)
{
    # Escapes quotes, asterisks, and backslashes
    return $value -replace '\\', '\\\\' -replace '\*', '\\*' -replace '\"', '\\"'
}
