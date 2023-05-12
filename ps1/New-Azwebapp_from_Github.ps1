

New-AzWebApp -ResourceGroupName ops_test_kathir -Name OpsTestSGWebApp1 -Location australiaeast  -AppServicePlan opstestappsrvcplan -Verbose

$gitrepo ="https://github.com/Azure-Samples/storage-blob-upload-from-webapp"


$webappname = (Get-AzWebApp -Name opstestsgwebapp1 -ResourceGroupName ops_test_kathir).Name


$properties = @{repourl = "$gitrepo";
                branch = "master";
                isManualintegration = "True";

}

Set-AzResource -Properties $properties -ResourceGroupName ops_test_kathir -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $webappname -Force