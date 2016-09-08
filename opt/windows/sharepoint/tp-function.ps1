Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$logFile = "$($env:TEMP)\sp-sendto.log"
$url = "http://we2.collaboration.roche.com/team/20122de2"
$context = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$context.Credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $logFile -value $logstring
}
LogWrite "scriptstart"
LogWrite "args0: $($args[0])"
LogWrite "args1: $($args[1])"

$mode = $args[0]
$webdav = $args[1]

LogWrite "mode: $mode"
LogWrite "webdav: $webdav"

$relativePath = [regex]::replace($webdav, "^.*DavWWWRoot", "")
$relativePath = $relativePath.replace("\", "/")
$relativePath = $relativePath.replace(" ", "%20")
LogWrite "relpath: $relativePath"

$file = $context.Web.GetFileByServerRelativeUrl( $relativePath )

if ($mode -eq "checkout") {
	$file.CheckOut()
} elseif ($mode -eq "undocheckout") {
	$file.UndoCheckOut()
} elseif ($mode -eq "checkin") {
	$file.CheckIn("", [Microsoft.SharePoint.Client.CheckinType]::MajorCheckIn)
} else {
	LogWrite "wrong type $mode"
	exit
}

$context.ExecuteQuery()

Stop-process $pid
