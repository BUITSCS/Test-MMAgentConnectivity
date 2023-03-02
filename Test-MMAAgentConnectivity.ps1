#Set workspace ID and URLs to test.  See https://docs.microsoft.com/en-us/azure/automation/automation-network-configuration
$OPSINSIGHTS_WS_ID = "d112f5b1-168b-4b4d-9c15-8a271a64a587"
$Test1 = $OPSINSIGHTS_WS_ID + ".ods.opinsights.azure.com"
$Test2 = $OPSINSIGHTS_WS_ID + ".oms.opinsights.azure.com"
$Test3 = $OPSINSIGHTS_WS_ID + ".agentsvc.azure-automation.net"
$Test4 = "scadvisorcontent.blob.core.windows.net"

$WorkspaceTests = @()
$WorkspaceTests += $Test1
$WorkspaceTests += $Test2
$WorkspaceTests += $Test3

$AllTestSuccess = $true
$NoWorkspaceTestsSucceeded = $true
Write-Host "Disregard any WARNING: Ping messages that follow."
Write-Host "These warnings indicate that ICMP/ping failed, which is not necessary for connection to a Log Analytics workspace."
Write-Host ""

#Check all workspace URLs
foreach ($Test in $WorkspaceTests) {
    $TNCReturn = tnc $Test -port 443
    Write-Host "Testing connection on port 443 to the following workspace: $Test"
    if ($TNCReturn.TcpTestSucceeded -ne $true) {
        $AllTestSuccess = $false
        Write-Host -ForegroundColor Red "Failure!"
        Write-Host ""
    }
    else {
        $NoWorkspaceTestsSucceeded = $false
        Write-Host -ForegroundColor Green "Success!"
        Write-Host ""
    }
}

#Check 
$TNCReturn = tnc $Test4 -port 443
Write-Host "Testing connection on port 443 to: $Test4"
if ($TNCReturn.TcpTestSucceeded -ne $true) {
    $AllTestSuccess = $false
    Write-Host -ForegroundColor Red "Failure!"
    Write-Host ""
}
else {
    Write-Host -ForegroundColor Green "Success!"
    Write-Host ""
}

if ($AllTestSuccess) {
    Write-Host -ForegroundColor Green "All connectivity tests succeeded! No gateway required for this server."
}
elseif (-not $NoWorkspaceTestsSucceeded) {
    Write-Host -ForegroundColor Red "!!One or more connectivity tests failed!!"
    Write-Host "Networking changes or a Log Analytics gateway may be required for this server."
}
else {
    Write-Host -ForegroundColor Red "!!All workspace connectivity tests failed!!"
    Write-Host "Verify that the correct workspace ID of your Log Analytics workspace is used in this script: $OPSINSIGHTS_WS_ID"
    Write-Host "If the Workspace ID is correct and these tests succeed on other devices, networking changes or a Log Analytics gateway may be required for this server."
}