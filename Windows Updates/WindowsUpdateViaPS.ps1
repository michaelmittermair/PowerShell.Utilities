#Define update criteria.

# "IsInstalled=0" finds updates that are not installed on the destination computer.
# Finds updates of a specific type, such as "'Driver'" and "'Software'".
# "AutoSelectOnWebSites=1" finds updates that are flagged to be automatically selected by Windows Update.
# "BrowseOnly=0" finds updates that are not considered optional.
$Criteria = "IsInstalled=0 and Type='Software' and BrowseOnly=0"


#Search for relevant updates.
$Searcher = New-Object -ComObject Microsoft.Update.Searcher
$SearchResult = $Searcher.Search($Criteria).Updates

if($SearchResult -ne $null)
{
    #logging
    $now = Get-Date -format "dd-MMM-yyyy_HH.mm"
    $SearchResult | Out-File C:\Update\$now.log

    #Download updates.
    $Session = New-Object -ComObject Microsoft.Update.Session
    $Downloader = $Session.CreateUpdateDownloader()
    $Downloader.Updates = $SearchResult
    $Downloader.Download()

    #Install updates.
    $Installer = New-Object -ComObject Microsoft.Update.Installer
    $Installer.Updates = $SearchResult
    $Result = $Installer.Install()

    #Reboot if required by updates.
    If ($Result.rebootRequired) { shutdown.exe /t 0 /r }
}