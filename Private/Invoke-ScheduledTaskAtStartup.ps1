function Invoke-ScheduledTaskAtStartup
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
        $UpgradePowerShellPath,

        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        $TaskName
    )

    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($task -ne $null)
    {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false 
    }

    # TODO: EDIT THIS STUFF AS NEEDED...
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File $($UpgradePowerShellPath)"
    $trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay 00:00:30
    $settings = New-ScheduledTaskSettingsSet -Compatibility Win8

    $principal = New-ScheduledTaskPrincipal -UserId 'NETWORK SERVICE' -LogonType ServiceAccount -RunLevel Highest

    $definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description "Run $($TaskName) at startup"

    Register-ScheduledTask -TaskName $TaskName -InputObject $definition

    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

    # TODO: LOG AS NEEDED...
    if ($task -ne $null)
    {
        Write-Output "Created scheduled task: '$($task.ToString())'."
    }
    else
    {
        Write-Output "Created scheduled task: FAILED."
    }
}
