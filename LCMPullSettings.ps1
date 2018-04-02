#below configuraiton sets the LCM to Pull mode

[DscLocalConfigurationManager()]
Configuration LCMConfig {

    #$AllNodes is an automatic variable available via configuration data
    Node $AllNodes.NodeName {
        
        Settings {
            RefreshMode = 'Pull'
            CertificateID = 'C5BCEA6E103E4D50AD9FF951DD0D61AB4C800F44'
        }
        
        ConfigurationRepositoryWeb PullServerDetail {
            
            AllowUnsecureConnection = $false
            ServerURL = "https://scom2016.mylab.lab:8080/PSDSCPullServer.svc"
            RegistrationKey = '150c00d2-b743-42ec-9a67-58a04f6d245d'
            ConfigurationNames = @('DC')

        }
        
        ResourceRepositoryWeb MouduleSource {
            
            AllowUnsecureConnection = $false
            ServerURL = "https://scom2016.mylab.lab:8080/PSDSCPullServer.svc"
            RegistrationKey = '150c00d2-b743-42ec-9a67-58a04f6d245d'

        }    

        ReportServerWeb CheckPoint {
        
            AllowUnsecureConnection = $false
            ServerURL =  "https://scom2016.mylab.lab:8080/PSDSCPullServer"
            RegistrationKey =  '150c00d2-b743-42ec-9a67-58a04f6d245d'
            
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

LCMConfig -OutputPath C:\Data\PowerShell -ConfigurationData $ConfigData 

Set-DscLocalConfigurationManager -ComputerName dc -Path C:\Data\PowerShell -Verbose 