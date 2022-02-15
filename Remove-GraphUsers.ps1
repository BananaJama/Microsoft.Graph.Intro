$DemoUsers = Get-MgUser -Filter "JobTitle eq 'Temp'"

$DemoUsers | ForEach-Object -Parallel {
    Remove-MgUser -UserId $_.Id
}