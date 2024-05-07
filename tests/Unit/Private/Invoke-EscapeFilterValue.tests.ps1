$ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
$ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -match 'source|src' -or $_.Directory.Name -eq $_.BaseName) -and
        $(try
            {
                Test-ModuleManifest $_.FullName -ErrorAction Stop
            }
            catch
            {
                $false
            }) }
).BaseName

BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'
    Import-Module -Name $script:dscModuleName -Force -ErrorAction 'Stop'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:dscModuleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:dscModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')
    Remove-Module -Name $script:dscModuleName -ErrorAction SilentlyContinue
}

InModuleScope -ModuleName $ProjectName {
    Describe 'Invoke-EscapeFilterValue Tests' {

        It 'escapes backslashes in the input string' {
            $inputString = 'C:\Temp\NewFolder'
            $escapedString = Invoke-EscapeFilterValue -value $inputString
            $escapedString | Should -Be 'C:\\\\Temp\\\\NewFolder'
        }

        It 'escapes asterisks in the input string' {
            $inputString = 'Look at this *amazing* example!'
            $escapedString = Invoke-EscapeFilterValue -value $inputString
            $escapedString | Should -Be 'Look at this \\*amazing\\* example!'
        }

        It 'escapes double quotes in the input string' {
            $inputString = 'He said, "Hello, how are you?"'
            $escapedString = Invoke-EscapeFilterValue -value $inputString
            $escapedString | Should -Be 'He said, \\"Hello, how are you?\\"'
        }

        It 'correctly escapes a combination of special characters' {
            $inputString = 'Path: C:\Temp\*new*\File "test.txt"'
            $escapedString = Invoke-EscapeFilterValue -value $inputString
            $escapedString | Should -Be 'Path: C:\\\\Temp\\\\\\*new\\*\\\\File \\"test.txt\\"'
        }

        It 'returns the same string if no special characters are present' {
            $inputString = 'No special characters here'
            $escapedString = Invoke-EscapeFilterValue -value $inputString
            $escapedString | Should -Be 'No special characters here'
        }
    }

}
