############################################################################################################################################
# Script to configure outgoing e-mail in SharePoint at the Web Application Level
# Required Parameters: 
#    ->$sWebAppName: Web Application Name.
#    ->$sSMTPServer: SMTP Server.
#    ->$sFromEMail: From Address.
#    ->$sReplyEMail: To Address.
#    ->$sChartSet: Character Set.
############################################################################################################################################
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

$host.Runspace.ThreadOptions = "ReuseThread"

#Definition of the function that configures outgoing e-mail at the Web Application level in SharePoint
function Configure-OutGoingEMailWebAppLevel
{
    param ($sWebAppName,$sSMTPServer,$sFromEMail,$sReplyEmail,$sCharSet)
    try
    {   
        $spWebApp = Get-SPWebApplication -Identity $sWebAppName        
        $spWebApp.UpdateMailSettings($sSMTPServer, $sFromEMail, $sReplyEmail, $sCharSet)
        write-host -f Green "Outgoing e-mail configured"               
    }
    catch [System.Exception]
    {
        write-host -f red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global

#Required Parameters
$sWebAppName="<Web_App_Name>"
$sSMTPServer="<SMTP_Server>"
$sFromEMail="<From_EMail>"
$sReplyEmail="<Reply_EMail>"
$sChartSet=65001

#Calling SharePoint
Configure-OutGoingEMailWebAppLevel -sWebAppName $sWebAppName -sSMTPServer $sSMTPServer -sFromEMail $sFromEMail -sReplyEmail $sReplyEmail -sCharSet $sChartSet

Stop-SPAssignment –Global

Remove-PsSnapin Microsoft.SharePoint.PowerShell