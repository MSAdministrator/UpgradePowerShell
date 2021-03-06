Param($Version)

$LogFile = 'C:\Users\IEUser\Desktop\log.log'

New-Item -Path $LogFile -ItemType File -Force | Out-Null

Add-Content -Path $LogFile -Value "$(Get-Module -Name UpgradePowerShell)"

try{
    #if (-not(Get-Module -Name UpgradePowerShell)){
        Import-Module UpgradePowerShell -Force
   # }
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

Add-Content -Path $LogFile -Value "$(Get-Module -Name UpgradePowerShell)"
Add-Content -Path $LogFile -Value "$(Get-Command -Name Upgrade*)"
#Write-Host $Version
try{

    Upgrade-PowerShell -Version $Version
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