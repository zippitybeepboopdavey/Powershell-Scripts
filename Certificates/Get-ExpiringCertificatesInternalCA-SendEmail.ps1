$path = $PSScriptRoot

# Get the first date of the month.
$today = Get-Date
$lastDay = [DateTime]::DaysInMonth($today.Year, $today.Month)
$firstDate = [DateTime]::new($today.Year, $today.Month, 1)
# Get the last date of the month.
$lastDate = [DateTime]::new($today.Year, $today.Month, $lastDay)
# Execute the certutil command.
certutil -view -restrict "NotAfter<=$lastDate,NotAfter>=$firstDate" -out "RequestID,RequesterName,CommonName,Certificate Expiration Date" csv > C:\Scripts\Output\ExpiringCerts.csv
# Import the CSV and delimit by commas.
$csv = Import-csv C:\Scripts\Output\ExpiringCerts.csv -Delimiter ","
# Export the adjusted CSV to a new CSV output
$csv | Export-csv C:\Scripts\Output\ExpiringCertificates.csv -NoTypeInformation

$file = "$path\Output\ExpiringCertificates.csv"

#variable for users email
$Email = "recipient@email.com"
#Variable for users Display Name
$Name = $User.DisplayName

 #Variable for the server name
$emailSmtpServer = ""

#Variable for server port
$emailSmtpServerPort = "25"
 
#This is where the email will be sent from
$emailFrom = "NoReply@email.com"

#this is the variable which will store the email that the message will be sent to. 
$emailTo = $Email
#The email that will be CC'd
$emailcc="user@email.com, user@email.com"
 
# ??? Question
$emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )

# ?? Question
$emailMessage.cc.add($emailcc)
$emailMessage.Subject = "Internal Certificate Expirations" 

$att = new-object Net.Mail.Attachment($file)

$emailMessage.Attachments.Add($att)

# The standard email the end user will receive.
$body = @"
This is a list of users within the domain that have passwords expiring within the next 7 days starting from ${firstDate} and ending on ${lastDate}.
"@
$emailMessage.Body = $body
 
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient.EnableSsl = $False
#$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass )
$SMTPClient.Send( $emailMessage )
