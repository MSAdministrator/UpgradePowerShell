#requires -Version 2
#Get public and private function definition files.
$UpgradePowerShellRoot = $($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(‘.\’))
$ConfigurationDetails = @( Get-Content -Path $UpgradePowerShellRoot\Config\Configuration.json -ErrorAction Stop | ConvertFrom-Json )
$ScheduledTaskName = "UpgradePowerShell Task"

$Public  = @( Get-ChildItem -Path $UpgradePowerShellRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $UpgradePowerShellRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename -Variable $ConfigurationDetails, $UpgradePowerShellRoot, $ScheduledTaskName
