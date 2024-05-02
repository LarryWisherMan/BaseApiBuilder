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

            $WebSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
            $date = Get-Date
            $hash = @{
                Date        = $date
                BaseUri     = 'https://api.example.com'
                AuthHeaders = @{ 'Authorization' = 'Bearer 12345' }
                WebSession  = $WebSession
            }
            # Define the new web request session
            New-ApiSession
            Set-CurrentApiSession -SessionHash $hash

            $session = Get-CurrentApiSession
            # Assert that the API session is set correctly
            $session.date | Should -Be $date
            $session.BaseUri | Should -Be 'https://api.example.com'
            $session.AuthHeaders.Authorization | Should -Be "Bearer 12345"
            $session.WebSession | Should -Be $WebSession
        }
    }
}
