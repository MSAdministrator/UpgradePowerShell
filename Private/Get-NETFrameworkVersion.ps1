<#
The sample scripts are not supported under any Microsoft standard support 
program or service. The sample scripts are provided AS IS without warranty  
of any kind. Microsoft further disclaims all implied warranties including,  
without limitation, any implied warranties of merchantability or of fitness for 
a particular purpose. The entire risk arising out of the use or performance of  
the sample scripts and documentation remains with you. In no event shall 
Microsoft, its authors, or anyone else involved in the creation, production, or 
delivery of the scripts be liable for any damages whatsoever (including, 
without limitation, damages for loss of business profits, business interruption, 
loss of business information, or other pecuniary loss) arising out of the use 
of or inability to use the sample scripts or documentation, even if Microsoft 
has been advised of the possibility of such damages.
#> 

Function Get-NETFrameworkVersion
{
	$RegistryPrefix = "Registry::";

# 4.x
	Try {
		$NET4Key = Get-Item -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs")

		$MaxVersionNumber = 0
		$MaxVersionName = ""
		$NET4Key.GetSubKeyNames() | WHERE { $_ -Match "NETFramework" } | ForEach-Object {
			Try {
				$Version = [regex]::Match($_, "v\d\.?\d?\.?\d?").Value.Replace("v", "")
				$VersionNumber = [int]::Parse($Version.Replace(".", ""))

				# in case 4.6 is less than 4.5.1
				If ($VersionNumber -lt 100) {
					$VersionNumber *= 10
				}

				If ($MaxVersionNumber -lt $VersionNumber) {
					$MaxVersionNumber = $VersionNumber
					$MaxVersionName = $Version
				}
			}
			Catch {}
		}

		If ($MaxVersionNumber -ne 0) {
			Write-Output "$MaxVersionName";
		}
	} Catch {}

#3.5 Original
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5") | SELECT -ExpandProperty "SP") -eq 0)) {
			Write-Output "3.5";
		}
	} Catch {}

#3.5 Service Pack 1
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5") | SELECT -ExpandProperty "SP") -eq 1)) {
			Write-Output "3.5";
		}
	} Catch {}

#3.0 Original
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0\Setup") | SELECT -ExpandProperty "InstallSuccess") -eq 1) -and
			((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0") | SELECT -ExpandProperty "SP") -eq 0)) {
			Write-Output "3.0";
		}

	} Catch {}

#3.0 Service Pack 1
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0") | SELECT -ExpandProperty "SP") -eq 1)) {
			Write-Output "3.0";
		}
	} Catch {}

#3.0 Service Pack 2
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0") | SELECT -ExpandProperty "SP") -eq 2)) {
			Write-Host ".NET Framework 3.0 service pack 2 ";
		}
	} Catch {}

#2.0 Original
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727") | SELECT -ExpandProperty "SP") -eq 0)) {
			Write-Host ".NET Framework 2.0";
		}
	} Catch {}

#2.0 Service Pack 1
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727") | SELECT -ExpandProperty "SP") -eq 1)) {
			Write-Host ".NET Framework 2.0 service pack 1 ";
		}
	} Catch {}

#2.0 Service Pack 2
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\NET Framework Setup\NDP\v2.0.50727") | SELECT -ExpandProperty "SP") -eq 2)) {
			Write-Host ".NET Framework 2.0 service pack 2 ";
		}
	} Catch {}

#1.1 Original on 32-bit system
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "SP") -eq 0)) {
			Write-Host ".NET Framework 1.1";
		}
	} Catch {}

#1.1 Original on 64-bit system
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKLM\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKLM\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "SP") -eq 0)) {
			Write-Host ".NET Framework 1.1";
		}
	} Catch {}

#1.1 Service Pack 1 on 32-bit system
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "SP") -eq 1)) {
			Write-Host ".NET Framework 1.1 service pack 1 ";
		}
	} Catch {}

#1.1 Service Pack 1 on 64-bit system
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKLM\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "Install") -eq 1) -and
				((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKLM\SOFTWARE\Wow6432Node\Microsoft\NET Framework Setup\NDP\v1.1.4322") | SELECT -ExpandProperty "SP") -eq 1)) {
			Write-Host ".NET Framework 1.1 service pack 1 ";
		}
	} Catch {}

#1.0 Original (on supported platforms except for Windows XP Media Center and Tablet PC)
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup\Installed Components\{78705f0d-e8db-4b2d-8193-982bdda15ecd}") | SELECT -ExpandProperty "Version") -eq "1.0.3705.0")) {
			Write-Host ".NET Framework 1.0";
		}
	} Catch {}

#1.0 Service Pack 1 (on supported platforms except for Windows XP Media Center and Tablet PC)
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup\Installed Components\{78705f0d-e8db-4b2d-8193-982bdda15ecd}") | SELECT -ExpandProperty "Version") -eq "1.0.3705.1")) {
			Write-Host ".NET Framework 1.0 service pack 1";
		}
	} Catch {}

#1.0 Service Pack 2 (on supported platforms except for Windows XP Media Center and Tablet PC)
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup\Installed Components\{78705f0d-e8db-4b2d-8193-982bdda15ecd}") | SELECT -ExpandProperty "Version") -eq "1.0.3705.2")) {
			Write-Host ".NET Framework 1.0 service pack 2";
		}
	} Catch {}

#1.0 Service Pack 3 (on supported platforms except for Windows XP Media Center and Tablet PC)
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup\Installed Components\{78705f0d-e8db-4b2d-8193-982bdda15ecd}") | SELECT -ExpandProperty "Version") -eq "1.0.3705.3")) {
			Write-Host ".NET Framework 1.0 service pack 3";
		}
	} Catch {}

#1.0 Service Pack 2 (shipped with Windows XP Media Center 2002/2004 and Tablet PC 2004)
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup\Installed Components\{FDC11A6F-17D1-48f9-9EA3-9051954BAA24}") | SELECT -ExpandProperty "Version") -eq "1.0.3705.2")) {
			Write-Host ".NET Framework 1.0 service pack 2";
		}
	} Catch {}

#1.0 Service Pack 3 (shipped with Windows XP Media Center 2002/2004 and Tablet PC 2004)
	Try {
		IF (((Get-ItemProperty -ErrorAction Stop -Path ($RegistryPrefix + "HKEY_LOCAL_MACHINE\Software\Microsoft\Active Setup\Installed Components\{FDC11A6F-17D1-48f9-9EA3-9051954BAA24}") | SELECT -ExpandProperty "Version") -eq "1.0.3705.3")) {
			Write-Host ".NET Framework 1.0 service pack 3";
		}
	} Catch {}
}

Get-NETFrameworkVersion
