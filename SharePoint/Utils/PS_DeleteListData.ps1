############################################################################################################################################
# This script allows to delete data from a list.
# Required parameters
#   ->$siteUrl: Site Collection url
#   ->$sListName: List Name.
############################################################################################################################################
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

$host.Runspace.ThreadOptions = "ReuseThread"

#Variables necesarias
$sSiteUrl = “http://demo2010a:90/sites/IntranetMM/”

#Function that allows to delete all the items in a list
function Delete-ListData
{
    param ($sListName)
    try
    {
        $spSite = Get-SPSite -Identity $sSiteUrl
        $spWeb = $spSite.OpenWeb()
        
        #Verifying if the list exists  
        $lList=$spWeb.Lists[$sListName]
        If (($lList)) 
        {         
            Write-host "The list $($lList.Title) has $($lList.Items.Count) records. Starting the delete process!!!" -foregroundcolor blue
            $liItems = $lList.items
            foreach ($liItem in $liItems)
            {
                Write-host "Borrando el elemento $($liItem.Title)" -foregroundcolor blue
                $lList.GetItemByID($liItem.ID).Delete()
            }            
            Write-Host "-----------------------------------------"  -foregroundcolor Blue
            Write-Host "Delete process completed!!!" -foregroundcolor Blue
        
        }else
        {
            Write-Host "The list $sListName doesn't exist ..." -foregroundcolor Red
            exit
        }        
        #Objects disposal
        $spWeb.Dispose()
        $spSite.Dispose()     
  
    }
    catch [System.Exception]
    {
        write-host -f red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global

Delete-ListData -sListName "Contactos"
Stop-SPAssignment –Global

Remove-PSSnapin Microsoft.SharePoint.PowerShell