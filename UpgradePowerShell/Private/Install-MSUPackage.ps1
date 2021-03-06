<#
.SYNOPSIS
   Installs a downloaded MSU Package
.DESCRIPTION
   Installs a downloaded MSU Package
.EXAMPLE
   Install-MSUPackage -Path C:\some\download\path\file.msu
#>
function Install-MSUPackage
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path
    )

    Write-Verbose -Message 'Installing MSU Package'
    
    & wusa /install $Path /quiet /norestart    
}