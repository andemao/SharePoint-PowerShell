############################################################################################################################################
# This script recursively deletes all the sites inside a site collection. The site collection itself is not deleted.
# Required parameters
#   ->$siteCollUrl: Site Collection Url.
############################################################################################################################################
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null ) 
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell }

$host.Runspace.ThreadOptions = "ReuseThread"# Se crea el la aplicación del portal

#Definition of the function to delete all the sites in a site collection
function Delete-Sites([Microsoft.SharePoint.SPWeb] $spWeb)
{   
    try
    { 
	#Getting all the sites in the site collection
        $spsubWebs = $spWeb.GetSubwebsForCurrentUser()

    	#We delete each site in the site collecion
        foreach($spsubWeb in $spsubWebs)
        {
            Delete-Sites($spsubWeb)        
            $spsubWeb.Dispose()
        }        
        #We delete all sites except the root site
        if($spWeb.Url -ne $sSiteCollUrl)        
        {
            Write-Host -f blue "Deleting the site ($($spWeb.Url))..." 
            Remove-SPWeb $spWeb -Confirm:$false
        }
    }
    catch [System.Exception]
    {
        write-host -f red $_.Exception.ToString()
    }
}

Start-SPAssignment –Global

#Parameters for the function
$sSiteCollUrl = "http://<SiteCollectionUrl>"
$spSite = Get-SPSite -Identity $sSiteCollUrl
$spWeb = $spSite.OpenWeb()

#Calling the function that deletes all the sites in a site collection
if($spWeb -ne $null)
{
    Delete-Sites $spWeb
    $spWeb.Dispose()
}
$spSite.Dispose()

Stop-SPAssignment –Global
Remove-PSSnapin Microsoft.SharePoint.PowerShell
