function Add-SteamLibrary {
    <#
        .Synopsis
            Adds a new library location to Steam

        .Example
            Add-SteamLibrary -Path E:\SteamLibrary
    #>
    [CmdletBinding()]
    param(
        # Path to a folder
        [Parameter(Mandatory)]
        [Alias('PSPath')]
        [string[]]$Path,

        # Path to the Steam installation to add the library to, e.g. C:\Program Files (x86)\Steam
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            $false -notin @(
                # The path should contain the Steam executable
                [bool](Get-ChildItem -Path $_ -Filter 'steam.exe')

                # The path should be a directory
                Test-Path -Path $_ -PathType Container
            )
        })]
        [IO.DirectoryInfo]$SteamInstallation = (FindSteamInstallation)
    )
    begin {
        $LibraryFile = Join-Path $SteamInstallation 'steamapps\libraryfolders.vdf'
    }
    process {
        foreach ($Library in $Path) {
            $LibraryData = ConvertFromSteamLibraryFile -Path $LibraryFile
            $Libraries = ($LibraryData.psobject.Properties.Where{$_.Name -Match '\d+'} | Select Name,Value) + [PSCustomObject]@{Name = 0; Value = $SteamInstallation}

            if (-not (Test-Path -Path $Library -PathType Container)) {
                Write-Verbose "Creating Library Structure at '$($Library)'"
                NewSteamLibraryStructure -Path $Library
            }

            if ($Library -notin $Libraries.Value) {
                $NewIndex = [int]($Libraries.Name | Sort -Descending)[0] + 1
                $NewLine  = "`t""$($NewIndex)""`t`t$(ConvertTo-Json $Library)"

                $NewContent = switch -Regex -File $LibraryFile {
                    "^\W+`"$($NewIndex-1)`"" {
                        $_
                        $NewLine
                        Continue
                    }
                    default {$_}
                }
                $NewContent | Set-Content -Path $LibraryFile -Encoding utf8

                Write-Verbose "Adding '$($Library)' to '$($LibraryFile)'"
            } else {
                Write-Verbose "Library '$($Library)' is already present in '$($LibraryFile)'"
            }
        }
    }
    end {
        Write-Verbose "Steam may need to be restarted"
    }
}