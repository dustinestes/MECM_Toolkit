Set objLocator = CreateObject("WbemScripting.SWbemLocator")
Set objService = objLocator.ConnectServer(".", "root\cimv2")
objService.Security_.ImpersonationLevel = 3

Set vBatteryStatus = objService.ExecQuery("Select BatteryStatus From Win32_Battery where BatteryStatus != 2")

If vBatteryStatus = "2" Then
	Echo "AC Power"
Else
	Echo "Battery"
End If