#requires -Version 2
#Get public and private function definition files.
$psModulePath = $env:PSModulePath -split ';'
$UpgradePowerShellRoot = "$($psModulePath[0])\UpgradePowerShell" 
$ConfigurationDetails = Get-Content -Path "$UpgradePowerShellRoot\data\downloads.json" -ErrorAction Stop 


$Public  = Get-ChildItem -Path $UpgradePowerShellRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue
$Private = Get-ChildItem -Path $UpgradePowerShellRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue -Exclude 'Invoke-PowerShellUpgrade.ps1'


# Splitting these out because of PowerShell v2

#Dot source the files
Foreach($import in $Public)
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

Foreach($import in $Private)
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

# PowerShell v2 does not have a ConvertFrom-Json CmdLet

$ConfigurationDetails = ConvertFrom-Json20 $ConfigurationDetails

Export-ModuleMember -Function $Public.Basename -Variable $ConfigurationDetails, $UpgradePowerShellRoot
