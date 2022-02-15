$Groups = @(
    'Production',
    'Research and Development',
    'Purchasing',
    'Marketing',
    'Human Resource',
    'Management',
    'Accounting and Finance',
    'Information Technology'
)

$Groups | ForEach-Object -Parallel {
    $Splat = @{
        DisplayName = "$_"
        SecurityEnabled = $true
        MailEnabled = $false
        MailNickName = "$($_.Replace(' ',''))"

    }
    New-MgGroup @Splat
}