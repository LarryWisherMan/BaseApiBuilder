BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'New-ApiUri' {
    Context 'When given a BaseUri, Endpoint, and QueryParams' {
        It 'Should return a complete URI' {
            # Arrange
            $BaseUri = 'https://api.example.com/v1/'
            $Endpoint = 'resource'
            $QueryParams = @{
                'param1' = 'value1'
                'param2' = 'value2'
            }

            # Act
            $result = New-ApiUri -BaseUri $BaseUri -Endpoint $Endpoint -QueryParams $QueryParams

            # Assert
            $result | Should -Be 'https://api.example.com/v1/resource?param1=value1&param2=value2'
        }
    }

    Context 'When creating a URI with valid parameters' {
        It 'Should return the correct URI' {
            # Arrange
            $baseUri = 'https://api.example.com'
            $endpoint = 'data'
            $queryParams = @{ 'key1' = 'value1'; 'key2' = 'value2' }

            # Act
            $result = New-ApiUri -BaseUri $baseUri -Endpoint $endpoint -QueryParams $queryParams

            # Assert
            $result | Should -Be "https://api.example.com/data?key1=value1&key2=value2"
        }
    }

    Context 'When creating a URI with complex query parameters' {
        It 'Should return the correct URI with complex query' {
            # Arrange
            $baseUri = 'https://api.example.com'
            $endpoint = 'data'
            $queryParams = @{ 'filter' = @{ 'key1' = "value1"; 'key2' = "value2" } }

            # Act
            $result = New-ApiUri -BaseUri $baseUri -Endpoint $endpoint -QueryParams $queryParams

            # Assert
            $result | Should -Be "https://api.example.com/data?filter=key1%3D'value1'%20and%20key2%3D'value2'"
        }
    }

    Context 'When creating a URI without query parameters' {
        It 'Should return the correct URI without a query string' {
            # Arrange
            $baseUri = 'https://api.example.com'
            $endpoint = 'data'
            $queryParams = @{}

            # Act
            $result = New-ApiUri -BaseUri $baseUri -Endpoint $endpoint -QueryParams $queryParams

            # Assert
            $result | Should -Be 'https://api.example.com/data'
        }
    }

    Context 'When creating a URI with null or empty query parameters' {
        It 'Should ignore null or empty query parameters' {
            # Arrange
            $baseUri = 'https://api.example.com'
            $endpoint = 'data'
            $queryParams = @{ 'key1' = $null; 'key2' = '' }

            # Act
            $result = New-ApiUri -BaseUri $baseUri -Endpoint $endpoint -QueryParams $queryParams

            # Assert
            $result | Should -Be 'https://api.example.com/data'
        }
    }
}
