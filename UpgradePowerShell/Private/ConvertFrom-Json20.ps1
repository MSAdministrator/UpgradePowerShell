<#
.SYNOPSIS
   Converts an object to JSON for PowerShell 2
.DESCRIPTION
   Converts an object to JSON for PowerShell 2
.EXAMPLE
   ConvertFrom-Json20 $item
#>
function ConvertFrom-Json20([object] $item){ 
    Write-Verbose -Message 'Converting JSON to object'
    
    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer

    #The comma operator is the array construction operator in PowerShell
    return ,$ps_js.DeserializeObject($item)
}