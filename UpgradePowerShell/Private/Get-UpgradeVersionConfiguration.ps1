function Get-UpgradeVersionConfiguration
{
    [CmdletBinding()]
    Param()

    if (Get-ChildItem -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -ErrorAction SilentlyContinue){
        return Get-Content -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -ReadCount 1
    }
}