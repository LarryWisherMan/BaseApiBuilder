BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Get-AuthHeaders' {
    Context 'When the AuthHeaders are not initialized' {
        BeforeAll {
            New-ApiSession
        }

        It 'Should return an error message' {
            {Get-AuthHeaders -ErrorAction Stop}  | Should -Throw -ExpectedMessage "Authentication is required. Please call Initialize-AuthSession."

        }
    }

    Context 'When the AuthHeaders are initialized' {
        BeforeEach{
            New-ApiSession
            $sesh = Get-CurrentApiSession
            $sesh.AuthHeaders = @{ 'Authorization' = 'Bearer 12345' }

        }
        It 'Should return the AuthHeaders' {
            $result = Get-AuthHeaders
            $result.Authorization  | Should -be "Bearer 12345"
        }

        It 'Should be a Hashtable' {
            $result = Get-AuthHeaders
            $result.GetType().Name | Should -Be 'Hashtable'
        }
    }
}
