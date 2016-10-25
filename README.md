# How to Have its dotnet application hosted on a docker (on nano server) ?

## Install NanoServer

I've install nano server on a Hyper-V. 
But you can install it where you want.

Once it's installed we will run windows update in our nano server.

### Windows Update

```bash
$sess = New-CimInstance -Namespace root/Microsoft/Windows/WindowsUpdate -ClassName MSFT_WUOperationsSession
Invoke-CimMethod -InputObject $sess -MethodName ApplyApplicableUpdates
```

Once the updates are installed

```bash
Restart-Computer
```

### Install Docker

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

## Access to your NanoServer on Remote

It's cool to have its own Nano Server BUT, i hate to don't be able to copy/paste commands, and I don't want to create all my projects by command line.

Let's activate the remoting ...

### Connecting to your Nano Server Instance using PowerShell Remoting

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

### Create a Shared Space on your Nano Server

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

## Let's create our first webapi that run in a docker.

### Create a WebApi

//todo

### Create the Dockerfile

//todo

## Do the magic docker things

//todo


