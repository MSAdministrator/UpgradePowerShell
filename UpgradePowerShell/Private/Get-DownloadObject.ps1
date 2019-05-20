function Get-DownloadObject
{
    [CmdletBinding()]
    Param()

    $psModulePath = $env:PSModulePath -split ';'

    $ConfigurationDetails = Get-Content -Path "$($psModulePath[0])\UpgradePowerShell\data\downloads.json" -ErrorAction Stop 
    $jsonConfig = ConvertFrom-Json20 $ConfigurationDetails

   return $jsonConfig
}