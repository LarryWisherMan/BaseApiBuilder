BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'New-ApiSession' {
    Context 'When given a BaseUri, Endpoint, and QueryParams' {
        It 'Should return a complete URI' {
            # Arrange
            New-ApiSession
            $Sesh = Get-CurrentApiSession

            # Assert
            $Sesh.GetType().Name | Should -Be "Hashtable"

        }
    }
}
