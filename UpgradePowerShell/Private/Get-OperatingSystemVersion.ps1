<#
.SYNOPSIS
   Returns the operating system version
.DESCRIPTION
   Returns the operating system version
.EXAMPLE
   Get-OperatingSystemVersion
#>
function Get-OperatingSystemVersion
{
    [CmdletBinding()]
    Param()

    Write-Verbose -Message 'Getting operating system version'

    [Version]$OSVersion = (Get-WmiObject -class Win32_OperatingSystem).Version
    $OSType = (Get-WmiObject -Class Win32_OperatingSystem -Property ProductType).ProductType

    switch ("$($OSVersion.Major).$($OSVersion.Minor)")
    {
        '6.1'  { if($OSType -eq 1){ Write-Output 'Win7'  } else{ Write-Output 'Server2008R2' } }
        '6.2'  { if($OSType -eq 1){ Write-Output 'Win81' } else{ Write-Output 'Server2012'   } }
        '6.3'  { if($OSType -eq 1){ Write-Output 'Win81' } else{ Write-Output 'Server2012R2' } }
        '10.0' { if($OSType -eq 1){ Write-Output 'Win10' } else{ Write-Output 'Server2016'   } }
    }
}