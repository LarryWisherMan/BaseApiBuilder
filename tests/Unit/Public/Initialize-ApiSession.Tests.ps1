BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Initialize-ApiSession Tests" {

    BeforeAll {

        Mock Set-BaseUri {}
        #Mock -ModuleName $script:dscModuleName -CommandName Initialize-WebRequestSession {param($Headers) return $Headers }
        Mock Set-CurrentApiSession {}
        Mock Get-CurrentApiSession { return $true }
        Mock Close-ApiSession {}
    }
    It "Initializes with default parameters" {
        $result = Initialize-ApiSession
        $result | Should -Be $true
    }

    It "Passes custom user agent" {
        $result = Initialize-ApiSession -UserAgent "Test Agent"
        $result.WebSession.Headers.'User-Agent' | Should -Be "Test Agent"
    }

    It "Sets BaseURI correctly" {
        $return = Initialize-ApiSession -BaseURI "https://api.test.com"
        $return.BaseUri | Should -Be "https://api.test.com"
    }
}
