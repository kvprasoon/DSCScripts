#$Guid = [Guid]::NewGuid()

Configuration DSCPUllServer {

    Param(
        [String]$NodeName = $env:COMPUTERNAME,

        [ValidateNotNullOrEmpty()]
        [String]$CertificateThumbprint,

        [ValidateNotNullOrEmpty()]
        [String]$RegistrationKey
    )

    #This module explicit import is required for the xDSCWebService
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    
    Node $NodeName {
        
        #Enables the DSC service
        WindowsFeature DSService {
            Name = 'DSC-Service'
            Ensure = 'Present'
        }

        #creates the DSC Webservice
        xDSCWebService PSDSCPullServer {
            Ensure = 'Present'
            EndpointName = 'PSDSCPullServer'
            Port = 8080
            PhysicalPath = "C:\inetpub\PSDSCPullServer"
            CertificateThumbPrint = $CertificateThumbprint
            ModulePath = "C:\Program Files\WindowsPowerShell\DSCService\Modules"
            ConfigurationPath = "C:\Program Files\WindowsPowerShell\DscService\Configuration"
            State = 'Started'
            DependsOn = '[WindowsFeature]DSService'
            UseSecurityBestPractices = $False
            DisableSecurityBestPractices = 'SecureTLSProtocols'
        }


        #Creates the registration key file whcich will be used by th clients to login to pull the configurations
        File RegistrationKeyFile {
            Ensure = 'Present'
            Type =  'File'
            DestinationPath =  "C:\Program Files\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents = $RegistrationKey
        }
    }

}

#This gets the certifcate thumbprint created for the DSC web service
$CertThumprint = (ls Cert:\LocalMachine\my | ? subject -eq 'CN=*.mylab.lab').Thumbprint

#Creates the mof file
DSCPUllServer -CertificateThumbprint $CertThumprint -NodeName $env:COMPUTERNAME -RegistrationKey $Guid -OutputPath C:\Data\PowerShell

Start-DscConfiguration -Path C:\Data\PowerShell -Wait -Force -Verbose

$Guid.Guid|clip