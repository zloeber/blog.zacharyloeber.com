---
title: A Hacker’s Home Network Part 2/3
author: Zachary Loeber
type: post
date: 2008-07-01T16:22:13+00:00
draft: true
url: /blog/2008/07/01/a-hackers-home-network-part-2/
categories:
  - Cisco
  - Linux
  - Networking

---
In my last post I discussed pros and cons of setting up a managed switch between your firewall and the Internet. Here I will finish the rest of the switch configuration.
  
<!--more-->


  
My configuration looks something like the following. For brevity sake I removed all unused interfaces. I also didn&#8217;t password protect anything on the switch but you can easily do this. As the management vlan is never connected to the outside world there are no immediate dangers but if someone were to say, break your insecure wireless WEP key and get internal access then you might be in trouble. I&#8217;ll leave setting up the password as an exercise for the reader 🙂 If you are unfamiliar with Cisco commands you can start out by entering the enable mode by typing &#8220;enable&#8221; at the command line and pressing enter. Then after initially connecting to the switch and enter &#8220;config t&#8221; to go into configuration mode. From here you can enter in the configuration below pretty much line by line.

`no service pad<br />
no service config<br />
service timestamps debug uptime<br />
service timestamps log uptime<br />
no service password-encryption<br />
hostname Switch<br />
no spanning-tree vlan 1<br />
no spanning-tree vlan 2<br />
ip subnet-zero<br />
no ip finger<br />
no cdp run<br />
interface FastEthernet0/9<br />
description DMZ LINK<br />
switchport access vlan 2<br />
no cdp enable<br />
interface FastEthernet0/10<br />
description FIREWALL LINK<br />
switchport access vlan 2<br />
no cdp enable<br />
interface FastEthernet0/11<br />
description SHADOW LINK<br />
no arp arpa<br />
port monitor FastEthernet0/12<br />
switchport access vlan 2<br />
no cdp enable<br />
interface FastEthernet0/12<br />
description INTERNET LINK<br />
switchport access vlan 2<br />
spanning-tree portfast<br />
no cdp enable<br />
interface VLAN1<br />
ip address 192.168.1.200 255.255.255.0<br />
no ip directed-broadcast<br />
no ip route-cache<br />
interface VLAN2<br />
no ip directed-broadcast<br />
no ip route-cache<br />
shutdown<br />
` 

OK, most of the switch configuration is taken care of now. If you see that the last VLAN statement shows as &#8220;shutdown&#8221; that is just because the vlan interfaces are used for management and isn&#8217;t actually a live interface. As I set the IP address on VLAN1, it is the management interface in this case. Also, for our chosen sniffing interface, Fa0/11, notice the &#8220;no arpa&#8221; command. This effectively disables arp on that interface. Why would I want to do this? The answer is that any broadcast arp request on any other interface in that vlan will be sent out that interface and our desire is to be as stealthy as possible. (Note: As I&#8217;ll only be using this port for monitoring it should never send any traffic anyways)

I personally used the last ports on my 12 port device for this project. A big reminder that the port that you use for the internet link to your cable modem or dsl device will probably require a cross-over cable. Save some money and make your own 😉

So my setup is as follows:
  
port 12 -> attached to cable modem/dsl device
  
port 11 -> attached to server or device that will be sniffing traffic, it is set to monitor port 12
  
port 10 -> attached to wan port on firewall router (in my case the linksys wrt54g)
  
port9 -> attached to a disabled nic on my sniffing box for a future project

Now everything is pretty much all setup and you can start adding devices as you see fit to act as a sniffer on port 11 or as a regular device on the external network on port 9. You can also use the switch as an extension to your firewall router by plugging a patch cable from any of the other ports to the firewall router. By default the other ports on the switch are on vlan1 and should be &#8220;safe&#8221;. Safe is a relative term in this case because of the fact that there is a possibility of your cam address table flooding with a specific kind of attack you will not want just just plug things into VLAN1 that are not protected in some way. You can see how many arp addresses are in the table with the following command in enable mode:

`show mac-address-table<br />
Switch#sh mac-address-table count<br />
Dynamic Address Count:                 2<br />
Secure Address (User-defined) Count:   0<br />
Static Address (User-defined) Count:   0<br />
System Self Address Count:             37<br />
Total MAC addresses:                   39<br />
Maximum MAC addresses:                 2048<br />
` 

Also, do not forget to make sure your DHCP server is not doling out the address that you are using for your management interface on the switch.

Finally, **a big reminder** to release the current IP address you have obtained from your ISP from your firewall/router device before disconnecting it to put this switch in place. Many ISPs will register one IP address to one MAC address. As you will be changing the physical media between the ISP and your router to be switched your new mac address will show up as the address from the switch and not your router. In fact, if you want to be just a little bit more tricky you can install a program on Linux called macchanger then run

`macchanger -l`

to list out different vendor mac addresses like this one:

`7129 - 00:e0:7e - Walt Disney Imagineering`

Then log in to your cisco switch and change the wan ports hardware address to be something like:

`00:e0:7e:01:02:03`

To make your device look like some crazy piece of equipment no one has ever heard of before. Sure it only really can be seen by someone on your local loop but what the hell? Either way, release your IP first.

This is all just setting the stage for your future projects. Next up I&#8217;ll go over how I setup my Linux &#8220;Shadowbox&#8221; as one of these projects.