BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Get-ApiWebSession' {
    Context 'When the function is called' {
        It 'Should return the WebSession object from the apiSession variable' {
            InModuleScope -ModuleName $script:dscModuleName { # Arrange
                $expectedWebSession = "Session"
                $script:apiSession = @{
                    WebSession = $expectedWebSession
                }
            }

            # Act
            $result = Get-ApiWebSession

            # Assert
            $result | Should -Be "Session"
        }
    }
}
