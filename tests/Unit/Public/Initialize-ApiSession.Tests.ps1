BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Initialize-ApiSession" {
    Context "When the API
    credentials are provided" {
        It "Should initialize the API session" {
            # Define the API credentials

            New-ApiSession
            $Session = Get-CurrentApiSession
            $BaseUri = 'https://api.example.com'
            $Session.Add('BaseURI',$BaseUri)
            $Session.Add('WebSession','')
            $Session.Add('AuthHeaders','')
            $testPassword = ConvertTo-SecureString -String 'TestPassword' -AsPlainText -Force
            $APICreds = New-Object System.Management.Automation.PSCredential('username',$testPassword)

            # Call the function to initialize the API session
            $result = Initialize-ApiSession -APICreds $APICreds

            $resultSession = Get-CurrentApiSession
            # Validate the result
            $result | Should -Be $true
            $resultSession.BaseURI | Should -Be $BaseUri
            $resultSession.WebSession | Should -BeOfType 'Microsoft.PowerShell.Commands.WebRequestSession'
            $resultSession.AuthHeaders.Authorization | Should -Be 'Basic dXNlcm5hbWU6VGVzdFBhc3N3b3Jk'

        }
    }

    Context "When the API credentials are not provided" {
        It "Should return false" {
            # Call the function without providing the API credentials
            $result = Initialize-ApiSession -APICreds $null

            # Validate the result
            $result | Should -Be $false
        }
    }

    Context "When the authentication session fails" {
        It "Should return false" {

            New-ApiSession
            $Session = Get-CurrentApiSession
            $BaseUri = 'https://api.example.com'
            $Session.Add('BaseURI',$BaseUri)
            $Session.Add('WebSession','')
            $Session.Add('AuthHeaders','')
            $testPassword = ConvertTo-SecureString -String 'TestPassword' -AsPlainText -Force
            $APICreds = New-Object System.Management.Automation.PSCredential('username',$testPassword)


            # Mock the Initialize-AuthSession function to return null
            Mock -ModuleName $script:dscModuleName Initialize-AuthSession { return $null }

            # Call the function to initialize the API session
            $result = Initialize-ApiSession -APICreds $APICreds -ErrorAction SilentlyContinue

            # Validate the result
            $result | Should -Be $false
        }
    }

    Context "When the web request session fails" {
        It "Should return false" {

            New-ApiSession
            $Session = Get-CurrentApiSession
            $BaseUri = 'https://api.example.com'
            $Session.Add('BaseURI',$BaseUri)
            $Session.Add('WebSession','')
            $Session.Add('AuthHeaders','')
            $testPassword = ConvertTo-SecureString -String 'TestPassword' -AsPlainText -Force
            $APICreds = New-Object System.Management.Automation.PSCredential('username',$testPassword)


            # Mock the Initialize-WebRequestSession function to return null
            Mock -ModuleName $script:dscModuleName Initialize-WebRequestSession { return $null }

            # Call the function to initialize the API session
            $result = Initialize-ApiSession -APICreds $APICreds -ErrorAction SilentlyContinue

            # Validate the result
            $result | Should -Be $false
        }
    }


}
