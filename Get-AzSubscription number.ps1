
$AllSubscriptions = Get-AzSubscription | Out-String
Write-Host $AllSubscriptions
$AllSubscriptions=Get-AzSubscription
$Context = Read-Host "In which context you want to proceed ? (1 first line, 2 second line etc.)"
$Context = $Context -1
if ($Context -lt $AllSubscriptions.length) {
    Set-AzContext $AllSubscriptions[$Context]
    #Get-azcontext
}else {$test = $AllSubscriptions.length;Write-Host "ERROR : context number not valid. must be between 0 and "$test}