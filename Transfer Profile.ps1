##1/10/20
Clear-History
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" `"$args`"" -Verb RunAs; exit }
ipconfig /flushdns
cls

""
## Enviroments
$user = Read-Host -Prompt 'Input the user name'
$pc1bypass = Test-Path "\\localhost\c$\Users\$user"
$pc1exist = Test-Path "\\$pc1\c$\Users\$user"
$pc2exist = Test-Path "\\$pc2\c$\Users\$user"
$loop = Test-Path "\\$pc2\c$"
##-----------------------------------------------------

## Ask to bypass
if($pc1bypass -eq $True) {
""
$bypass = Read-Host "Local profile found! Do you want you use this profile for"$user"? [y/n]"
}else {
""
Write-Host "No local profile found!"
$bypass = 'n'
}
##--------------------------------------------------------

## Bypass for running on local source
if($bypass -eq 'y') {
""
Write-Host "Bypassing input for source path."
Do {
""
$pc2 = Read-Host -Prompt 'Enter Destination Computer (Format = L-AUN-XXXXXXX)'
$pc1path = "\\localhost\c$\Users\$user"
$loop = Test-Path "\\$pc2\c$"

}While ($loop -eq $False)
}

##---------------------------------------------------------

##----------------------BYPASS ENDS HERE--------------------------------------

## Source input if no bypass
if($bypass -eq 'n') {
""
$pc1 = Read-Host -Prompt 'Enter Source Computer (Format = L-AUN-XXXXXXX)'
$pc1exist = Test-Path "\\$pc1\c$\Users\$user"
$pc1path = "\\$pc1\c$\Users\$user"
Sleep -Seconds 1
##--------------------------------------------------------

## Checking for paths
Do {
""
Write-Host "Checking $pc1 for user profile - $user"
""
if ($pc1exist -eq $True){
Write-Host "Profile Found!"
""
$pc2 = Read-Host -Prompt 'Enter Destination Computer (Format = L-AUN-XXXXXXX)'
$loop = Test-Path "\\$pc2\c$"
}else {
Write-Host "Profile not found! Please try again."
""
Get-ChildItem -Path $pc1path*
}
}While ($loop -eq $False)
}


## Checking destination
Do{
if ($loop -eq $True) {
""
Write-Host "Checking destination path - $pc2"
""
Write-Host "Destination Found!"

}else {
""
Write-Host "Destination isn't available - Please Try Again"
}
}While ($loop -eq $False)
##--------------------------------------------------------
$pc2path = "\\$pc2\c$\Users\$user"
$pc2exist = Test-Path "\\$pc2\c$\Users\$user"

## Rename profile or merge

if($pc2exist -eq $true){
""
Write-Host "The profile $user was found on the destination."
""
$profilename = Read-Host "Do you want to merge with existing profile at destination[y] or rename to -XFER[n]."

}else{

$profilename = 'n'
}

if($profilename -eq 'y'){
""
Write-Host "Merging $user in User folder."
""
$confirmation = Read-Host "Transfer AppData? [y/n]"

if($confirmation -eq 'y') {
""
Write-Host "Transferring $user profile from $pc1 to $pc2"
""
Write-Host "This might take awhile -Please Wait"
Robocopy "$pc1path" "$pc2path" /E /NFL /NJH /NP /NS /NC /Copy:DAT /R:2 /W:2 /XF *ntuser ntuser* /XD Downloads* Global* 3D* Objects* Contacts* OneDrive* Saved* Games* Searches* Application* Data* Settings* *Hood Tracing* Microsoft* Cookies* *Intel SendTo Templates
}
if($confirmation -eq 'n') {
""
Write-Host "Transferring $user profile from $pc1 to $pc2"
""
Write-Host "This might take awhile -Please Wait"
Robocopy "$pc1path" "$pc2path" /E /NFL /NJH /NP /NS /NC /Copy:DAT /R:2 /W:2 /XF *ntuser ntuser* /XD Downloads* AppData* Global* 3D* Objects* Contacts* OneDrive* Roaming* Saved* Games* Searches* Application* Data* Local* Settings* *Hood Tracing* Microsoft* Cookies* *Intel SendTo Templates
}
}


## Renaming profile to -XFER

if($profilename -eq 'n'){
""
Write-Host "Naming profile $user-XFER in the Users folder."
""
$confirmation = Read-Host "Transfer AppData? [y/n]"

if($confirmation -eq 'y') {
""
Write-Host "Transferring $user profile from $pc1 to $pc2"
""
Write-Host "This might take awhile -Please Wait"
Robocopy "$pc1path" "$pc2path-XFER" /E /NFL /NJH /NP /NS /NC /Copy:DAT /R:2 /W:2 /XF *ntuser ntuser* /XD Downloads* Global* 3D* Objects* Contacts* OneDrive* Saved* Games* Searches* Application* Data* Settings* *Hood Tracing* Microsoft* Cookies* *Intel SendTo Templates
}
if($confirmation -eq 'n') {
""
Write-Host "Transferring $user profile from $pc1 to $pc2"
""
Write-Host "This might take awhile -Please Wait"
Robocopy "$pc1path" "$pc2path-XFER" /E /NFL /NJH /NP /NS /NC /Copy:DAT /R:2 /W:2 /XF *ntuser ntuser* /XD Downloads* AppData* Global* 3D* Objects* Contacts* OneDrive* Roaming* Saved* Games* Searches* Application* Data* Local* Settings* *Hood Tracing* Microsoft* Cookies* *Intel SendTo Templates
}
}



##--------------------------------------------------------

## Transfer Complete

""
Write-Host "Transferring the user profile from $pc1 is complete"
""
Write-Host "You may now close the window"

Pause
##--------------------------------------------------------
