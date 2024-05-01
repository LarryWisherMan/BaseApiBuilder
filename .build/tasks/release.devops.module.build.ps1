param
(
    # Base directory of all output (default to 'output')
    [Parameter()]
    [string]
    $OutputDirectory = (property OutputDirectory (Join-Path $BuildRoot 'output')),

    [Parameter()]
    [string]
    $ProjectName = (property ProjectName ''),

    [Parameter()]
    [string]
    $AZProjName = (property AZProjName 'RCARPEN-ScriptShare'), 

    [Parameter()]
    [System.String]
    $ModuleVersion = (property ModuleVersion ''),

    [Parameter()]
    [string]
    $PackageToken = (property PackageToken ''),

    [Parameter()]
    [string]
    $OrgName = (property OrgName 'TimeForSupport'),

    [Parameter()]
    $ArtifactFeed = (property AritfactFeed 'ScriptShare'),

    [Parameter()]
    [string]
    $ArtifactPublishSource = (property ArtifactPublishSource "https://pkgs.dev.azure.com/$OrgName/_packaging/$ArtifactFeed/nuget/v2/"),

    [Parameter()]
    $SkipPublish = (property SkipPublish '')
)

# Synopsis: Upload Nuget package to Azure Artifacts
task publish_nupkg_to_azureartifacts -if ($PackageToken -and (Get-Command -Name 'nuget' -ErrorAction 'SilentlyContinue')) {
    #. Set-SamplerTaskVariable

    # Force unregistering the nuget source
    $null = &nuget sources remove -name $ArtifactFeed

    # Register nuget source
    $response = nuget sources add -Name $ArtifactFeed -Source $ArtifactPublishSource -username "AzureDevOpsModuleBuilder" -password $PackageToken

    #dotnet nuget add source $ArtifactPublishSource --name $ArtifactFeed --username AzureDevOpsModuleBuilder --password $PackageToken --store-password-in-clear-text
    #$PackageToken = "***REMOVED***"

    # find Module's nupkg
    $PackageToRelease = Get-ChildItem -Path (Join-Path -Path $OutputDirectory -ChildPath "*.nupkg")

    if (-not $SkipPublish) {
        $response = &nuget push -Source $ArtifactFeed -ApiKey "AzureDevOpsApiKey" $PackageToRelease

        #dotnet nuget push $PackageToRelease --source $ArtifactFeed --api-key "AzureDevOpsApiKey"

    }

    Write-Build Green "Response = " + $response
    $null = &nuget sources remove -name $ArtifactFeed
}