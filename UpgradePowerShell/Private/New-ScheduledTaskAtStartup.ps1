<#
.SYNOPSIS
   Creates a new scheduled task to run at logon
.DESCRIPTION
   Creates a new scheduled task to run at logon
.EXAMPLE
   New-ScheduledTaskAtStartup -TaskScript 'Invoke-UpgradePowerShell.ps1 5' -TaskName 'UpgradePowerShell Task'
#>
function New-ScheduledTaskAtStartup
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $TaskScript,

        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        $TaskName
    )
    
    Write-Verbose -Message 'Creating new scheduled task for next logon attempt'
    
    $TaskDescription = "Running PowerShell script to upgrade PowerShell"
    $TaskCommand = "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe"
    #$TaskScript = "C:\Users\IEUser\Desktop\configuration.json"
    $TaskArg = "-WindowStyle Hidden -NonInteractive -Executionpolicy unrestricted -file $TaskScript"
    
    try{
        $TaskStartTime = [datetime]::Now.AddMinutes(1)
        $service = new-object -ComObject("Schedule.Service")
        $service.Connect()
        $rootFolder = $service.GetFolder("\")
        $TaskDefinition = $service.NewTask(0)
        $TaskDefinition.RegistrationInfo.Description = "$TaskDescription"
        $TaskDefinition.Settings.Enabled = $true
        $TaskDefinition.Settings.AllowDemandStart = $true
        $triggers = $TaskDefinition.Triggers
        #http://msdn.microsoft.com/en-us/library/windows/desktop/aa383915(v=vs.85).aspx
        $trigger = $triggers.Create(9)
        $trigger.Delay = 'PT1M'
        $trigger.Enabled = $true
        # http://msdn.microsoft.com/en-us/library/windows/desktop/aa381841(v=vs.85).aspx
        $Action = $TaskDefinition.Actions.Create(0)
        $action.Path = "$TaskCommand"
        $action.Arguments = "$TaskArg"
        #http://msdn.microsoft.com/en-us/library/windows/desktop/aa381365(v=vs.85).aspx
        $rootFolder.RegisterTaskDefinition("$TaskName",$TaskDefinition,6,"System",$null,5)

    }
    catch{
        $error[0]
    }
}