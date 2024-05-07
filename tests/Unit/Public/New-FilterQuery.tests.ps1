BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}


Describe 'New-FilterQuery Tests' {
    BeforeAll {
        Mock Invoke-BuildCondition {
            param ($field, $details)
            if ($details.Keys -contains 'LIKE') {
                return "($field LIKE '$($details.LIKE)')"
            }
            elseif ($details.Keys -contains '>=') {
                return "($field >= '$($details['>='])')"
            }
        } -ModuleName $script:dscModuleName
    }

    It 'constructs a query for single filter condition' {
        $filters = @{
            'Name' = @{
                'LIKE' = 'John%'
            }
        }
        $result = New-FilterQuery -Filters $filters
        $result | Should -Be "(Name LIKE 'John%')"
    }

    It 'constructs a query for multiple filter conditions' {
        $filters = [ordered]@{
            'Age' = @{
                '>=' = 30
            }
            'Name' = @{
                'LIKE' = 'John%'
            }
        }
        $result = New-FilterQuery -Filters $filters
        $result | Should -be "(Age >= '30') and (Name LIKE 'John%')"
    }

    It 'handles an empty filters hashtable gracefully' {
        $filters = @{}
        $result = New-FilterQuery -Filters $filters
        $result | Should -Be ''
    }

    It 'should call Invoke-BuildCondition correctly for each filter' {
        $filters = @{
            'Name' = @{
                'LIKE' = 'John%'
            }
            'Age' = @{
                '>=' = 30
            }
        }
        New-FilterQuery -Filters $filters
        Assert-MockCalled Invoke-BuildCondition -Exactly 1 -Scope It -ParameterFilter {
            $field -eq 'Name' -and $details.LIKE -eq 'John%'
        } -ModuleName $script:dscModuleName

        Assert-MockCalled Invoke-BuildCondition -Exactly 1 -Scope It -ParameterFilter {
            $field -eq 'Age' -and $details.'>=' -eq 30
        } -ModuleName $script:dscModuleName
    }
}
