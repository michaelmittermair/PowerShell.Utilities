# Changing the Power Saving Settings via PowerShell

$PowerOptionName= “High Performance” # You could use ‘Balanced’, ‘High Performance’, ‘Power Saver’, etc here

$plan = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = '$PowerOptionName'"          

Invoke-CimMethod -InputObject $plan -MethodName Activate