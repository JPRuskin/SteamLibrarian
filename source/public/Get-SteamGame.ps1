function Get-SteamGame {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ID')]
        [Alias('AppId')]
        [string]$ID,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [Alias('PSPath')]
        [string]$Path
    )
    DynamicParam {
        $ParameterName = 'Name'

        $RuntimeParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

        # Create the collection of attributes
        $AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

        # Create and set the parameters' attributes
        $ParameterAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.ParameterSetName = 'Name'

        # Add the attributes to the attributes collection
        $AttributeCollection.Add($ParameterAttribute)

        # Generate and set the ValidateSet
        [string[]]$arrSet = ($script:InstalledGames = (Get-SteamLibrary).Games).Name
        $ValidateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new($arrSet)

        # Add the ValidateSet to the attributes collection
        $AttributeCollection.Add($ValidateSetAttribute)

        # Create and return the dynamic parameter
        $RuntimeParameter = [System.Management.Automation.RuntimeDefinedParameter]::new($ParameterName, [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
        return $RuntimeParameterDictionary
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Name' {[SteamGame[]]$script:InstalledGames.Where{$_.Name -eq $PSBoundParameters.Name}}
            'ID' {[SteamGame[]]$script:InstalledGames.Where{$_.ApplicationID -eq $ID}}
            'Path' {[SteamGame]::New($Path)}
            'All' {[SteamGame[]]$script:InstalledGames}
        }
    }
}