function Show-Menu
{
 param (
 [string]$Title = 'My Menu'
 )
 Clear-Host
 Write-Host "================ $Title ================"
 Write-Host "1: Press '1' for adding Symbol Path."
 Write-Host "2: Press '2' for deleting Symbol Path."
 Write-Host "Q: Press 'Q' to quit."
}

$erroractionPreference="stop"

try
{
    :menu Do {
        Show-Menu –Title 'Add or Delete?'
         $selection = Read-Host "Please make a selection"
         switch ($selection)
         {
             '1' {
                 'You chose option #1 Adding Symbol Path'
                 setx _NT_SYMBOL_PATH "SRV*\\CEDev-TP\Share\Symbols*\\CSS-PREMIER\Symbol;SRV*\\CEDev-TP\Share\Symbols*\\wuxcssfs\CTS\Symbols;SRV*\\CEDev-TP\Share\Symbols*\\sha-fs-01a\Developers\Dev-Symbol-Share\Symbol2;SRV*\\CEDev-TP\Share\Symbols*http://symweb;SRV*\\CEDev-TP\Share\Symbols*http://symbolserver.unity3d.com/;SRV*\\CEDev-TP\Share\Symbols*https://driver-symbols.nvidia.com/;SRV*\\CEDev-TP\Share\Symbols*\\ddrps\symbols;" /M
                 Write-Host $Env:_NT_SYMBOL_PATH
             } '2' {
                 'You chose option #2 Deleting Symbol Path'
                 reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v _NT_SYMBOL_PATH /f
             } 'q' {
                 return
             }
         }
     } until($selection -eq 'q')
}
catch
{
    Write-Error "Something threw an exception, try to execute as administrator"
}