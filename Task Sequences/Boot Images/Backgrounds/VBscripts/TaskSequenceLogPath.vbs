On Error Resume Next

Set TSEnv = CreateObject("Microsoft.SMS.TSEnvironment")

If TSEnv("_SMSTSLogPath") = "" Then
    Echo "X:\Windows\temp\"
Else
    Echo TSEnv("_SMSTSLogPath")
End If