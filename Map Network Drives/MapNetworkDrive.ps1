param([string]$action)

$ServerIP = "\\192.168.1.2\"

$Shares = @{}
$Shares.Add($ServerIP + 'Share1','Z:')
$Shares.Add($ServerIP + 'Share2','Y:')
$Shares.Add($ServerIP + 'Share3','X:')


if($action -eq "remove"){
    $net = New-Object -com WScript.Network       
    $Shares.GetEnumerator() | % {         
        $net.RemoveNetworkDrive($_.value, "TRUE","TRUE")
    }
} else {
    se {
    $Credential = Get-Credential

    $net = New-Object -com WScript.Network    
    $Shares.GetEnumerator() | % { 
        $net.MapNetworkDrive($_.value, $_.key , "false", $Credential.get_UserName(), $Credential.GetNetworkCredential().Password)
    }
}

