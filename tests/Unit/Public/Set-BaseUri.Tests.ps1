BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Set-BaseUri' {
    Context 'When given a Uri' {
        It 'Should set the BaseUri in the apiSession' {
            # Arrange
            $Uri = 'https://api.example.com'

            # Act
            Set-BaseUri -Uri $Uri

            $session = Get-CurrentApiSession

            # Assert
            $session.BaseURI | Should -Be $Uri
        }
    }
}
