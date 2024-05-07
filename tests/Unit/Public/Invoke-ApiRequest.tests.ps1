BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
    Add-Type -AssemblyName System.Web
    Add-Type -AssemblyName System.Net.Http
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}


# Describe block encapsulating all test contexts for the Invoke-ApiRequest function
Describe 'Invoke-ApiRequest Tests' -Tag 'Unit' {
    Context 'GET requests' {

        BeforeEach {
            InModuleScope -ModuleName $script:dscModuleName -Scriptblock {
                Mock -CommandName Invoke-RestMethod  -MockWith { param($uri, $Method, $webSession, $body) return @{ StatusCode = 200; Content = 'Success' } }
                Mock -CommandName Get-BaseUri   -MockWith { 'https://api.baseuri.com' }
                Mock -CommandName Join-Path  -MockWith { param($path, $childPath) return "$path/$childPath" }
                Mock -CommandName New-ApiUri  -MockWith { param($BaseUri, $Endpoint, $QueryParams) return "$BaseUri/$Endpoint" }
                Mock -CommandName Get-ApiWebSession  -MockWith { return New-Object Microsoft.PowerShell.Commands.WebRequestSession }
            }
        }

        It 'Sends a GET request to the correct URI without query parameters' {
            InModuleScope -ModuleName $script:dscModuleName -ScriptBlock {
                Initialize-WebRequestSession
                $response = Invoke-ApiRequest -UriPrefix 'Core/V4' -Endpoint 'data'
                $response.StatusCode | Should -Be 200
                $response.Content | Should -Be 'Success'
            }

            #Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1 -Scope It -ModuleName $script:dscModuleName
            Assert-MockCalled -CommandName New-ApiUri -Exactly 1 -Scope It -ModuleName $script:dscModuleName -ParameterFilter {
                $endpoint -eq 'Core/V4/data' -and $BaseUri -eq 'https://api.baseuri.com' }

            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1 -Scope it -ModuleName $Script:dscModuleName -ParameterFilter {
                $Method -eq 'Get' -and $Uri -eq 'https://api.baseuri.com/Core/V4/data' -and $WebSession -is [Microsoft.PowerShell.Commands.WebRequestSession]
            }
        }


        It 'Sends a GET request to the correct URI with query parameters' {
            InModuleScope -ModuleName $script:dscModuleName -ScriptBlock {
                $queryParams = @{ 'key' = 'value' }
                $response = Invoke-ApiRequest -UriPrefix 'https://api.example.com' -Endpoint 'data' -QueryParams $queryParams
                $response.StatusCode | Should -Be 200
            }

            $queryParams = @{ 'key' = 'value' }

            Assert-MockCalled -CommandName New-ApiUri -Exactly 1 -Scope It -ParameterFilter {
                $QueryParams.ContainsKey('key') -and $QueryParams['key'] -eq 'value'
            } -ModuleName $script:dscModuleName
        }
    }

    Context 'POST requests' {
        BeforeEach {
            InModuleScope -ModuleName $script:dscModuleName -Scriptblock {
                Mock -CommandName Invoke-RestMethod  -MockWith { param($uri, $Method, $webSession, $body) return @{ StatusCode = 200; Content = 'Success' } }
                Mock -CommandName Get-BaseUri   -MockWith { 'https://api.baseuri.com' }
                Mock -CommandName Join-Path  -MockWith { param($path, $childPath) return "$path/$childPath" }
                Mock -CommandName New-ApiUri  -MockWith { param($BaseUri, $Endpoint, $QueryParams) return "$BaseUri/$Endpoint" }
                Mock -CommandName Get-ApiWebSession  -MockWith { return New-Object Microsoft.PowerShell.Commands.WebRequestSession }
            }
        }
        It 'Sends a POST request with a body' {
            InModuleScope -ModuleName $script:dscModuleName -ScriptBlock {
                $body = @{ name = "John"; age = 30 } | ConvertTo-Json
                $response = Invoke-ApiRequest -UriPrefix 'https://api.example.com' -Endpoint 'users' -Method 'Post' -Body $body
                $response.StatusCode | Should -Be 200
            }

            $body = @{ name = "John"; age = 30 } | ConvertTo-Json

            Assert-MockCalled -CommandName Invoke-RestMethod -Exactly 1 -Scope It -ParameterFilter {
                $Method -eq 'Post' -and $Body -eq $body
            } -ModuleName $script:dscModuleName
        }
    }
}
