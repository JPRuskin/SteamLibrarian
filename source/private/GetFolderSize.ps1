function GetFolderSize {
    param(
        [Parameter(ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, Mandatory = $true)]
        [Alias('PSPath')][ValidateScript( {Test-Path -LiteralPath $_ -PathType Container})]
        $Path
    )
    begin {
        $objFSO = New-Object -com Scripting.FileSystemObject
    }
    process {
        $objFSO.GetFolder($Path).Size
    }
    end {
        $objFSO = $null
    }
}
