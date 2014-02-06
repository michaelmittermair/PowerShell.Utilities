$SMTPServer = "SMTP-Server" #ie. mail.gmx.net
$username = "username"
$password = ConvertTo-SecureString "password" -AsPlainText -Force
$outputFile = "D:\output.html"

$Sender = "Sender <username@domain>"
$Recipient = "Recipient <username@domain>"
$Subject = "Subject" 
$Body = "Body Mail" 
$creds = New-Object System.Management.Automation.PSCredential($username, $password)


$URL = "http://url_to_check"
$ie = New-Object -com InternetExplorer.Application
$ie.visible=$true
$ie.navigate($URL) 
while($ie.ReadyState -ne 4) {start-sleep -m 100} # waiting until the application has started

$ie.Document.body.outerHTML | Out-File -FilePath $outputFile # getting the content and saving this to the local drive
$ie.Quit()

$text = Get-Content $outputFile -Raw 

if($text.Contains("asdf")) # check the content
{
    Send-MailMessage -To $Recipient -From $Sender -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Credential $creds -encoding ([System.Text.Encoding]::UTF8) -UseSsl
}