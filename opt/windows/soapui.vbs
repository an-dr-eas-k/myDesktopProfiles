Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run chr(34) & "C:\Program Files\SoapUI-5.4.0\bin\soapui.bat" & Chr(34), 0
Set WshShell = Nothing
