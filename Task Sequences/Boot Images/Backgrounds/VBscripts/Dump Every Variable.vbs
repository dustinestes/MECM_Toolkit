sWord = "Say"
Wscript.echo sWord

Set oTSEnv = CreateObject("Microsoft.SMS.TSEnvironment")
For Each oVar In oTSEnv.GetVariables
' Only worry about variables that have a value
If oEnvironment.Item(oVar) <> "" Then
' Log variable before flush

oLogging.CreateEntry oVar & "  =  " & oEnvironment.Item(oVar), LogTypeInfo
End if
Next