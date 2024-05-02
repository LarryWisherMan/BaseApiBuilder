BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Initialize-WebRequestSession Tests" {
    It "Creates a session with default parameters" {
        $session = Initialize-WebRequestSession
        $session | Should -Not -Be $null
        $session.Headers.Count | Should -Be 0
        $session.Credentials | Should -Be $null
    }

    It "Sets custom headers correctly" {
        $headers = @{ "Content-Type" = "application/json" }
        $session = Initialize-WebRequestSession -Headers $headers
        $session.Headers["Content-Type"] | Should -Be "application/json"
    }

    It "Sets credentials correctly" {
        $cred = New-Object System.Management.Automation.PSCredential ("username", (ConvertTo-SecureString "password" -AsPlainText -Force))
        $session = Initialize-WebRequestSession -credentials $cred
        $session.Credentials.UserName | Should -Be "username"
    }
}
