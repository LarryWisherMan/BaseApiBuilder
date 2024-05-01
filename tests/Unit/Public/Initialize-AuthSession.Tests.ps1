BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Initialize-AuthSession" {
    Context "When the API key is provided" {
        It "Should initialize the authentication session" {
            # Define the API key
            $apiKey = 'my-api-key'

            # Call the function to initialize the authentication session
            $result = Initialize-AuthSession -ApiKey $apiKey

            # Validate the result
            $result.Authorization | Should -Be "Bearer $apiKey"
        }
    }

    Context "When the credentials are provided" {
        It "Should initialize the authentication session" {
            # Define the credentials
            $testPassword = ConvertTo-SecureString -String 'TestPassword' -AsPlainText -Force
            $credentials = New-Object System.Management.Automation.PSCredential('username',$testPassword)

            # Call the function to initialize the authentication session
            $result = Initialize-AuthSession -Credentials $credentials

            # Validate the result
            $result.Authorization | Should -Be "Basic dXNlcm5hbWU6VGVzdFBhc3N3b3Jk"
        }
    }

    Context "When no valid authentication method is provided" {
        It "Should return an error" {
            # Call the function without providing any authentication method
            $result = Initialize-AuthSession -ErrorAction SilentlyContinue

            # Validate the result
            $result | Should -Be $null
        }
    }


    Context "When the credentials are not provided" {
        It "Should return an error" {
            # Call the function without providing any credentials
            $result = Initialize-AuthSession -Credentials $null -ErrorAction SilentlyContinue

            # Validate the result
            $result | Should -Be $null
        }
    }
}
