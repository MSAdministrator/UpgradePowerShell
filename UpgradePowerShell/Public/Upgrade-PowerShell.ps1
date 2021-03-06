<#
.Synopsis
   This function is used to UpgradePowerShell to the specified version
.DESCRIPTION
   Use this function to upgrade from PowerShell v2 to V5!
.EXAMPLE
    Upgrade-PowerShell -Version 3
#>
function Upgrade-PowerShell
{
    [CmdletBinding()]
    Param
    (
        # The version you want to upgrade to
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet(3,4,5,6)]
        $Version,

        # The version you want to upgrade to
        [Parameter(Position=1,ParameterSetName='Parameter Set 1')]
        [switch]$Preview,

        # Force switch used for backwards compatability and will force upgrade configuration file
        [Parameter(Mandatory=$false,
                   Position=2,
                   ParameterSetName='Parameter Set 1')]
        [switch]$Force
    )

    if($Preview.IsPresent -and ($Version -lt 6)){
        Write-Warning -Message "Preview option is supported only from version 6"
        break
    }

    if (-not (Get-Module -Name UpgradePowerShell)){
        Import-Module UpgradePowerShell -Force
    }

    if ([IntPtr]::size -eq 8)
    {
        $OSBitness = 'x64'
    }
    else
    {
        $OSBitness = 'x86'
    }

    if (($Version -le $PSVersionTable.PSVersion.Major) -and ($Version -lt 6))
    {
        Write-Warning -Message "You are currently running PowerShell Version $($PSVersionTable.PSVersion.Major)"
        Write-Warning -Message "Please select a PowerShell version that is higher than your current version"
        break
    }
    else
    {
        if ($Force){
            Set-UpgradeVersionConfiguration -Version $Version -Force
        }
        else{
            Set-UpgradeVersionConfiguration -Version $Version
        }

        if ($(Get-UpgradeVersionConfiguration) -ge 6){
            Install-PowerShellCore -Preview:$Preview.IsPresent
            break
        }

        $props = @{}

        $jsonConfig = Get-DownloadObject

        $downloadUrl = $()

        if ($(Get-UpgradeVersionConfiguration) -eq 5)
        {
            if ($PSVersionTable.PSVersion.Major -eq 4){
                $downloadUrl = $($jsonConfig.Item($('WMF5')).Item($(Get-OperatingSystemVersion)).Item($($OSBitness)))
                Clear-StartupScript
            }
            elseif ($PSVersionTable.PSVersion.Major -eq 3){
                Add-Content C:\Users\IEUser\Desktop\log.log -Value "$($($jsonConfig.Item($('WMF4')).Item($(Get-OperatingSystemVersion)).Item($($OSBitness))))"
                $downloadUrl = $($jsonConfig.Item($('WMF4')).Item($(Get-OperatingSystemVersion)).Item($($OSBitness)))
                New-StartupBatchScript -Version 5
            }
            else{
                $downloadUrl = $($jsonConfig.Item($('WMF3')).Item($(Get-OperatingSystemVersion)).Item($($OSBitness)))
                New-StartupBatchScript -Version 4
            }
        }

        if ($(Get-UpgradeVersionConfiguration) -eq 4){
            if ($PSVersionTable.PSVersion.Major -eq 3){
                $downloadUrl = $($jsonConfig.Item($('WMF4')).Item($(Get-OperatingSystemVersion)).Item($($OSBitness)))
            }
            else
            {
                $downloadUrl = $($jsonConfig.Item($('WMF3')).Item($(Get-OperatingSystemVersion)).Item($($OSBitness)))
                New-StartupBatchScript -Version 4
            }
        }

        if ($(Get-UpgradeVersionConfiguration) -eq 3){
            $downloadUrl = $($jsonConfig.Item($('WMF3')).Item($(Get-OperatingSystemVersion)).Item($($OSBitness)))
        }

        Write-Verbose -Message 'Getting download URL'
        $DownloadPath = "$env:TEMP\" + ($($downloadUrl).Split('/')[-1])
        Write-Verbose -Message 'Downloading appropriate WMF version for upgrade'

        (New-Object System.Net.WebClient).DownloadFile($downloadUrl, $DownloadPath)

        Start-Sleep -Seconds 10
        Install-MSUPackage -Path $DownloadPath
        Start-Sleep -Seconds 5

        Restart-Computer -Force
    }
}