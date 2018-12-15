function Get-SteamLibrary {
    param(
        [Parameter(ValueFromPipeline)]
        [ValidateScript( {
                $false -notin @(
                    # The path should contain the Steam executable
                    [bool](Get-ChildItem -Path $_ -Filter 'steam.exe')

                    # The path should be a directory
                    Test-Path -Path $_ -PathType Container
                )
            })]
        [IO.DirectoryInfo]$SteamInstallation = (FindSteamInstallation)
    )
    process {
        [SteamLibrary]::new($SteamInstallation)

        $LibraryFile = ConvertFromSteamLibraryFile (Join-Path $SteamInstallation 'steamapps\libraryfolders.vdf')
        $LibraryFile.psobject.Properties.Where{$_.Name -Match '\d+'} | % {
            [SteamLibrary]::new($_.Value)
        }
    }
}