BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Close-ApiSession' {
    Context 'When the apiSession is initialized' {
        BeforeAll {
            # Initialize the apiSession
            New-ApiSession
            Set-BaseUri 'https://api.example.com'
        }

        It 'Should clear the apiSession' {
            # Act
            Close-ApiSession

            $Sesh = Get-CurrentApiSession

            # Assert
            $Sesh.Count| Should -Be 0
        }
    }

    Context 'When the apiSession is not initialized' {
        BeforeAll {
            InModuleScope -ModuleName $script:dscModuleName {
            $script:apiSession = $null
            }
        }

        It 'Should not throw an error' {
            # Act
            Close-ApiSession
        }
    }
}
