
$acd_init_file = "~/.plan"
$max_acd_size=18


function New-Acd {
  try {
    $remIndex = ( $Global:AcdWDs | select -ExpandProperty Path ).indexof( (Get-Location | select -ExpandProperty Path ) )
    if ($remIndex -ge 0 ){
      $Global:AcdWDs.RemoveAt($remIndex)
    }
    ($global:AcdWDs).Insert(0, (get-location))
    $global:AcdWDs = $global:AcdWDs.GetRange(0, $max_acd_size) 
  } catch {}
}

function Do-Acd ($value) {
  [int]$returnedInt = 0
  [bool]$result = [int]::TryParse($value, [ref]$returnedInt)
  if ($result -and $returnedInt -lt 0) {
    $global:AcdWDs[[Math]::Abs($value)-1] | set-location
  } elseif ($value -eq "-i" ) {
    $global:AcdWDs = New-Object System.Collections.ArrayList
    Init-Acd ($acd_init_file)
  } elseif ($value -eq "-" ) {
    do-acd -2
  } elseif ($value -eq $null ) {
    do-acd ~
  } else {
    set-location $value
  }
  New-Acd
}

function Init-Acd($file){
  if ( -not (Get-Variable AcdWDs -Scope Global -ErrorAction Ignore )){
    $global:AcdWDs = New-Object System.Collections.ArrayList
  }
  $startWd = (pwd).Path
  $plan = get-content $file
  [array]::Reverse($plan)
  foreach ($element in $plan) {
    if (( test-path $element )) {
      write-output "preparing $($element)"
      Do-Acd ($element)
    }
  }
  Do-Acd ($startWd) # finally we move to original dir
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
#      WriteTo-Pos (" " * [Console]::BufferWidth) 0 ($index2++) 
#      WriteTo-Pos ("*" * [Console]::BufferWidth) 0 ($index2++) 
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


