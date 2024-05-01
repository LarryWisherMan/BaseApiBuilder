BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Initialize-WebRequestSession" {
    Context "When custom headers are provided" {
        It "Should initialize the web request session with custom headers" {
            # Define the custom headers
            $CustomHeaders = @{
                'Authorization' = 'Bearer 12345'
                'Content-Type' = 'application/json'
            }

            # Initialize the web request session
            $session = Initialize-WebRequestSession -CustomHeaders $CustomHeaders

            # Assert that the session object is not null
            $session | Should -Not -BeNullOrEmpty

            # Assert that the session headers contain the custom headers
            foreach ($key in $CustomHeaders.Keys) {
                $session.Headers[$key] | Should -Be $CustomHeaders[$key]
            }
        }
    }

    Context "When credentials are provided" {
        It "Should initialize the web request session with credentials" {
            # Define the credentials
            $testPassword = ConvertTo-SecureString -String 'TestPassword' -AsPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential('username',$testPassword)

            # Initialize the web request session
            $session = Initialize-WebRequestSession -Credentials $Credentials

            # Assert that the session object is not null
            $session | Should -Not -BeNullOrEmpty

            # Assert that the session credentials are set correctly
            $session.Credentials | Should -Not -BeNullOrEmpty
            $session.Credentials | should -BeOfType System.Net.NetworkCredential
        }
    }
}
