' hiddenscript.vbs 
' concatinates the given arguments to form an executable command and
' calls wscript to execute it
' example:
' ./hiddenscript.vbs powershell .\myscript.ps1
'
' can be used in Task Scheduler. 



ReDim arr(WScript.Arguments.Count-1)
For i = 0 To WScript.Arguments.Count-1
  arr(i) = WScript.Arguments(i)
Next

command = Join(arr)
' Wscript.Echo command

Set shell = CreateObject("WScript.Shell")
shell.Run command,0


