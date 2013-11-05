# This function configures the specified network adapter
function Set-NetworkAdapter-Configuration($adapterName, $ipArray, $subnet, $gateway, $dns) {
    $adapter = get-wmiobject win32_networkadapter | ?{ $_.NetConnectionId -eq $adapterName }
    $config = $adapter.GetRelated("Win32_NetworkAdapterConfiguration")
	
	$subnetArray = @()
    ForEach ($ip in $ipArray){
        $subnetArray += $subnet
    }  
  
    $config.EnableStatic($ipArray, $subnetArray)
    $config.SetGateways($gateway)
    $config.SetDNSServerSearchOrder($dns)
}

$subnet = "255.255.255.0"
$ips = @("192.168.1.1", "192.168.1.2")
$dns = "8.8.4.4"
$gateway = "192.168.1.254"
$networkName = "MyNetwork"

Set-NetworkAdapter-Configuration $networkName $ips $subnet $gateway $dns