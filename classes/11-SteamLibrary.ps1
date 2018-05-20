class SteamLibrary {
    # Properties
    [Alias('PSPath')]
    [string]$Path
    [SteamGame[]]$Games

    # Methods

    [SteamGame[]]static GetAllGames($Path) {
        return ((Get-ChildItem $Path\steamapps -Filter *.acf).FullName | ConvertFromSteamLibraryFile)
    }
    
    SteamLibrary () {
        $this.Path = FindSteamInstallation
        $this.Games = [SteamLibrary]::GetAllGames($this.Path)
    }

    SteamLibrary ($Path) {
        $this.Path = $Path
        $this.Games = [SteamLibrary]::GetAllGames($this.Path)
    }
}