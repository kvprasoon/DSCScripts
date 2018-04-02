#below configuraiton sets the LCM to Pull mode

[DscLocalConfigurationManager()]
Configuration LCMConfig {
    Param($Guid)

    #$AllNodes is an automatic variable available via configuration data
    Node $AllNodes.NodeName {
        
        Settings {
            RefreshMode = 'Pull'
            CertificateID = 'C5BCEA6E103E4D50AD9FF951DD0D61AB4C800F44'
            ConfigurationID = $Guid.Guid
            ConfigurationMode = 'ApplyAndAutoCorrect'
        }
        
        ConfigurationRepositoryWeb PullServerDetail {
            
            AllowUnsecureConnection = $false
            ServerURL = "https://scom2016.mylab.lab:8080/PSDSCPullServer.svc"
            

        }
        
        ResourceRepositoryWeb MouduleSource {
            
            AllowUnsecureConnection = $false
            ServerURL = "https://scom2016.mylab.lab:8080/PSDSCPullServer.svc"
            

        }    

        ReportServerWeb CheckPoint {
        
            AllowUnsecureConnection = $false
            ServerURL =  "https://scom2016.mylab.lab/PSDSCPullServer.svc"
            
            
        }
    }

}


$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = @('dc')

        }
    )
}

#$GuidLocal = [GUID]::NewGuid()

LCMConfig -OutputPath C:\Data\PowerShell -ConfigurationData $ConfigData -Guid $GuidLocal

Set-DscLocalConfigurationManager -ComputerName dc -Path C:\Data\PowerShell -Verbose -Force