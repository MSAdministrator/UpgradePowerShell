function Clear-StartupScript
{
    [CmdletBinding()]
    Param()

    Remove-Item -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowershell.bat" -Force
}