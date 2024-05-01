BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Set-CurrentApiSession" {
    Context "When a new session is provided" {
        It "Should set the current API session with the new session" {
            # Define the new web request session
            New-ApiSession
            $session = Get-CurrentApiSession
            $session.Add('BaseUri', 'https://api.example.com')
            $session.Add('AuthHeaders', @{ 'Authorization' = 'Bearer wow' })
            $session.Add('WebSession', (New-Object -TypeName 'System.Net.Http.HttpClient'))

            $NewSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
            $NewSession.Headers.Add("Authorization", "Bearer 12345")

            # Set the current API session with the new session
            Set-CurrentApiSession -NewSession $NewSession

            # Assert that the API session is set correctly
            $session.WebSession | Should -Be $NewSession
            $session.AuthHeaders.Authorization | Should -Be "Bearer 12345"
        }
    }

    Context "When an API key is provided" {
        It "Should set the current API session with the API key" {

            New-ApiSession
            $session = Get-CurrentApiSession
            $session.Add('BaseUri', 'https://api.example.com')
            $session.Add('AuthHeaders', @{ 'Authorization' = 'Bearer wow' })
            $session.Add('WebSession', (New-Object -TypeName 'System.Net.Http.HttpClient'))

            $NewSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
            $NewSession.Headers.Add("Authorization", "Bearer 12345")

            # Define the API key
            $ApiKey = "API-KEY-12345"

            # Set the current API session with the API key
            Set-CurrentApiSession -NewSession $Newsession -ApiKey $ApiKey

            # Assert that the API session is set correctly
            $Session.WebSession.Headers["Authorization"] | Should -Be "Bearer $ApiKey"
        }
    }

    Context "When credentials are provided" {
        It "Should set the current API session with the credentials" {

            New-ApiSession
            $session = Get-CurrentApiSession
            $session.Add('BaseUri', 'https://api.example.com')
            $session.Add('AuthHeaders', @{ 'Authorization' = 'Bearer wow' })
            $session.Add('WebSession', (New-Object -TypeName 'System.Net.Http.HttpClient'))

            $NewSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
            $NewSession.Headers.Add("Authorization", "Bearer 12345")
            $session.WebSession = $NewSession

            $clearTextPassword = "TestPassword"
            $testPassword = ConvertTo-SecureString -String $clearTextPassword -AsPlainText -Force
            $Credentials = New-Object System.Management.Automation.PSCredential('username',$testPassword)

            # Set the current API session with the credentials
            Set-CurrentApiSession -Credentials $Credentials

            # Assert that the API session is set correctly
            $base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($($Credentials.UserName) + ':' + ($clearTextPassword)))
            $session.WebSession.Headers.Authorization| Should -Be "Basic $base64Auth"
        }
    }

    Context "When custom headers are provided" {
        It "Should set the current API session with the custom headers" {

            New-ApiSession
            $session = Get-CurrentApiSession
            $session.Add('BaseUri', 'https://api.example.com')
            $session.Add('AuthHeaders', @{ 'Authorization' = 'Bearer wow' })
            $session.Add('WebSession', (New-Object -TypeName 'System.Net.Http.HttpClient'))

            $NewSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
            $NewSession.Headers.Add("Authorization", "Bearer 12345")
            $session.WebSession = $NewSession

            # Define the custom headers
            $CustomHeaders = @{
                'Content-Type' = 'application/json'
            }

            # Set the current API session with the custom headers
            Set-CurrentApiSession -NewSession $NewSession -CustomHeaders $CustomHeaders

            # Assert that the API session is set correctly
            foreach ($key in $CustomHeaders.Keys) {
                $session.WebSession.Headers[$key] | Should -Be $CustomHeaders[$key]
            }
        }
    }
}
