BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Test-ApiSession' {
    Context 'When the API session is initialized and valid' {
        BeforeAll {
            Mock -ModuleName $script:dscModuleName Get-CurrentApiSession  { return @{ WebSession = $true } }
        }

        It 'Should return $true' {
            {Test-ApiSession}|should -not -Throw
        }
    }

    Context 'When the API session is not initialized' {
        BeforeAll {
            Mock -ModuleName $script:dscModuleName Get-CurrentApiSession  { return $null }
        }

        It 'Should return $false' {
            {Test-ApiSession}|should -Throw
        }
    }

    Context 'When the web session within the API session is not valid' {
        BeforeAll {
            Mock -ModuleName $script:dscModuleName Get-CurrentApiSession  { @{ WebSession = $false } }
        }

        It 'Should return $false' {
            {Test-ApiSession}|should -Throw
        }
    }
}
