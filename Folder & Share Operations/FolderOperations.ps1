function Disable-Protection-Rule-For-Directory {
    param($directoryPath)

    $objACL = Get-Acl $directoryPath
    $objACL.SetAccessRuleProtection($True, $False)
   
    Set-Acl $directoryPath $objACL
}


function Create-Directory {
    param($directoryPath)

    $checkPath = Test-Path $directoryPath

    if($checkPath -eq $false) {
        New-Item -Path $directoryPath -ItemType directory
    }
}


function Create-Directory-And-Disable-Protection-Rule {
    param($directoryPath)

    Create-Directory $directoryPath
    Disable-Protection-Rule-For-Directory $directoryPath
}

##  Modifying the access rights for one user 

function Set-FullControl-For-User {
    param($directoryPath, $account)

    $acl = Get-Acl $directoryPath

    $rights=[System.Security.AccessControl.FileSystemRights]::FullControl
    $inheritance=[System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
    $propagation=[System.Security.AccessControl.PropagationFlags]::None
    $allowdeny=[System.Security.AccessControl.AccessControlType]::Allow

    $dirACE = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$rights,$inheritance,$propagation,$allowdeny)
    $acl.AddAccessRule($dirACE)

    Set-Acl -aclobject $acl -Path $directoryPath
}


function Set-Read-Rights-For-User {
    param($directoryPath, $account)

    $acl = Get-Acl $directoryPath

    $rights=[System.Security.AccessControl.FileSystemRights]::Read
    $inheritance=[System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
    $propagation=[System.Security.AccessControl.PropagationFlags]::None
    $allowdeny=[System.Security.AccessControl.AccessControlType]::Allow

    $dirACE = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$rights,$inheritance,$propagation,$allowdeny)
    $acl.AddAccessRule($dirACE)

    Set-Acl -aclobject $acl -Path $directoryPath    
}


function Set-Write-Rights-For-User {
    param($directoryPath, $account)

    $acl = Get-Acl $directoryPath

    $rights=[System.Security.AccessControl.FileSystemRights]::Write
    $inheritance=[System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
    $propagation=[System.Security.AccessControl.PropagationFlags]::None
    $allowdeny=[System.Security.AccessControl.AccessControlType]::Allow

    $dirACE = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$rights,$inheritance,$propagation,$allowdeny)
    $acl.AddAccessRule($dirACE)

    Set-Acl -aclobject $acl -Path $directoryPath    
}


function Set-Modify-Rights-For-User {
    param($directoryPath, $account)

    $acl = Get-Acl $directoryPath

    $rights=[System.Security.AccessControl.FileSystemRights]::Modify
    $inheritance=[System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
    $propagation=[System.Security.AccessControl.PropagationFlags]::None
    $allowdeny=[System.Security.AccessControl.AccessControlType]::Allow

    $dirACE = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$rights,$inheritance,$propagation,$allowdeny)
    $acl.AddAccessRule($dirACE)

    Set-Acl -aclobject $acl -Path $directoryPath 
}

## Functions for multiple users

function Remove-All-Access-Rule-For-Users {
    param($directoryPath, $users)

    foreach ($user in $users) {
        Remove-All-Access-Rule-For-User $directoryPath $user
    }
}


function Set-FullControl-For-Users {
    param($directoryPath, $users)

    foreach ($user in $users) {
        Set-FullControl-For-User $directoryPath $user
    }
}

function Set-Read-Rights-For-Users {
    param($directoryPath, $users)

    foreach ($user in $users) {
        Set-Read-Rights-For-User $directoryPath $user
    }
}


function Set-Write-Rights-For-Users {
    param($directoryPath, $users)

    foreach ($user in $users) {
        Set-Write-Rights-For-User $directoryPath $user
    }
}


function Set-Modify-Rights-For-Users {
    param($directoryPath, $users)

    foreach ($user in $users) {
        Set-Read-Modify-Rights-For-User $directoryPath $user
    }
}