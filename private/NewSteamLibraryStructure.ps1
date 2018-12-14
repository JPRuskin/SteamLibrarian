function NewSteamLibraryStructure {
    [CmdletBinding()]
    param(
        # Path to create structure under
        [Parameter(Mandatory)]
        [string]$Path
    )
    try {
        $null = New-Item -Path $Path -Type Directory
        $null = New-Item -Path (Join-Path $Path 'steamapps') -Type Directory
        Copy-Item -Path "$(FindSteamInstallation)\steam.dll" -Destination "$Path\steam.dll"
    } catch {
        Write-Error "Adding the Steam Library Structure to '$($Path)' failed.`n$_"
    }
}