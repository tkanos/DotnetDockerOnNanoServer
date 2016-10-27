FROM microsoft/iis:latest
SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework-45-ASPNET ; \  
    Install-WindowsFeature Web-Asp-Net45

COPY Deploy HelloWorldApi  

RUN Remove-WebSite -Name 'Default Web Site'  
RUN New-Website -Name 'helloworld' -Port 80 \  
    -PhysicalPath 'C:\HelloWorldApi' -ApplicationPool '.NET v4.5'
	
EXPOSE 80
