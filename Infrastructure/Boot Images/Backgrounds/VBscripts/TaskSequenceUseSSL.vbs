Set TSEnv = CreateObject("Microsoft.SMS.TSEnvironment")

sSSLValue = TSEnv("_SMSTSUseSSL")

If sSSLValue = "True" Then
	Echo "True"
Else
	Echo "False"
End If
