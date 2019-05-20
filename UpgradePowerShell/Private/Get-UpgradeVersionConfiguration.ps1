<#
.SYNOPSIS
   Return value from UpgradePowerShell Version Configuration file
.DESCRIPTION
   Return value from UpgradePowerShell Version Configuration file
.EXAMPLE
   Get-UpgradeVersionConfiguration
#>
function Get-UpgradeVersionConfiguration
{
    [CmdletBinding()]
    Param()

    Write-Verbose -Message 'Getting upgrade version value'
    
    if (Get-ChildItem -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -ErrorAction SilentlyContinue){
        return Get-Content -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -ReadCount 1
    }
}