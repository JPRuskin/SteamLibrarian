function Get-SteamGameList {
    if (-not $script:AllSteamGames) {
        $script:AllSteamGames = (Invoke-RestMethod -Uri https://api.steampowered.com/ISteamApps/GetAppList/v2/).applist.apps
    }
    $script:AllSteamGames
}