<# 
.SYNOPSIS 
Extract files with the same file name and the specified extension 
 
.DESCRIPTION 
Extract files with the same file name and the specified extension 
 
.EXAMPLE 
PS> .\extract-file-with-the-same-name-spec-ext.ps1
#>

function TestPath([String] $FolderPath)  
{ 
    $FileExists = Test-Path $FolderPath 
    If ($FileExists -eq $True)  
    { 
        Return $true 
    } 
    Else  
    { 
        Return $false 
    } 
}

function MoveFileToTargetPath()
{
    PARAM(
    [parameter()] $SourcePath, 
    [parameter()] $FileName, 
    [parameter()] $FileExt, 
    [parameter()] $TempFolderName)
    
    $TempFP = Join-Path -Path $SourcePath -ChildPath $TempFolderName
    Write-Host "$SourcePath - $FileName - $FileExt - $TempFolderName - $TempFP"
    If (!(Test-Path $TempFP))
    {
        New-Item -ItemType Directory $TempFP
    }
    Move-Item -Path $SourcePath\$FileName.$FileExt -Destination $TempFP\$FileName.$FileExt -Force
    "Moved file $FileName.$FileExt to $TempFP"
}

$SourcePath = Read-Host -Prompt 'Input the source folder path'
#$SourcePath = 'D:\Desktop\Test\Source' #For Debugging
If (!(TestPath($SourcePath))) 
{ 
    "Source Folder path is incorrect."
    EXIT 
}

$SourceExt = Read-Host -Prompt 'Input the file extension in the source folder, for example, txt'
#$SourceExt = 'txt' #For Debugging

$TargetPath = Read-Host -Prompt 'Input the target folder path'
#$TargetPath = 'D:\Desktop\Test\Target' #For Debugging 
If (!(TestPath($TargetPath))) 
{ 
    "Target Folder path is incorrect."
    EXIT 
}
$TargetExt = Read-Host -Prompt 'Input the file extension in the target folder, for example, txt'
#$TargetExt = 'raw' #For Debugging

"---------------------------------------------------"
"Source: Scan all .$SourceExt files in '$SourcePath'"
"Target: Check all .$TargetExt files in '$TargetPath'" 
"---------------------------------------------------"

$SourceFilteredFiles = Get-ChildItem -Path $SourcePath -Filter *.$SourceExt -Recurse -File -Name |
ForEach-Object {
    [System.IO.Path]::GetFileNameWithoutExtension($_)
}

#foreach ($item in $SourceFilteredFiles) {$item}
#"---------------------------------------------------"

$TargetFilteredFiles = Get-ChildItem -Path $TargetPath -Filter *.$TargetExt -Recurse -File -Name |
ForEach-Object {
    [System.IO.Path]::GetFileNameWithoutExtension($_)
}

#foreach ($item in $TargetFilteredFiles) {$item}
#"---------------------------------------------------"

$Result = $TargetFilteredFiles | Where-Object -FilterScript { $_ -in $SourceFilteredFiles }
$TempFolderName = "Temp"

foreach ($item in $Result)
{
    MoveFileToTargetPath -SourcePath $TargetPath -FileName $item -FileExt $TargetExt -TempFolderName $TempFolderName
}