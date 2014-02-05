param([string]$action)

$RemotePath = "\\Server1\C$"
$LocalPath = "Z:"


if($action -eq "remove"){
    #adding in here
    $net = New-Object -com WScript.Network
    $net.RemoveNetworkDrive($LocalPath, "TRUE","TRUE")
} else {
    $Username = Read-Host "Benutzername: "
    $Password = Read-Host "Password: "

    #adding in here
    $net = New-Object -com WScript.Network
    $net.MapNetworkDrive($LocalPath, $RemotePath, "false", $Username, $Password)
}