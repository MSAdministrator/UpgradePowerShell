function Set-UpgradeVersionConfiguration
{
    [CmdletBinding()]
    Param(
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Version,

        # Force switch used for backwards compatability and will force upgrade configuration file
        [Parameter(Mandatory=$false,
                   Position=1,
                   ParameterSetName='Parameter Set 1')]
        [switch]$Force
    )

    if ($Force){
        New-Item -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -ItemType File -Force
        Add-Content -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -Value $Version -Force
    }

    if (-not (Get-Content -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -ErrorAction SilentlyContinue)){
        New-Item -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -ItemType File -Force
        Add-Content -Path "$($env:TEMP)\UpgradePowerShell\configuration.json" -Value $Version -Force
    }
}