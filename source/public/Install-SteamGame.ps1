function Install-SteamGame {
    <#
        .Synopsis
            Prompts Steam to install a game

        .Notes
            - Tab completion works nicely on the Name parameter

        .Example
            Install-SteamGame -Name "Team Fortress 2"

        .Example
            Install-SteamGame -ID 440
    #>
    [CmdletBinding(DefaultParameterSetName = "Name")]
    param(
        [ArgumentCompleter({
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
        })]
        [Parameter(Mandatory, ParameterSetName = "Name", Position = 0)]
        [ValidateScript({
            if ($_ -in (Get-SteamGameList).name) {
                $true
            } else {
                throw "'$_' is not a valid Steam Application Name."
            }
        })]
        [string]$Name,

        [Parameter(Mandatory, ParameterSetName = "ID", Position = 0)]
        [ValidateScript({
            if ($_ -in (Get-SteamGameList).appid) {
                $true
            } else {
                throw "ID '$_' is not a valid Steam Application ID."
            }
        })]
        [Alias("ApplicationId")]
        [int]$ID
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq "Name") {
            $ID = (Get-SteamGameList).Where{$_.Name -eq $Name}.appid
            Write-Debug "'$($Name)' has ID '$($ID)'"
        }

        [SteamGame]::Install($ID)
    }
}