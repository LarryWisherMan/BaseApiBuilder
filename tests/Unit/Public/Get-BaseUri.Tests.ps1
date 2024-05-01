BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe "Get-BaseUri" {
    Context "When BaseUri is set" {
        BeforeAll {
            Set-BaseUri -Uri "https://api.example.com"
        }

        It "Should return the BaseUri" {
            $baseUri = Get-BaseUri
            $baseUri | Should -Be "https://api.example.com"
        }
    }

    Context "When BaseUri is not set" {

        BeforeAll {
            New-ApiSession
        }

        It "Should return null" {
            $baseUri = Get-BaseUri -ErrorAction SilentlyContinue
            $baseUri | Should -Be $null
        }

        It "Should write an error" {
            { Get-BaseUri -ErrorAction Stop } | Should -Throw "BaseUri is not set. Please initialize it using Set-BaseUri."
        }
    }
}
