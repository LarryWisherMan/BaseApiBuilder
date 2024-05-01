BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Get-CurrentApiSession" {
    Context "When the apiSession is not initialized" {
        BeforeAll {
            # Remove the apiSession variable
            New-ApiSession
        }

        It "Should return null" {
            $result = Get-CurrentApiSession
            $result | Should -BeNullOrEmpty
        }
    }

    Context "When the apiSession is initialized" {
        BeforeAll {
            # Initialize the apiSession variable
            New-ApiSession
            $session = Get-CurrentApiSession
            $session.Add('BaseUri', 'https://api.example.com')
            $session.Add('AuthHeaders', @{ 'Authorization' = 'Bearer 12345' })
            $session.Add('WebSession', (New-Object -TypeName 'System.Net.Http.HttpClient'))
        }

        It "Should return the apiSession" {
            $result = Get-CurrentApiSession
            $result | Should -Be $session
        }
    }
}
