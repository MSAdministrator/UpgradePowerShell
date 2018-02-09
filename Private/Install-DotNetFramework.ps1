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
function Install-DotNetFramework
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $DownloadPath
    )

    Write-Verbose -Message 'Current .NET Framework version is less than 3.5'

    Write-Verbose -Message 'Downloading .NET Framework 4'

    (New-Object System.Net.WebClient).DownloadFile($DownloadPath,"$env:TEMP\dotNetFx40_Full_setup.exe")

    Write-Verbose -Message 'Installing .NET Framework 4'

    Start-Process "$env:TEMP\dotNetFx40_Full_setup.exe" -ArgumentList "/s" -Wait
}