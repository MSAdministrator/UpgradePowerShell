# UpgradePowerShell

[![Build status](https://ci.appveyor.com/api/projects/status/274vxvijj3e5d2oh?svg=true)](https://ci.appveyor.com/project/MSAdministrator/upgradepowershell)

[![Build status](https://ci.appveyor.com/api/projects/status/274vxvijj3e5d2oh/branch/master?svg=true)](https://ci.appveyor.com/project/MSAdministrator/upgradepowershell/branch/master)

A PowerShell Module to upgrade your system from PowerShell 2 to 5

## Installation

Run the following after putting the UpgradePowerShell root folder in C:\users\user\Documents\WindowsPowerShell\Modules folder (you may have to create the folders in this path):

For example, the path to the downloaded repository should be:

`C:\users\SomeUser\Documents\WindowsPowerShell\Modules\UpgradePowerShell\UpgradePowerShell.psm1` 

But keep the same structure as the repository

## Using

Then open a admin PowerShell prompt and run:

```powershell
Import-Module UpgradePowerShell
```

To upgrade from Version 2 to 3, run the following in the same command prompt:

```powershell
Upgrade-PowerShell -Version 3
```

To upgrade from Version 2 to 5, then do the following (this will reboot your machine several times):

```powershell
Upgrade-PowerShell -Version 5
``

