@{
    ModuleVersion          = "0.0.1"

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules        = @()

    # Functions to export. Populated by Optimize-Module during the build step.
    # For best performance, do not use wildcards and do not delete this entry!
    # Use an empty array if there is nothing to export.
    FunctionsToExport      = @()

    # Cmdlets to export.
    # For best performance, do not use wildcards and do not delete this entry!
    # Use an empty array if there is nothing to export.
    CmdletsToExport        = @()

    # Aliases to export.
    # For best performance, do not use wildcards and do not delete this entry!
    # Use an empty array if there is nothing to export.
    AliasesToExport        = @()

    # ID used to uniquely identify this module
    GUID                   = '9950C257-9F08-419A-87A4-D77C5A986593'
    Description            = 'A module to assist with Steam Library administration'

    # The main script or binary module that is automatically loaded as part of this module
    RootModule             = 'SteamLibrarian.psm1'

    # Common stuff for all our modules:
    Author                 = 'James Ruskin'
    Copyright              = "Copyright 2018 James Ruskin"

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '5.1'
    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = '4.0'
    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion             = '4.0.30319'
}