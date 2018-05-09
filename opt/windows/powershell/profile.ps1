Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key ctrl+u -Function BackwardDeleteLine

New-Alias -Name vi   -Value "${Env:ProgramFiles(x86)}\Vim\vim80\vim.exe"
New-Alias -Name gvim -Value "${Env:ProgramFiles(x86)}\Vim\vim80\gvim.exe"
New-Alias -Name git  -Value "${Env:ProgramFiles}\Git\bin\git.exe"


# . "$($HOME)\Documents\WindowsPowerShell\SamplePSReadLineProfile.ps1"
. "$($HOME)\Documents\WindowsPowerShell\acd_func.ps1"
$PROFILEFULL = ($PROFILE | Get-Item |select -ExpandProperty Directory | Get-ChildItem  -Filter "profile.ps1" )[0].FullName



