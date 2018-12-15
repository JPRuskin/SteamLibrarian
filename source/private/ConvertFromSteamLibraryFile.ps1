function ConvertFromSteamLibraryFile {
    [CmdletBinding()]
    param
    (
        [Parameter(Position = 0, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateScript( {Test-Path -Path $_ -PathType Leaf})]
        [Alias('PSPath')]
        [String]$Path
    )
    process {
        ([string]$string = switch -File $Path -Regex {
                "AppState|LibraryFolders" {$FileType = $_.Replace('"', '')}
                '^\s*"(?<Key>\w+)"\s{2}"(?<Value>.*)"' {
                    '"' + $Matches.Key + '": "' + $Matches.Value + '",'
                    continue
                }
                '\s+{' {continue}
                '\s"' {$_ + ':{'}
                '\s}' {$_ + ','}
                default {$_}
            }) -replace ',\s*}', '}' | ConvertFrom-JSON | Add-Member -MemberType NoteProperty -Name PSPath -Value (Resolve-Path $Path) -PassThru
    }
}