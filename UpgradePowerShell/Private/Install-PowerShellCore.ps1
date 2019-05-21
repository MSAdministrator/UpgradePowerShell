
Function Install-PowerShellCore {
    Param(
        # Use -Preview switch to install pre release version of PowerShell core.
        [Parameter()]
        [switch]$Preview
    )
    function InstallForWindows {
        Param(
            $Release
        )
        $OutputPath = "$env:HOMEPATH\Downloads"

        if ( [Environment]::Is64BitOperatingSystem ) {
            $FilterCriteria = { ($_.Name -match '.msi') -and ($_.Name -match "x64") }
        }
        else {
            $FilterCriteria = { ($_.Name -match '.msi') -and ($_.Name -match "x86") }
        }

        Write-Host "Latest released packages are below"
        $RequiredPackage = $Release | Where-Object $FilterCriteria

        $DownloadPath = "$OutputPath\$($RequiredPackage.Name)"

        Write-Host "Downloading latest release $($RequiredPackage.Name) "
        Invoke-WebRequest $RequiredPackage.Browser_Download_Url -Out "$DownloadPath" -ErrorAction Stop


        Write-Host "Installing $($RequiredPackage.Name)"
        @"
msiexec /i $DownloadPath /quiet
start pwsh
"@ | Out-File -FilePath $env:Temp\UpdatePwsh.bat
        Start-Process -FilePath $env:Temp\UpdatePwsh.bat -ErrorAction Stop

        Write-Host -ForegroundColor Green "Have fun using Pwsh ..."


    }
    try {

        $Script:pwsh = 'pwsh'
        $ReleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases"
        $MetadataUrl = "https://raw.githubusercontent.com/PowerShell/PowerShell/master/tools/metadata.json"
        $CurrentVersion = $PSVersionTable.PSVersion -as [string]

        Write-Host "Installed pwsh version is $CurrentVersion"
        Write-Host "Fetching latest releases"

        $ReleaseMetadata = Invoke-RestMethod -Uri $MetadataUrl -ErrorAction Stop

        If ( $Preview.IsPresent ) {
            $ReleseToDownload = $ReleaseMetadata.NextReleaseTag
        }
        else {
            $ReleseToDownload = $ReleaseMetadata.StableReleaseTag
        }

        $Releases = Invoke-RestMethod -Uri $ReleaseUrl
        $LatestRelease = ($Releases | Where-Object -FilterScript { $_.Tag_Name -eq $ReleseToDownload }).assets | Select-Object -Property Name, Browser_Download_Url -ErrorAction Stop

        if(($null -eq $LatestRelease)){
           Write-Warning -Message "$ReleseToDownload is not yet available, try a different version"
           break
        }

        If ( $LatestRelease.Name -like "*$CurrentVersion*" ) {
            Write-Host "Currenlty executing pwsh is with latest available version"
        }
        else {
            InstallForWindows -Release $LatestRelease
            Stop-Process -Name pwsh -Force -ErrorAction Stop
        }

    }
    Catch {
        Throw "pwsh update failed due to $_"
    }
}