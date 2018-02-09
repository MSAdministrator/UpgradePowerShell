<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Upgrade-PowerShell
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("3", "4", "5")]
        $Version
    )

    if ($Version -le $PSVersionTable.PSVersion.Major)
    {
        Write-Warning -Message "You are currently running PowerShell Version $($PSVersionTable.PSVersion.Major)"
        Write-Warning -Message "Please select a PowerShell version that is higher than your current version"
        break
    }

    if ([IntPtr]::size -eq 8)
    {
        $OSBitness = 'x64'
    }
    else
    {
        $OSBitness = 'x86'
    }

    if (Get-NetFrameworkVersion -lt '3.5')
    {   
        $task = Get-ScheduledTask -TaskName $ScheduledTaskName -ErrorAction SilentlyContinue
        if ($task -ne $null)
        {
            Unregister-ScheduledTask -TaskName $ScheduledTaskName -Confirm:$false 
        }
        else
        {
            Invoke-ScheduledTaskAtStartup -UpgradePowerShellPath $UpgradePowerShellRoot -TaskName $ScheduledTaskName
            Install-DotNetFramework -DownloadPath "$($ConfigurationDetails.DotNet4)"

            # probably have to reboot now.
        }
    }
    
    $props = @{}

    # if we've reached here, then we need to set our scheduled task and then download and install
    # Then reboot

    switch ($Version)
    {
        '3' { $props = @{
                'PSVersion' = 'WMF3'
                'OSVersion' = Get-OperatingSystemVersion
                'OSType'    = $OSBitness
                }              
            }
        '4' { $props = @{
                'PSVersion' = 'WMF4'
                'OSVersion' = Get-OperatingSystemVersion
                'OSType'    = $OSBitness
                }
            }
        '5' { $props = @{
                'PSVersion' = 'WMF5'
                'OSVersion' = Get-OperatingSystemVersion
                'OSType'    = $OSBitness
                }
            }
    }

    Write-Verbose -Message 'Getting download URL'

    $DownloadURL = Get-WMFUri @props
    $DownloadPath = "$env:TEMP\($DownloadURL.Split('/')[-1])"

    Write-Verbose -Message 'Downloading appropriate WMF version for upgrade'

    (New-Object System.Net.WebClient).DownloadFile($DownloadURL, $DownloadPath)

    Install-MSUPackage -Path $DownloadURL

}