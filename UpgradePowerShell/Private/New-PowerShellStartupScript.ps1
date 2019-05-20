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
function New-StartupBatchScript
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Version
    )

    $psModulePath = $env:PSModulePath -split ';'
    $StartupTask = "$($psModulePath[0])\UpgradePowerShell\Private\Invoke-PowerShellUpgrade.ps1 $Version"
    
$script = @"
c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -NonInteractive -Executionpolicy unrestricted -file $StartupTask
"@

    New-Item -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowerShell.bat" -Force

    Add-Content -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowerShell.bat" -Value $script -Force

}