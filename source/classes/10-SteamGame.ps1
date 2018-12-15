class SteamGame {
    # Properties

    [int]$ApplicationID
    [int]$Universe
    [string]$Name
    [StateFlags[]]$StateFlags
    [string]$installdir
    [datetime]$LastUpdated
    [UpdateResult]$UpdateResult
    [uint64]$SizeOnDisk
    [int]$buildid
    [string]$LastOwner
    [uint64]$BytesToDownload
    [uint64]$BytesDownloaded
    [AutoUpdateBehavior]$AutoUpdateBehavior
    [AllowOtherDownloads]$AllowOtherDownloadsWhileRunning
    [PSObject]$UserConfig
    [PSObject]$InstalledDepots
    [PSObject]$MountedDepots

    [ValidatePattern("\.acf$")]
    hidden [string]$PSPath
    hidden [string]$PSParentPath
    [string]$InstallDirectory

    hidden [bool]$Installed

    # Methods

    [string]static GetInstallDirectory($AcfPath, $installdir) {
        return (Join-Path (Split-Path -Path $AcfPath -Parent) "common\$installdir")
    }

    [void]static Launch($ApplicationID) {
        & (FindSteamInstallation -Exe) -applaunch $ApplicationID
    }

    [void]static Install($ApplicationID) {
        # Turns out the nicest way to Install an application is to try and launch it.
        [SteamGame]::Launch($ApplicationID)
    }

    [void]Install() {
        [SteamGame]::Launch($this.ApplicationID)
    }

    [void]Launch() {
        [SteamGame]::Launch($this.ApplicationID)
    }

    [uint64]GetInstallDirectorySize() {
        if (Test-Path $this.InstallDirectory) {
            return (GetFolderSize -Path $this.InstallDirectory)
        } else {
            $this.Installed = $false
            return $null
        }
    }

    # Constructors

    SteamGame ([string]$Path) {
        $Game = ConvertFromSteamLibraryFile -Path $Path

        $this.ApplicationID = $Game.AppId
        $this.Universe = $Game.Universe
        $this.Name = $Game.name
        $this.StateFlags = $Game.StateFlags
        $this.installdir = $Game.installdir
        $this.LastUpdated = (Get-Date '01/01/1970').AddSeconds($Game.LastUpdated)
        $this.UpdateResult = $Game.UpdateResult
        $this.SizeOnDisk = $Game.SizeOnDisk
        $this.buildid = $Game.buildid
        $this.LastOwner = $Game.LastOwner
        $this.BytesToDownload = $Game.BytesToDownload
        $this.BytesDownloaded = $Game.BytesDownloaded
        $this.AutoUpdateBehavior = $Game.AutoUpdateBehavior
        $this.AllowOtherDownloadsWhileRunning = $Game.AllowOtherDownloadsWhileRunning
        $this.UserConfig = $Game.UserConfig
        $this.InstalledDepots = $Game.InstalledDepots
        $this.MountedDepots = $Game.MountedDepots

        $this.PSPath = $Path
        $this.PSParentPath = Split-Path -Path $this.PSPath -Parent
        $this.InstallDirectory = [SteamGame]::GetInstallDirectory($Path, $this.installdir)
    }

    SteamGame (
        [int]$appid,
        [int]$Universe,
        [string]$name,
        [StateFlags]$StateFlags,
        [string]$installdir,
        [int]$LastUpdated,
        [UpdateResult]$UpdateResult,
        [uint64]$SizeOnDisk,
        [int]$buildid,
        [string]$LastOwner,
        [uint64]$BytesToDownload,
        [uint64]$BytesDownloaded,
        [AutoUpdateBehavior]$AutoUpdateBehavior,
        [AllowOtherDownloads]$AllowOtherDownloadsWhileRunning,
        [PSObject]$UserConfig,
        [PSObject]$InstalledDepots,
        [PSObject]$MountedDepots,
        [String]$PSPath
    ) {
        # Everything we take from the ACF
        $this.ApplicationID = $appid
        $this.Universe = $Universe
        $this.Name = $name
        $this.StateFlags = $StateFlags
        $this.installdir = $installdir
        $this.LastUpdated = (Get-Date '01/01/1970').AddSeconds($LastUpdated)
        $this.UpdateResult = $UpdateResult
        $this.SizeOnDisk = $SizeOnDisk
        $this.buildid = $buildid
        $this.LastOwner = $LastOwner
        $this.BytesToDownload = $BytesToDownload
        $this.BytesDownloaded = $BytesDownloaded
        $this.AutoUpdateBehavior = $AutoUpdateBehavior
        $this.AllowOtherDownloadsWhileRunning = $AllowOtherDownloadsWhileRunning
        $this.UserConfig = $UserConfig
        $this.InstalledDepots = $InstalledDepots
        $this.MountedDepots = $MountedDepots

        # Calculated values
        $this.PSPath = (Resolve-Path $PSPath)
        $this.PSParentPath = Split-Path -Path $this.PSPath -Parent
        $this.InstallDirectory = [SteamGame]::GetInstallDirectory($this.PSPath, $this.installdir)
    }

    SteamGame ([PSCustomObject]$Content) {
        # Everything we take from the ACF
        $this.ApplicationID = $Content.appid
        $this.Universe = $Content.Universe
        $this.name = $Content.name
        $this.StateFlags = $Content.StateFlags
        $this.installdir = $Content.installdir
        $this.LastUpdated = (Get-Date '01/01/1970').AddSeconds($Content.LastUpdated)
        $this.UpdateResult = $Content.UpdateResult
        $this.SizeOnDisk = $Content.SizeOnDisk
        $this.buildid = $Content.buildid
        $this.LastOwner = $Content.LastOwner
        $this.BytesToDownload = $Content.BytesToDownload
        $this.BytesDownloaded = $Content.BytesDownloaded
        $this.AutoUpdateBehavior = $Content.AutoUpdateBehavior
        $this.AllowOtherDownloadsWhileRunning = $Content.AllowOtherDownloadsWhileRunning
        $this.UserConfig = $Content.UserConfig
        $this.InstalledDepots = $Content.InstalledDepots
        $this.MountedDepots = $Content.MountedDepots

        # Calculated values
        $this.PSPath = (Resolve-Path $Content.PSPath)
        $this.PSParentPath = Split-Path -Path $this.PSPath -Parent
        $this.InstallDirectory = [SteamGame]::GetInstallDirectory($this.PSPath, $this.installdir)
    }
}