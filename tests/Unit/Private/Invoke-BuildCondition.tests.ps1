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

    Describe 'Invoke-BuildCondition Tests' {
        BeforeAll {
            Mock Invoke-EscapeFilterValue { param($value) return $value } # Mocking the Escape function for simplicity
        }

        It 'creates a simple equality condition' {
            $details = @{
                '=' = 'Windows'
            }
            $result = Invoke-BuildCondition -field 'OS' -details $details
            $result | Should -Be "OS = 'Windows'"
        }

        It 'creates a condition with multiple operators' {
            $details = @{
                '='  = 'Windows'
                '!=' = 'Linux'
            }
            $result = Invoke-BuildCondition -field 'OS' -details $details
            $result | Should -Be "OS != 'Linux' and OS = 'Windows'"
        }

        It 'handles array of values for a single operator' {
            $details = @{
                'LIKE' = @('Windows%', 'Linux%')
            }
            $result = Invoke-BuildCondition -field 'OS' -details $details
            $result | Should -Be "(OS LIKE 'Windows%' or OS LIKE 'Linux%')"
        }

        It 'combines multiple operators with multiple values' {
            $details = @{
                '>=' = @('10', '20')
                '<=' = '30'
            }
            $result = Invoke-BuildCondition -field 'Version' -details $details
            $result | Should -Be "Version <= '30' and (Version >= '10' or Version >= '20')"
        }

        It 'escapes values using Invoke-EscapeFilterValue' {
            Mock Invoke-EscapeFilterValue { param($value) return "Escaped_$value" }
            $details = @{
                '=' = 'Naive; DROP TABLE Users;'
            }
            $result = Invoke-BuildCondition -field 'Comment' -details $details
            $result | Should -Be "Comment = 'Escaped_Naive; DROP TABLE Users;'"
            Assert-MockCalled Invoke-EscapeFilterValue -Exactly 1 -ParameterFilter { $value -eq 'Naive; DROP TABLE Users;' }
        }
    }


}
