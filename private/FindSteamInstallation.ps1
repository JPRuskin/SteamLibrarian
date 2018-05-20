function FindSteamInstallation {
    [CmdletBinding()]
    param(
        [switch]$Exe
    )
    try {
        $Folder = (Get-ItemProperty "HKLM:\Software$(if(Test-Path 'HKLM:\SOFTWARE\Wow6432Node'){'\Wow6432Node'})\Valve\Steam" -ErrorAction Stop).InstallPath
    } catch {
        Write-Error 'Finding Steam Registry entries failed. Is Steam properly installed?'
        throw 'failed'
    }
    if ($PSBoundParameters.ContainsKey('Exe')) {
        Join-Path $Folder 'Steam.exe'
    } else {
        $Folder
    }
}