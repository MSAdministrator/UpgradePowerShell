# Base64 encode a file to a string

$Content = Get-Content -Path C:\Users\rickardja\Downloads\Windows6.1-KB2506143-x64.msu -Encoding Byte
$Base64 = [System.Convert]::ToBase64String($Content)
$Base64 | Out-File C:\_GitHub\UpgradePowerShell\prerequisites\Windows6.1-KB2506143-x64.txt


# Convert base64 encoded string to file

$b64      = 'AAAAAA...'
$filename = 'C:\path\to\file'

$bytes = [Convert]::FromBase64String($b64)
[IO.File]::WriteAllBytes($filename, $bytes)