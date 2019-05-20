<#
.SYNOPSIS
   Clears the UpgradePowerShell startup script
.DESCRIPTION
   Clears the UpgradePowerShell startup script
.EXAMPLE
   Clear-StartupScript
#>
function Clear-StartupScript
{
    [CmdletBinding()]
    Param()

    Write-Verbose -Message 'Clearing UpgradePowerShell Startup Script'
    Remove-Item -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowershell.bat" -Force
}