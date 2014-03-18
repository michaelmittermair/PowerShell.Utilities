# Servers, on which the operations should be performed
$Servers = @("server01", "server02")
$Credential = Get-Credential

foreach ($ObjItem in $Servers) {
	$script = 
		{
			$PowerOptionName= “High Performance” # You could use ‘Balanced’, ‘High Performance’, ‘Power Saver’, etc here
            $plan = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan -Filter "ElementName = '$PowerOptionName'"
            Invoke-CimMethod -InputObject $plan -MethodName Activate
		}
	Invoke-Command -ComputerName $ObjItem -credential $Credential -ScriptBlock $script
}