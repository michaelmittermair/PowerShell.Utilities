#* Based on the script of http://stackoverflow.com/questions/15672388/robocopy-sending-email-attachment-appending-file-name
#*=============================================
#* Base variables
#*=============================================
param([string]$sourcePath,[string] $destinationPath,[string] $customerName)

$Logfile = "C:\Robocopy_Log\Robocopy.log"
$Subject = "Robocopy Results: Copy Purpose: Location 2 Location"
$SMTPServer = "127.0.0.1"
$Sender = "Server01 <mail@domain.local>"
$Recipients = "Support <support@domain.local>"
$Admin = "Michael Mittermair <mail@domain.local>"
$SendEmail = $True
$IncludeAdmin = $True
$AsAttachment = $True
$backupState = "UNKNOWN"

#*=============================================
#* SCRIPT BODY
#*=============================================

# Change robocopy options as needed. ( http://ss64.com/nt/robocopy.html )
robocopy $sourcePath $destinationPath /MIR /FFT /R:2 /LOG:$Logfile  /XA:S /XD *RECYCLE.BIN*

# The following attempts to get the error code for Robocopy
# and use this as extra infromation and email determination.
# NO OTHER CODE BETWEEN THE SWITCH AND THE ROBOCOPY COMMAND
Switch ($LASTEXITCODE)
{
	16
	{
		$exit_code = "16"
		$exit_reason = "[***FATAL ERROR***] Robocopy did not copy any files.  Check the command line parameters and verify that Robocopy has enough rights to write to the destination folder"
		$backupState = "ERROR"
	}
	15
	{
		$exit_code = "15"
		$exit_reason = "[FAILED] OKCOPY + FAIL MISMATCH EXTRA COPY"
		$backupState = "ERROR"
	}
	14
	{
		$exit_code = "14"
		$exit_reason = "[FAILED] FAIL MISMATCH EXTRA"
		$backupState = "ERROR"
	}
	13
	{
		$exit_code = "13"
		$exit_reason = "[FAILED] OKCOPY + FAIL MISMATCH COPY"
		$backupState = "ERROR"
	}
	12
	{
		$exit_code = "12"
		$exit_reason = "[FAILED] FAIL MISMATCH"
		$backupState = "ERROR"
	}
	11
	{
		$exit_code = "11"
		$exit_reason = "[FAILED] OKCOPY + FAIL EXTRA COPY"
		$backupState = "ERROR"
	}
	10
	{
		$exit_code = "10"
		$exit_reason = "[FAILED] FAIL EXTRA"
		$backupState = "ERROR"
	}
	9
	{
		$exit_code = "9"
		$exit_reason = "[FAILED] FAIL COPY"
		$backupState = "ERROR"
	}
	8
	{
		$exit_code = "8"
		$exit_reason = "[FAILED COPIES] Some files or directories could not be copied and the retry limit was exceeded"
		$backupState = "ERROR"
	}
    7
	{
		$exit_code = "7"
		$exit_reason = "Files were copied, a file mismatch was present, and additional files were present."
		$backupState = "ERROR"
	}
    6
    {
		$exit_code = "6"
		$exit_reason = "Additional files and mismatched files exist. No files were copied and no failures were encountered. This means that the files already exist in the destination directory."
		$IncludeAdmin = $False
		$backupState = "ERROR"
    }
    5
    {
		$exit_code = "5"
		$exit_reason = "Some files were copied. Some files were mismatched. No failure was encountered."
		$IncludeAdmin = $False
		$backupState = "ERROR"
    }
	4
	{
		$exit_code = "4"
		$exit_reason = "MISMATCHED files or directories were detected.  Examine the log file for more information"
		$IncludeAdmin = $False
		$backupState = "ERROR"
	}
    3
    {
		$exit_code = "3"
		$exit_reason = "Some files were copied. Additional files were present. No failure was encountered."
		$IncludeAdmin = $False
		$backupState = "SUCCESSFULL"
    }
	2
	{
		$exit_code = "2"
		$exit_reason = "EXTRA FILES or directories were detected.  Examine the log file for more information"
		$IncludeAdmin = $False
		$backupState = "SUCCESSFULL"
	}
	1
	{
		$exit_code = "1"
		$exit_reason = "One of more files were copied SUCCESSFULLY"
		$IncludeAdmin = $False
		$backupState = "SUCCESSFULL"
	}
	0
	{
		$exit_code = "0"
		$exit_reason = "NO CHANGE occurred and no files were copied"
		$backupState = "SUCCESSFULL"
		$SendEmail = $False
		$IncludeAdmin = $False
	}
	default
	{
		$exit_code = "Unknown ($LASTEXITCODE)"
		$exit_reason = "Unknown Reason"
		$IncludeAdmin = $False
	}
}

$Subject = "[" + $customerName + "] " + "[" + $backupState + "] " + $Subject + ";" + $exit_reason + ";EC: " + $exit_code

# If the logfile exceeds a limit of 25MB, the file won't be sent as attachment, instead as content of the mail
if ((Get-ChildItem $Logfile).Length -lt 25mb)
{
	if ($IncludeAdmin)
	{
		if ($AsAttachment)
		{
			Send-MailMessage -From $Sender -To $Recipients -Cc $Admin -Subject $Subject -Body "Robocopy results are attached." -Attachment $Logfile -DeliveryNotificationOption onFailure -SmtpServer $SMTPServer
		} else {
			Send-MailMessage -From $Sender -To $Recipients -Cc $Admin -Subject $Subject -Body (Get-Content $LogFile | Out-String) -DeliveryNotificationOption onFailure -SmtpServer $SMTPServer
		}
	} else {
		if ($AsAttachment)
		{
			Send-MailMessage -From $Sender -To $Recipients -Subject $Subject -Body "Robocopy results are attached." -Attachment $Logfile -DeliveryNotificationOption onFailure -SmtpServer $SMTPServer
		} else {
			Send-MailMessage -From $Sender -To $Recipients -Subject $Subject -Body (Get-Content $LogFile | Out-String) -DeliveryNotificationOption onFailure -SmtpServer $SMTPServer
		}
	}
} else {
	$Body = "Logfile was too large to send." + (Get-Content $LogFile -TotalCount 15 | Out-String) + (Get-Content $LogFile | Select-Object -Last 13 | Out-String)
	
	Send-MailMessage -From $Sender -To $Recipients -Cc $Admin -Subject $Subject -Body $Body -DeliveryNotificationOption onFailure -SmtpServer $SMTPServer
}

# Removing the logfile after sending it per email
Remove-Item $Logfile

#*=============================================
#* END OF SCRIPT: Copy-RobocopyAndEmail.ps1
#*=============================================