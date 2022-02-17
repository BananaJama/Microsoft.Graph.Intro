$Splat = @{
    FilePath = 'C:\git-personal\Microsoft.Graph.Intro\SelfSignedCert.pfx' 
    Password = (ConvertTo-SecureString -AsPlainText -Force -String 'SecurePassword')
}
$Cert = Get-PfxCertificate @Splat
# $Cert | Format-List

$Splat = @{
    ClientId = '6300e930-22a1-4313-aa71-3a1e62fce15d'
    TenantId = 'fb24bda8-d77a-4f50-8f02-d6464359cc27'
    Certificate = $Cert
}
Connect-Graph @Splat