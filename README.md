# SteamLibrarian

SteamLibrarian is a module for managing Steam games on a local machine. It was originally written to enable moving games between drives and handling junction-links.

It has mostly been surpassed by Valve gradually adding features to Steam.

## Building SteamLibrarian

To build SteamLibrarian locally, run the following code:

```PowerShell
Build-Module -Path $ModulePath -Output $ModulePath\$Version -ModuleVersion $Version
```

## Testing SteamLibrarian

To test SteamLibrarian locally, run the following code:

```PowerShell
Import-Module $ModulePath

$TestParameters = @{
    Script = $ModulePath\tests
    CodeCoverage = (Get-ChildItem $ModulePath\$Version -Filter *.psm1).FullName
}

Invoke-Pester @TestParameters
```

## Version

| Version | Changes                |
| ------- | :--------------------- |
|   0.0.1 | Basic module structure |