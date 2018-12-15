class SteamLibrary {
    # Properties
    [Alias('PSPath')]
    [string]$Path
    [SteamGame[]]$Games
    [uint64]$SizeOnDisk

    # Methods

    [SteamGame[]]static GetAllGames($Path) {
        return ((Get-ChildItem $Path\steamapps -Filter *.acf).FullName | ConvertFromSteamLibraryFile)
    }
    
    SteamLibrary () {
        $this.Path = FindSteamInstallation
        $this.Games = [SteamLibrary]::GetAllGames($this.Path)
        $this.SizeOnDisk = GetFolderSize -Path $this.Path
    }

    SteamLibrary ($Path) {
        $this.Path = $Path
        $this.Games = [SteamLibrary]::GetAllGames($this.Path)
        $this.SizeOnDisk = GetFolderSize -Path $this.Path
    }
}