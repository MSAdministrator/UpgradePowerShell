<#
.SYNOPSIS
   Returns an object containing a download value map
.DESCRIPTION
   Returns an object containing a download value map
.EXAMPLE
   Get-DownloadObject
#>
function Get-DownloadObject
{
    [CmdletBinding()]
    Param()

    Write-Verbose -Message 'Getting download object map'
    
    $psModulePath = $env:PSModulePath -split ';'

    $ConfigurationDetails = Get-Content -Path "$($psModulePath[0])\UpgradePowerShell\data\downloads.json" -ErrorAction Stop 
    $jsonConfig = ConvertFrom-Json20 $ConfigurationDetails

   return $jsonConfig
}