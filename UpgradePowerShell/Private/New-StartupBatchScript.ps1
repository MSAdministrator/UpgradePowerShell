<#
.SYNOPSIS
   Generates a startup batch script and places it int he startup folder
.DESCRIPTION
   Generates a startup batch script and places it int he startup folder
.EXAMPLE
   New-StartupBatchScript -Version 5
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
    
    Write-Verbose -Message 'Generating startup script'


    if (Get-ChildItem -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowershell.bat"){
        Clear-StartupScript
    }

    $psModulePath = $env:PSModulePath -split ';'
    $StartupTask = "$($psModulePath[0])\UpgradePowerShell\Private\Invoke-PowerShellUpgrade.ps1 $Version"

$script = @"
c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -NonInteractive -Executionpolicy unrestricted -file $StartupTask
"@

    $batchScript = New-Item -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowershell.bat" -ItemType File -Force
    Add-Content -Path $batchScript.FullName -Value $script -Force
    
}