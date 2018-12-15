function Install-SteamGame {
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param(
        [Parameter(Mandatory, ParameterSetName = "Name")]
        [ValidateScript({$_ -in (Get-SteamGameList).name})]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = "ID")]
        [ValidateScript({$_ -in (Get-SteamGameList).appid})]
        [Alias("ApplicationId")]
        [int]$ID
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq "Name") {
            $ID = (Get-SteamGameList).Where{$_.Name -eq $Name}.appid
        }

        [SteamGame]::Install($ID)
    }
}

Register-ArgumentCompleter -CommandName Install-SteamGame -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)
    $MatchString = "^$($wordToComplete -replace '^["'']' -replace "[^A-z0-9]",'.*?')"
    Write-Debug "Finding games that match '$MatchString'"

    $MatchList = [System.Collections.ArrayList]::new()
    (Get-SteamGameList).name | % {
        if ($_ -match $MatchString) {$null = $MatchList.Add($_)}
    }

    Write-Debug "Found $($MatchList.Count) games that match '$($MatchString)'"
    $MatchList | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new("`"$_`"", $_, 'ParameterValue', $_)
    }
}