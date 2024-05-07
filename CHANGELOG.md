# Changelog for BaseApiBuilder

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added 
- New function `Invoke-ApiRequest` to standarized API calling with the websession

## [0.1.0] - 2024-05-03

### Added

- Added reference to System.Web in `prefix.ps1` that imports assembly durning module import
- Added reference to System.Net.Http in `prefix.ps1` that imports assembly durning module import
- Added a new function to validate the api session `Test-ApiSession.ps1`

- Updated control flow for setting up the API Session
