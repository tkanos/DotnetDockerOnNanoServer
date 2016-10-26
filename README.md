### How to Have its dotnet application hosted on a docker (on nano server) ?

# Install NanoServer

I've install nano server on a Hyper-V. 
And i get the ip address of my container by powershell 

```bash
(Get-VMNetworkAdapter -VMName myVMName).IpAddresses 
```

But you can install it where you want. Hyper-V, physical Machine, Virtual Box ....

Once it's installed we will run windows update in our nano server.

## Windows Update

```bash
$sess = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
Invoke-CimMethod -InputObject $sess -MethodName ApplyApplicableUpdates
```

Once the updates are installed

```bash
Restart-Computer
```

## Install Docker

```bash
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider
```

once it's done

```bash
Restart-Computer -Force
```

Now that we have finished to install docker we can test it :

```bash
docker run --rm microsoft/sample-dotnet
```

# Access to your NanoServer on Remote

It's cool to have its own Nano Server BUT, i hate to don't be able to copy/paste commands, and I don't want to create all my projects by command line.

Let's activate the remoting ...

## Connecting to your Nano Server Instance using PowerShell Remoting

On your Windows local open an elevated PowerShell window.

```bash
powershell
```

Start the WinRM service
```bash
net start WinRM
```

Add your remote Nano Server instance to your TrustedHosts list.

```bash
$nanoServerIpAddress = "NANO_SERVER_IP"
```
(of course you should replace NANO_SERVER_IP, by the ip of your Nano Server)

```bash
Set-Item WSMan:\localhost\Client\TrustedHosts "$nanoServerIpAddress" -Concatenate -Force
```

Connect by powershell :
```bash
$nanoServerSession = New-PSSession -ComputerName $nanoServerIpAddress -Credential ~\Administrator
Enter-PSSession $nanoServerSession
```

Enter the password of the Administrator account of your Nano Server.

You should have your input changed by something like :
```bash
[xx.xx.xx.xx]: PS C:\Users\Administrator\Documents>
```

So now if you run the command dir, you should see that its the content of your Nano Server directory.

## Create a Shared Space on your Nano Server

Create a directory on your Nano Server, where you will share the code you will do on your local machine.

```bash
mkdir C:\SharedCodeDirectory
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=yes
net share SharedCodeDirectory=c:\SharedCodeDirectory /GRANT:EVERYONE`,FULL
```

So now you will be able to see this directory from your windows local typing in an File explorer :
```
\\<NANO_SERVER_IP>\SharedCodeDirectory
```

# Let's create our first webapi that run in a docker.

## Create a WebApi

I've created an empty WebApi :

![Empty WebApi](https://github.com/Tkanos/DotnetDockerOnNanoServer/blob/master/img/CreateEmptyWebApi.png)

Then I create a HelloWorldController.cs, with the following code :

```csharp
[RoutePrefix("api/helloworld")]
    public class HelloWorldController : ApiController
    {
        [HttpGet]
        [Route("")]
        public string Get()
        {
            return "Hello, World !";
        }
    }
```

After have tested it, I published the code on Deploy Folder. is this code that we will deploy on our Docker.


## Create the Dockerfile

//todo

## Do the magic docker things

//todo


# Remarks

I'm really disapointed by nano server. My main goal was to deploy my .NET 4.5 application in a nano server, on docker. (I don't want to migrate them all to .net core)

```bash
FROM Microsoft/nanoserver
```
But Nano server on docker just don't support others framework than .net CORE. (it's for that I used microsoft/iis 9.48 Go WTF ?)
And I don't know what's for.
Linux has apt-get, yuml, .... to be able to start from a simple linux , and upgrade it, with others component.
Nano if it's not on the starting image you will never be able to import it on nano.
Example : If you don't start a Nano server with IIS inside, you won't be able later to import it on your docker container (WTF ?)


# Links
- [deployment Nano](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/deployment/deployment_nano)
- [ASP.NET Core on Nano Server](https://docs.asp.net/en/latest/tutorials/nano-server.html)
- [How to remote manage your Nano Server using PowerShell](http://www.thomasmaurer.ch/2015/12/how-to-remote-manage-your-nano-server-using-powershell/)
- [Windows Container on Windows Server](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/quick_start/quick_start_windows_server)
- [nanoserver/iis on DockerHub](https://hub.docker.com/r/nanoserver/iis/)
- [Run IIS Asp.Net on Windows 10 with Docker](http://blog.alexellis.io/run-iis-asp-net-on-windows-10-with-docker/)




