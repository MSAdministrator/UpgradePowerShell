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
    
    if (Get-ChildItem -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowershell.bat"){
        Clear-StartupScript
    }

    $psModulePath = $env:PSModulePath -split ';'
    $StartupTask = "$($psModulePath[0])\UpgradePowerShell\Private\Invoke-PowerShellUpgrade.ps1 $Version"

$script = @"
c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -NonInteractive -Executionpolicy unrestricted -file $StartupTask
"@
    try{
        $batchScript = New-Item -Path "C:\Users\$($env:USERNAME)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\UpgradePowershell.bat" -ItemType File -Force
    }
    catch{
        $ErrorRecord = $Error[0]
        $Message = '{0} ({1}: {2}:{3} char:{4})' -f $ErrorRecord.Exception.Message,
                                                     $ErrorRecord.FullyQualifiedErrorId,
                                                     $ErrorRecord.InvocationInfo.ScriptName,
                                                     $ErrorRecord.InvocationInfo.ScriptLineNumber,
                                                     $ErrorRecord.InvocationInfo.OffsetInLine

        Add-Content -Path $LogFile -Value "$((Get-Date).ToString('yyyyMMddThhmmss')) [ERROR]: $Message"
    }

    try{
        Add-Content -Path $batchScript.FullName -Value $script -Force
    }
    catch
    {
        $ErrorRecord = $Error[0]
        $Message = '{0} ({1}: {2}:{3} char:{4})' -f $ErrorRecord.Exception.Message,
                                                     $ErrorRecord.FullyQualifiedErrorId,
                                                     $ErrorRecord.InvocationInfo.ScriptName,
                                                     $ErrorRecord.InvocationInfo.ScriptLineNumber,
                                                     $ErrorRecord.InvocationInfo.OffsetInLine

        Add-Content -Path $LogFile -Value "$((Get-Date).ToString('yyyyMMddThhmmss')) [ERROR]: $Message"
    }
}