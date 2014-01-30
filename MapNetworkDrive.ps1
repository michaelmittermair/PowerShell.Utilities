$Username = Read-Host "Benutzername: "
$Password = Read-Host "Password: "

$RemotePath = "\\Server1\C$"
$LocalPath = "Z:"

#adding in here
$net = New-Object -com WScript.Network
$net.mapnetworkdrive($LocalPath, $RemotePath, "false", $Username, $Password)
 