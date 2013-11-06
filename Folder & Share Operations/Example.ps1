# including external files
. ".\Create-Directory-And-Disable-Protection-Rule.ps1"
. ".\Create-Share.ps1"

$ApplicationPath = "C:\Application"


Create-Directory $ApplicationPath
Set-Modify-Rights-For-User $ApplicationPath "DOMAIN\ApplicationMaintainers"
Set-FullControl-For-User $ApplicationPath ".\Administrators"
Set-Read-Rights-For-User $ApplicationPath "IUSR"
Disable-Protection-Rule-For-Directory $ApplicationPath


# Create share with permissons **********************************

# global 
$users = "ApplicationMaintainers"
$domain = "DOMAIN"
$shareRight = $SHARE_CHANGE, $SHARE_READ
$Sharename = "Share"

Create-Share $Sharename $ApplicationPath "Sharing Application" $users $shareRight $domain
