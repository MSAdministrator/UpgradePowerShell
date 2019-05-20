# Line break for readability in AppVeyor console
Write-Host -Object ''

# Make sure we're using the Master branch and that it's not a pull request
# Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
if ($env:APPVEYOR_REPO_BRANCH -ne 'master') {
    Write-Warning -Message "Skipping version increment and publish for branch $env:APPVEYOR_REPO_BRANCH"
}
elseif ($env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0) {
    Write-Warning -Message "Skipping version increment and publish for pull request #$env:APPVEYOR_PULL_REQUEST_NUMBER"
}
else {
    # We're going to add 1 to the revision value since a new commit has been merged to Master
    # This means that the major / minor / build values will be consistent across GitHub and the Gallery
    Try {
        # This is where the module manifest lives
        $manifestPath = '.\UpgradePowerShell\UpgradePowerShell.psd1'

        # Start by importing the manifest to determine the version, then add 1 to the revision
        $manifest = Test-ModuleManifest -Path $manifestPath
        [System.Version]$version = $manifest.Version
        Write-Output "Old Version: $version"
        [String]$newVersion = New-Object -TypeName System.Version -ArgumentList ($version.Major, $version.Minor, $version.Build, $env:APPVEYOR_BUILD_NUMBER)
        Write-Output "New Version: $newVersion"

        $splat = @{
            'Path'              = $manifestPath
            'ModuleVersion'     = $newVersion
            'Copyright'         = "(c) 2018-$( (Get-Date).Year ) Swimlane. All rights reserved."
        }
        Update-ModuleManifest @splat
        (Get-Content -Path $manifestPath) -replace 'PSGet_UpgradePowerShell', 'UpgradePowerShell' | Set-Content -Path $manifestPath
        (Get-Content -Path $manifestPath) -replace 'NewManifest', 'UpgradePowerShell' | Set-Content -Path $manifestPath
    }
    catch {
        throw $_
    }

    # Publish the new version to the PowerShell Gallery
    Try {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $PM = @{
            Path        = '.\UpgradePowerShell'
            NuGetApiKey = $env:NuGetApiKey
            ErrorAction = 'Stop'
            Tags         = 'Upgrade', 'PowerShell'
            LicenseUri   = 'https://github.com/Swimlane/UpgradePowerShell/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/Swimlane/UpgradePowerShell'
            ReleaseNotes = 'Initial release to the PowerShell Gallery'
        }

        Publish-Module @PM
        Write-Host "UpgradePowerShell PowerShell Module version $newVersion published to the PowerShell Gallery." -ForegroundColor Cyan
    }
    Catch {
        # Sad panda; it broke
        Write-Warning "Publishing $newVersion to the PowerShell Gallery failed."
        throw $_
    }
}