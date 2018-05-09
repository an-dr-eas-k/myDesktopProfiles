
$acd_init_file = "~/.plan"

$global:AcdWDs = New-Object System.Collections.ArrayList
($global:AcdWDs).Add((get-location)) | out-null

function New-Acd {
    if ( ( $Global:AcdWDs | ? { $_.Path -eq  ( Get-Location )  } ).Count -eq 0 ) {
      ($global:AcdWDs).Insert(0, (get-location))
    }
}

function Do-Acd ($value) {
  [int]$returnedInt = 0
  [bool]$result = [int]::TryParse($value, [ref]$returnedInt)
   if ($result -and $returnedInt -lt 0) {
    $global:AcdWDs[[Math]::Abs($value)-1] | set-location
   } else {
      set-location $value
   }
   New-Acd
}

function Init-Acd($file){
  $plan = get-content $file
  [array]::Reverse($plan)
  foreach ($element in $plan) {
    if (( test-path $element )) {
      write-output "preparing $($element)"
      Do-Acd ($element)
    }
  }
}


function WriteTo-Pos ([string] $str, [int] $x = 0, [int] $y = 0,
      [string] $bgc = [console]::BackgroundColor,
      [string] $fgc = [Console]::ForegroundColor)
{
      if($x -ge 0 -and $y -ge 0 -and $x -le [Console]::WindowWidth -and $y -le [Console]::WindowHeight)
      {
            $saveY = [console]::CursorTop
            $offY = [console]::WindowTop       
            foreach ($line in @( (" " * [Console]::BufferWidth), $str)) {
              [console]::setcursorposition($x,$offY+$y)
              Write-Host -Object "$($line)" -BackgroundColor $bgc -ForegroundColor $fgc -NoNewline
            }
            [console]::setcursorposition(0,$saveY)
      }
}

function Print-AcdWds
{
    $global:index=0
    $index2=0
    $global:AcdWDs `
      | Format-Table -autoSize -Property @{name="index";expression={$global:index;$global:index-=1}},Path `
      | out-string `
      | % {$_ -split [Environment]::NewLine} `
      | ? {$_.length -gt 0 } `
      | % { WriteTo-Pos $_ 0 ($index2++) }
      WriteTo-Pos (" " * [Console]::BufferWidth) 0 ($index2++) 
      WriteTo-Pos ("*" * [Console]::BufferWidth) 0 ($index2++) 
      WriteTo-Pos (" " * [Console]::BufferWidth) 0 ($index2++) 
    Remove-Variable -Scope Global -Name index
    Remove-Variable -Name index2
}

# Set-PSReadLineKeyHandler -Key Enter `
#                          -BriefDescription SaveInCwdHistory `
#                          -LongDescription "Save current working directory in history and execute" `
#                          -ScriptBlock {
#     param($key, $arg)
#     [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
#     New-Acd
# }

Set-PSReadLineKeyHandler -Key Alt+w `
                         -BriefDescription ShowCwdHistory `
                         -LongDescription "Show list of recent working directories" `
                         -ScriptBlock {
    
    param($key, $arg)
    Print-AcdWDs
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

Init-Acd ($acd_init_file)
Remove-Item Alias:cd
New-Alias cd do-acd


