# This script helps updating servers manually
# First, the server searches, if updates are available.
# If there are updates available, these will be downloaded, installed and 
# afterwards the server will be rebooted, if needed. All Operations are also 
# logged into a file for checking.

# Helper to write information to the logfile
Function LogWrite
{
   Param ([string]$logstring)

   Add-content $LogFileName -value "$(Get-Date -format "dd.MM.yy HH:mm") $logstring"
}


# Define update criteria.
# "IsInstalled=0" finds updates that are not installed on the destination computer.
# "Type=" Finds updates of a specific type, such as "'Driver'" and "'Software'".
# "AutoSelectOnWebSites=1" finds updates that are flagged to be automatically selected by Windows Update.
# "BrowseOnly=0" finds updates that are not considered optional.
$Criteria = "IsInstalled=0 and Type='Software' and BrowseOnly=0"

# configurate logging
$Now = Get-Date -format "dd.MM.yy_HH.mm"
$ServerName = $ENV:ComputerName
$LogPath = "c:\WindowsUpdate\"
$LogFileName = $LogPath + "WU_" + $ServerName + "_$Now.log"

# Create directory if does not exist
if(!(Test-Path -Path $LogPath )) {
    New-Item -ItemType directory -Path $LogPath
}

#Search for relevant updates.
$Searcher = New-Object -ComObject Microsoft.Update.Searcher
$SearchResult = $Searcher.Search($Criteria).Updates

if($SearchResult -ne $null) {
    $SearchResult | Out-File $LogFileName

    #Download updates.
    $Session = New-Object -ComObject Microsoft.Update.Session
    $Downloader = $Session.CreateUpdateDownloader()
    $Downloader.Updates = $SearchResult
    $Downloader.Download()
    LogWrite "Updates downloaded."

    #Install updates.
    $Installer = New-Object -ComObject Microsoft.Update.Installer
    $Installer.Updates = $SearchResult
    $Result = $Installer.Install()
    LogWrite "Updates installed."

    #Reboot if required by updates.
    If ($Result.rebootRequired) { 
        LogWrite "Rebooting system."
        shutdown.exe /t 0 /r 
    }
}