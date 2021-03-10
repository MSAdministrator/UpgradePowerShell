#requires -Version 2
#Get public and private function definition files.
$psModulePath = $env:PSModulePath -split ';'
$UpgradePowerShellRoot = $PSScriptRoot
$ConfigurationDetails = Get-Content -Path "$UpgradePowerShellRoot\data\downloads.json" -ErrorAction Stop


$Helpers = Get-ChildItem -Path $UpgradePowerShellRoot\Private\*.ps1,$UpgradePowerShellRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue -Exclude 'Invoke-PowerShellUpgrade.ps1'


# Splitting these out because of PowerShell v2

#Dot source the files
Foreach($Files in $Helpers)
{
    Try
    {
        . $Files.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# PowerShell v2 does not have a ConvertFrom-Json CmdLet

$ConfigurationDetails = ConvertFrom-Json20 $ConfigurationDetails
Write-Verbose "-- $ConfigurationDetails, $UpgradePowerShellRoot"
Export-ModuleMember -Function 'Upgrade-PowerShell' #-Variable $ConfigurationDetails, $UpgradePowerShellRoot
