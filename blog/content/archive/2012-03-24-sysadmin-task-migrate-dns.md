---
title: 'Sysadmin Task: Migrate DNS'
author: Zachary Loeber
type: post
date: 2012-03-24T16:07:54+00:00
excerpt: "I've migrated DNS servers more than a few times and find that I'm doing the same tasks or using the same custom scripts over and over again. Here is my quick and dirty task list with some powershell scripts you too might find of use."
url: /blog/2012/03/24/sysadmin-task-migrate-dns/
categories:
  - Active Directory
  - Linux
  - Microsoft
  - Networking
  - Powershell
  - System Administration

---
I&#8217;ve migrated DNS servers more than a few times and find that I&#8217;m doing the same tasks or using the same custom scripts over and over again. Here is my quick and dirty task list with some powershell scripts you too might find of use. As there are a hundred ways to skin this cat I don&#8217;t claim my methods to be the best but they sure are fast and far easier than manually changing a dns address on hundreds of servers, workstations, and network devices.

<!--more-->

## Introduction

Why would you need to change your Domain&#8217;s DNS servers? Well if you are upgrading from an old 2003 (or older!) Domain Controller it may just be easier for you to erect a new DC and then slowly phase out the older DC. Or maybe you have no choice and your DC dies and you need to quickly get people access to the Internet to update their precious Facebook profile. Regardless of the reasoning, I abjectly refuse to manually change a bunch of network card DNS server search lists, and so should you. With a bit of powershell and some basic copy/paste batching you can very quickly change (or god forbid, standardize) the DNS servers being used in a homogeneous environment. In a heterogeneous environment the same concepts still apply, just the methodology of updating the DNS servers differ (I&#8217;ll cover that towards the end). This is written towards a Microsoft technology slant but I have done BIND server replacements and upgrades as well, just not as often as I have done DC upgrades and migrations 🙂

## Checklist

### Windows Servers/Workstations

Ideally you are adding a new DNS server (or DC) and then decomissioning the old server. If not then at least make certain that your primary DNS server is listed first for all of your clients. In a larger Windows environment this can be a pain in the rear. I used to use vbscript but have since &#8220;evolved&#8221; to powershell for this task. You may think you know every computer in your environment but who knows which workstations and servers have had incorrect or old DNS servers statically set in their configuration. To find out first you need to know what systems are in your environment. I could have written some scripts to pull out all the computers in an AD forest but what I do with that list is a bit manual anyways so instead I use one of the great tools I <a title="Active Directory Essential Tools" href="/2011/08/11/active-directory-essential-tools/" target="_blank">previously mentioned</a>, <a title="AD Info" href="http://www.cjwdev.co.uk/Software/ADReportingTool/Info.html" target="_blank">AD Info</a>. I pull a report of all computers in the environment with the OS, Last Password Changed, if they are disabled, and obviously the name.

Once I&#8217;ve exported the CSV I go through is in excel and delete any computers with a password last changed over 90 days or which are disabled as they have bigger issues than their preferred DNS servers if they are still actually running. I then determine the scope of my goal. If the environment is large and there is worry that some workstations may have manual settings in place I pretty much am done filtering my list and then copy out all of the server names into a TXT file for my next steps. Otherwise I may split out workstations and servers and simply focus on the server OSes. That is a judgement call you will have to make.

> Note: In a heterogeneous environment with multiple domains or even workgroups you will have to do this process for each group of disparate servers.

Now that we have a TXT file with your domain joined compuers lets find out just how messed up they are in their DNS search order configuration. As we are going through this effort we may as well grab if they are DHCP clients as well as gather some other interesting info. Here is the powershell script I feed my server/workstation list into to get all the interface information. Notice it will grab all interfaces which are live as well as skip over those devices which cannot be connected to via WMI. What that means is any one-off system with issues (ie. too restrictive of a firewall or it is flat out offline or outside of the network) or that you cannot authenticate to for which ever reason still will need some manual configuration love later on down the line. As I&#8217;m often on a client network with my company laptop I also prompt for domain credentials.

<pre>$credential = Get-Credential

Get-Content .\computers.txt | `
ForEach-Object {
    # First test if we can connect to the server
    if(Test-Connection -ComputerName $_ -Count 1 -ea 0) {
        # Using WMI connect to the computer and gather nic info for
        Get-WMIObject Win32_NetworkAdapterConfiguration -ErrorAction SilentlyContinue `
        -Credential $credential -Computername $_ | `
        Where-Object {$_.IPEnabled -match "True"} | `
        Select-Object -property DNSHostName,
                            @{N='DNS Suffix Search Order';E={$_.DNSDomainSuffixSearchOrder}},
                            Index,
                            Description,
                            @{N='IP Address';E={$_.IPAddress}},
                            @{N='Subnet';E={$_.IPSubnet}},
                            @{N='Default Gateway';E={$_.DefaultIPGateway}},
                            @{N='DHCP Enabled';
                              E={$_.DHCPEnabled}},
                            @{N="DNSServerSearchOrder";
                              E={$_.DNSServerSearchOrder}},
                            @{N="Mac Address";E={$_.MACAddress}}
    }
} | Export-CSV -NoTypeInformation Computer-IPs.csv</pre>

Once we have Computer-IPs.csv I then go through it with excel and remove any items which came up with no DNS information (such as a multi-homed servers and such) or which are workstations that get their DNS info from DHCP. We can also remove any rows with correct DNS information already set and update those which are not set correctly (obviously adding in our new DNS server).

> This is a good time to check if you have any servers pulling from DHCP or any workstations with static assignments. This is one of the reasons I&#8217;ll typically run this process against servers and workstations separately.
> 
> Also, be cognizant of your domain controllers. There are a few different beliefs on optimal DNS search order configuration on DCs. I&#8217;ve found that the 2008 R2 presets on a new DC to work just fine. So the DNSServerSearchOrder for a DC will typically first point to its own IP first, then to a secondary DC, and finally have a tertiary set to 127.0.0.1.

Once you have updated the DNSServerSearchOrder in the csv file for all devices to look how you like then use the same file to update the servers with powershell. I forgot where I got the original code from. If the author finds this and wants to raise their hand for credit I&#8217;ll happily give it (there is not much code here anyway).

<pre>$credential = Get-Credential
foreach ( $server in (Import-Csv "Computer-IPs.csv")) {
    $nic = Get-WmiObject -Credential $credential Win32_NetworkAdapterConfiguration `
    -ComputerName $Server.DNSHostName -ErrorAction Inquire | `
    Where{($_.IPEnabled -eq "TRUE") -and ($_.Index -eq $Server.Index)}
    Write-Host "`tExisting DNS Servers " $nic.DNSServerSearchOrder

    $NewDNSSearchOrder = $Server.DNSServerSearchOrder.Split(" ")

    $UpdateOutput = $nic.SetDNSServerSearchOrder($NewDNSSearchOrder)
    if($UpdateOutput.ReturnValue -eq 0)
    {
        Write-Host "`tSuccessfully Changed DNS Servers on " $Server.DNSHostName
    }
    else
    {
        Write-Host "`tFailed to Change DNS Servers on " $Server.DNSHostName
    }
}</pre>

There, most windows devices have been transparently updated. Now lets go over a few other items to be conscious of before you get the decommission itch in your pants.

### Check Your Non-Windows Clients

By Non-Windows I mean your infrastructure devices and possibly even your Linux devices. Here is a generic list to go through. I don&#8217;t have a script for every possible device out there so you are on your own for a good portion of these.

#### Linux Servers

If you have Linux in your environment usually you know exactly which servers run it. You also probably have a smattering of different distributions and versions running. The good thing is that name resolution is pretty much handled the same across the board. You simply need to edit /etc/resolv.conf and restart networking. I&#8217;d play it safe though and just reboot the entire server as some java based services will pre-cache the resolution servers and not update when you update the resolv.conf file. Besides, have to reboot them sometimes. Hell, run some updates while you are at it why don&#8217;t ya? If you are updating a whole bunch of servers <a title="Multi-Tabbed Putty" href="http://linuxpoison.blogspot.com/2011/08/multi-tabbed-putty-mtputty.html" target="_blank">you can use something like MTPutty</a> to make things a bit less tedious.

#### Firewalls

If you are passing through DNS on your VPN you may all of a sudden have a bunch of remote users not able to access their file shares and such. So check not only the general DNS settings of the device but the VPN settings as well.

#### BSD

(aka. Your marketing department&#8217;s Macs)

#### Routers/Switches

If you are also migrating a DHCP server then you will want to verify that all of your VLAN helper addresses are set correctly as well. If you have a ton of them then you may just want to put together some poor man&#8217;s hack. First go to each device and copy out the vlan configurations which you will be updating then put together a text file that looks something like this for each one:

<pre>telnet 10.10.10.10</pre>

<pre>&lt;telnet pass&gt;</pre>

<pre>en</pre>

<pre>&lt;enable pass&gt;</pre>

<pre>conf t</pre>

<pre>int vlan90</pre>

<pre>ip helper-address 10.20.20.20</pre>

<pre>no ip helper-address 172.16.0.40</pre>

<pre>int vlan100</pre>

<pre>ip helper-address 10.20.20.20</pre>

<pre>no ip helper-address 172.16.0.40</pre>

<pre>int vlan101</pre>

<pre>ip helper-address 10.20.20.20</pre>

<pre>no ip helper-address 172.16.0.40</pre>

<pre>exit</pre>

<pre>exit</pre>

<pre>write</pre>

<pre>exit</pre>

Then just past the text file into a cmd.exe prompt.

#### Everything Else

Don&#8217;t forget these devices

  1. ESX Hosts
  2. NAS Devices
  3. SAN Devices
  4. Printers
  5. Wireless Access Points

## Conclusion

That should get your network almost 99% of the way towards a successful DNS server migration. Even if you are not migrating DNS servers I&#8217;d recommend taking stock of how things are resolving in your environment to ensure they are as uniform as possible. Uniformity leads to predictability and I like a predictable network, I bet you do as well 🙂