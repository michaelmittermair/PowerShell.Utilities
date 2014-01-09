# this script will copy the powershell windows update script to each server
# after copying, on each server a schedule task will be created, which will
# run every day at 05:00AM to search for windows updates and install them

# path, where the installscripts are located
$ScriptPath = "c:\WU_Install\"

# path to the windows update script
$UpdateScriptPath = $ScriptPath + "WindowsUpdateViaPS.ps1"

#path to the script for creating the schedule task
$TaskCreationPath = $ScriptPath + "Schedule Windows Updates.ps1"

# Servers, on which the operations should be performed
$Servers = @("Server1","Server2")

foreach ($ObjItem in $Servers) {
    # combining path to remote server 
    # will look something like \\ServerName\c$\WindowsUpdate\
    $DirPath = "\\" + $ObjItem + "\c$\WindowsUpdate\"

    # Create directory if does not exist
    if(!(Test-Path -Path $DirPath )) {
        New-Item -ItemType directory -Path $DirPath
    }

    # copy updatescript to remote server
    Copy-Item $UpdateScriptPath $DirPath

    # creating the update task on the remote server
    Invoke-Command -ComputerName $ObjItem -FilePath $TaskCreationPath
}