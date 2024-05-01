BeforeAll {
    $script:dscModuleName = 'BaseApiBuilder'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}


Describe 'ConvertTo-PlainText' {
    Context 'When converting a PSCredential object to plain text' {
        It 'Should return the correct plain text password' {
            # Arrange
            $securePassword = ConvertTo-SecureString 'PlainTextPassword' -AsPlainText -Force
            $credential = New-Object System.Management.Automation.PSCredential ('username', $securePassword)

            # Act
            $plainTextPassword = ConvertTo-PlainText -Credential $credential

            # Assert
            $plainTextPassword | Should -Be 'PlainTextPassword'
        }

        It 'Should throw an error for null credentials' {
            # Arrange
            $credential = New-Object System.Management.Automation.PSCredential ('Username')

            # Act / Assert
            { ConvertTo-PlainText -Credential $credential  -ErrorAction Stop} | Should -Throw
        }
    }
}
