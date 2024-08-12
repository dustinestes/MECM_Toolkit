Set TSEnv = CreateObject("Microsoft.SMS.TSEnvironment")
For Each Var In  TSEnv.GetVariables  
WScript.Echo Var & "=" & TSEnv(Var)
Next