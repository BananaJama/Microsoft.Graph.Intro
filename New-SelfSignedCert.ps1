$Splat = @{
    FriendlyName = 'PowerShell Automation'
    NotBefore = Get-Date
    NotAfter = ((Get-Date).AddYears(2))
    DnsName = 'PoShAutomate.chrimeny.com'
    Subject = 'PoShAutomate.chrimeny.com'
}
$Cert = New-SelfSignedCertificate @Splat
$Cert | Format-List