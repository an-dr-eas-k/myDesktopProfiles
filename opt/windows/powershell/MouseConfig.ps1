<#
	.SYNOPSIS
		Sets mouse parameters.

	.DESCRIPTION
		Sets the mouse speed via the SystemParametersInfo
		and stores the speed in the registry

	.PARAMETER  Speed
		Integer between 1 (slowest) and 20 (fastest).

	.PARAMETER  ScrollLines
		Integer between -1 (slowest) and 100.

	.EXAMPLE
		Sets the mouse speed to the value 10.

		PS C:\> Set-Mouse -Speed 10

	.EXAMPLE
		Sets the mouse WheelScrollLines to the value 5.

		PS C:\> Set-Mouse -ScrollLines 5

		.INPUTS
		System.int

	.NOTES
		See Get-Mouse also.

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

	.LINK
		https://msdn.microsoft.com/en-us/library/ms724947(v=VS.85).aspx
				
	.LINK
		https://github.com/raevilman/windows-scripts/edit/master/mouse/speed/ps_scripts/MouseSpeed.ps1

#>
function Set-Mouse() {

	[cmdletbinding()]
	Param(
		[ValidateRange(1, 20)] 
		[int]
		$MouseSensitivity = -1,
		[ValidateRange(-1, 100)] 
		[int]
		$WheelScrollLines = -1,
		[int]
		$MouseSpeed = -1,
		[int]
		$MouseThreshold1 = -1,
		[int]
		$MouseThreshold2 = -1,
		[uint[]]
		$Mouse = $null
	)       

	$MethodDefinition = @"
		[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
		public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
		[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
		public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint[] pvParam, uint fWinIni);
"@
	$User32 = Add-Type -MemberDefinition $MethodDefinition -Name "User32Set" -Namespace Win32Functions -PassThru
	if ($MouseSensitivity -ge 0) {
		Write-Verbose "new mouse sensitivity: $MouseSensitivity"
		$User32::SystemParametersInfo(0x0071, 0, $MouseSensitivity, 0) | Out-Null
		Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSensitivity -Value $MouseSensitivity
	}
	if ($WheelScrollLines -ge 0) {
		Write-Verbose "new wheel scrollLines: $WheelScrollLines"
		$User32::SystemParametersInfo(0x0069, $WheelScrollLines, 0, 0x01) | Out-Null
		Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name WheelScrollLines -Value $WheelScrollLines
	}
	[uint[]]$currentValues = Get-Mouse | ForEach-Object {$_.Mouse, $_.MouseThreshold1, $_.MouseThreshold2}
	if ($MouseSpeed -ge 0) {
		$currentValues[0] = $MouseSpeed
		$Mouse = $currentValues
		Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value $MouseSpeed
	}
	if ($MouseThreshold1 -ge 0) {
		$currentValues[1] = $MouseThreshold1
		$Mouse = $currentValues
		Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseThreshold1 -Value $MouseThreshold1
	}
	if ($MouseThreshold2 -ge 0) {
		$currentValues[2] = $MouseThreshold2
		$Mouse = $currentValues
		Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseThreshold2 -Value $MouseThreshold2
	}
	if ($Mouse) {
		Write-Verbose "new mouse: $Mouse"
		$User32::SystemParametersInfo(0x0004, 0, @($Mouse), 0x01) | Out-Null
		# Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name MouseThreshold2 -Value $MouseDragoutTheshold
	}
}

<#
	.SYNOPSIS
		Gets the mouse settings.

	.DESCRIPTION
		Gets the mouse settings via the SystemParametersInfo

	.EXAMPLE
		Gets the current mouse

		PS C:\> Get-Mouse

	.Outputs
		System.int

	.NOTES
		See Set-Mouse also.

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

	.LINK
		https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfoa

	.LINK
		https://msdn.microsoft.com/en-us/library/ms724947(v=VS.85).aspx

	.LINK
		https://github.com/raevilman/windows-scripts/edit/master/mouse/speed/ps_scripts/MouseSpeed.ps1

#>
function Get-Mouse {
	[cmdletbinding()]
	param()

	$MethodDefinition = @"
		[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
		public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, ref uint pvParam, uint fWinIni);
		[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
		public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint[] pvParam, uint fWinIni);
"@
	$User32 = Add-Type -MemberDefinition $MethodDefinition -Name "User32Get" -Namespace Win32Functions -PassThru

	[Int32]$MouseSensitivity = 0
	$User32::SystemParametersInfo(0x0070, 0, [ref]$MouseSensitivity, 0) | Out-Null
	[Int32]$WheelScrollLines = 0
	$User32::SystemParametersInfo(0x0068, 0, [ref]$WheelScrollLines, 0) | Out-Null
	[Int32[]]$Mouse = (0, 0, 0)
	$User32::SystemParametersInfo(0x0003, 0, $Mouse, 0) | Out-Null
	return [pscustomobject]@{
		"MouseSensitivity" = $MouseSensitivity;
		"WheelScrollLines" = $WheelScrollLines;
		"MouseSpeed"       = $Mouse[0];
		"MouseThreshold1"  = $Mouse[1];
		"MouseThreshold2"  = $Mouse[2];
	}
}