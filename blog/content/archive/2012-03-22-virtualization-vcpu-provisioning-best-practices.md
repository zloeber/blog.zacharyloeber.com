---
title: 'Virtualization: vCPU Provisioning Best Practices'
author: Zachary Loeber
type: post
date: 2012-03-23T01:31:47+00:00
excerpt: I had always been of the mindset that when provisioning new VMs it is best to start out with less vCPUs and add more as they are required. That is not necessarily wrong but it is not the whole picture of what is best practice.
url: /blog/2012/03/22/virtualization-vcpu-provisioning-best-practices/
categories:
  - Microsoft
  - Networking
  - Virtualization
  - VMware
tags:
  - hyper-v
  - network administration
  - virtualization
  - vmware

---
I had always been of the mindset that when provisioning new VMs it is best to start out with less vCPUs and add more as they are required (unless you specifically know that you will be using and needing more for such things as sql server or exchange). I had even recently felt some vindication of this provisioning best practice in reading a book recently ([Critical VMware Mistakes You Should Avoid][1]) <!--more-->

One of my bright coworkers pointed out that the single vCPU mindset is antiquated and to check my facts. So I did and found out that the validation I received from the prior mentioned book (which is still a great read) is a bit skewed by the fact that the book does not appear to be written with some of the changes introduced in esx 4.1 and 5.0. Also some relatively recent processor improvements such as the [NUMA architecture][2] have made vCPU over-provisioning not as much of a concern (but even these advances sometimes require an [artful balance of resources][3] to achieve optimal performance).  Regardless, I don&#8217;t believe that my less is more mindset with vCPU provisioning is wrong. But I did a bit of research and found that the answer of what is &#8220;best practice&#8221; for deploying new VMs is a bit more complex than simply assigning less or more CPUs (why can’t anything be easy?).

Although VMware and Hyper-V are different beasts I found some similarities between the two when it comes to vCPU allocation, I&#8217;m making the assertion that what I’m writing about applies to both platforms. So until I read or hear otherwise, I&#8217;m following the new mantra of &#8220;less is more, with caveats&#8221; for both VMware and Hyper-V.

In my old-fart mindset of provisioning vCPUs I believe that you can provision no more processors than you have cpu cores on a physical host. And that for each VM provisioned, a host needed to wait for enough cores to free up to exactly match the number of VM provisioned vCPUs for each CPU cycle that the VM required. If the required number of cores are not available then the VM literally is in a form of stasis.

And that is generally true and is a 100 yard view of how hypervisors work. Even in ESXi 5.0 you cannot provision more vCPUs than you have on a host. In my home lab I have two Intel i7 based hosts with hyperthreading enabled to give me a total of 8 cores per host. Even though VMware will let me provision a VM with 16 vCPUs the moment I go into the VM&#8217;s config and select the CPUs I get the following error:

<div id="attachment_497" style="width: 310px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/03/vCPU-Error.png"><img class="size-medium wp-image-497" title="vCPU-Error" alt="vCPU Provisioning Error" src="/wp-content/uploads/2012/03/vCPU-Error-300x236.png?resize=300%2C236" width="300" height="236" srcset="/wp-content/uploads/2012/03/vCPU-Error.png?resize=300%2C236 300w, wp-content/uploads/2012/03/vCPU-Error.png?w=375 375w" sizes="(max-width: 300px) 100vw, 300px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    vCPU Provisioning Error
  </p>
</div>

If I scale back the number of virtual sockets and try to assign more cores, I&#8217;m limited to a combination which adds up to no more than 8 cores:

<div id="attachment_498" style="width: 309px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/03/vCPU-Assignment1.png"><img class="size-full wp-image-498" title="vCPU-Assignment1" alt="vCPU Assignement 1" src="/wp-content/uploads/2012/03/vCPU-Assignment1.png?resize=299%2C171" width="299" height="171" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    vCPU Assignement 1
  </p>
</div>

&nbsp;

<div id="attachment_499" style="width: 313px" class="wp-caption alignnone">
  <a href="/wp-content/uploads/2012/03/vCPU-Assignment2.png"><img class="size-full wp-image-499" title="vCPU-Assignment2" alt="vCPU Assignement 2" src="/wp-content/uploads/2012/03/vCPU-Assignment2.png?resize=303%2C171" width="303" height="171" srcset="/wp-content/uploads/2012/03/vCPU-Assignment2.png?w=303 303w, wp-content/uploads/2012/03/vCPU-Assignment2.png?resize=300%2C169 300w" sizes="(max-width: 303px) 100vw, 303px" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    vCPU Assignement 2
  </p>
</div>

So in my environment I could have four 2-vcpu VMs on each host and theoretically never have any contention for host CPU resources. Any more than that and we start having issues with [CPU Ready][4] and thus start incurring some performance hits on our VMs as they wait for cores to be available for their processing task.

But that is not why you spend all kinds of money and time on your virtual architecture right? I want to be able to jam at least 20-30 (or more!) VMs per host and max out my density to brag to all my peers! If that is what you are aiming to do then start at the beginning of your virtual infrastructure deployment and be selective on how you provision your resources and you may be able to get some killer host density (although I&#8217;m not sure I&#8217;d brag about that, if you cannot vmotion VMs to other hosts and still have them be able to handle the load then you lose some of the prime benefits of virtualization!).

So, the general rule is that less is more, with caveats. Lets cover exactly where you need to look at vCPU provisioning for trying to get the fine balance between VM to host density and VM performance.

## Less Is More

On older VMs (Windows 2000 and before) I would say that VMware generally recommends my prior sentiment that less is  more. This is due to the OS being uni-processor (single-core) based.

[Performance Best Practices for vSphere 5.0][5] – Pages 19 – 20

> Configuring a virtual machine with more virtual CPUs (vCPUs) than its workload can use might cause slightly increased resource usage, potentially impacting performance on very heavily loaded systems. Common examples of this include a single-threaded workload running in a multiple-vCPU virtual machine or a multi-threaded workload in a virtual machine with more vCPUs than the workload can effectively use.
> 
> Even if the guest operating system doesn’t use some of its vCPUs, configuring virtual machines with those vCPUs still imposes some small resource requirements on ESXi that translate to real CPU consumption on the host. For example:
> 
>   * Unused vCPUs still consume timer interrupts in some guest operating systems. (Though this is not true with “tickless timer” kernels, described in  “Guest Operating System CPU Considerations” on page 39.)
> 
>   * Maintaining a consistent memory view among multiple vCPUs can consume additional resources, both in the guest operating system and in ESXi. (Though hardware-assisted MMU virtualization significantly reduces this cost.)
> 
>   * Most guest operating systems execute an idle loop during periods of inactivity. Within this loop, most of these guest operating systems halt by executing the HLT or MWAIT instructions. Some older guest operating systems (including Windows 2000 (with certain  HALs), Solaris 8 and 9, and MS-DOS), however, use busy-waiting within their idle loops. This results in the consumption of resources that might otherwise be available for other uses (other virtual machines, the VMkernel, and so on).
> 
> ESXi automatically detects these loops and de-schedules the idle vCPU. Though this reduces the CPU overhead, it can also reduce the performance of some I/O-heavy workloads. For additional information see VMware KB articles 1077 and 2231.
> 
>   * The guest operating system’s scheduler might migrate a single-threaded workload amongst multiple vCPUs, thereby losing cache locality.
> 
> _**These resource requirements translate to real CPU consumption on the host.**_

For Hyper-V Microsoft is a bit more to the point on how you should provision processors, they flat out say that less is more in their Windows 2008 Performance Optimization Guide:

[Performance Tuning Guidelines for Windows Server 2008][6] &#8211; Page 64

>   * Processors.
> 
> <p style="padding-left: 30px;">
>   Hyper-V in Windows Server 2008 supports up to 16 logical processors and can use all logical processors if the number of active virtual processors matches that of logical processors. This can reduce the rate of context switching between virtual processors and can yield better performance overall. To enable support for 24 logical processors, see the Hyper-V update in &#8220;Resources.&#8221;
> </p>

&nbsp;

That is straight from the horse&#8217;s mouth. So if you are P2Ving an old server or have a bunch of them in a VM environment which is having performance issues (why the heck would you be deploying a new Windows 2000 or NT server anyway?) then you need to take a serious look at simply making your VMs run with a single processor where possible. But don&#8217;t just do this willy-nilly. Still make certain that the server was not running in SMP mode and [convert it properly to UP mode where needed][7]. For windows 2003 servers which you are considering converting to run a uniprocessor HAL, ensure that they are at least SP2 otherwise you will need to [install a hotfix][8] as well.

## Caveats

So what are some of the caveats? Well if you are aiming for good VM performance on for newer servers (Windows 2003 and up) that have MP (mulit-processor) HALs you gain performance for the guest by using multiple vCPUs for CPU intensive applications.

In a single vCPU VM on newer MP enabled OS’s running applications which are not CPU intensive, you can gain performance benefits in the guest by manually setting them to run in Uniprocessor mode.

[Performance Best Practices for vSphere 5.0][5] – Page 20

> Although some recent operating systems (including Windows Vista, Windows Server 2008, and Windows 7) use the same HAL or kernel for both UP and SMP installations, many operating systems can be configured to use either a UP HAL/kernel or an SMP HAL/kernel. To obtain the best performance on a single-vCPU virtual machine running an operating system that offers both UP and SMP HALs/kernels, configure the operating system with a UP HAL or kernel.
> 
> The UP operating system versions are for single-core machines. If used on a multi-core machine, a UP operating system version will recognize and use only  one of the cores. The SMP versions, while required in order to fully utilize multi-core machines, can also be used on single-core machines. _**Due to their extra synchronization code, however, SMP operating system versions used on single-core machines are slightly slower than UP operating system versions used on the same machines.**_
> 
> _**NOTE    When changing an existing virtual machine running Windows from multi-core to single-core the HAL usually remains SMP. For best performance, the HAL should be manually  changed back to UP.**_

That is pretty clear as well. If you are looking to reduce the number of vCPUs being utilized in your environment don&#8217;t expect a reboot to be all that is required to have the VM running in uniprocessor mode.

Forcing Windows 2008/2008 R2/7 to redetect and use an appropriate HAL for the number of vCPUs it has been allocated or has been changed is a pretty simple affair:

Execute MSConfig, and then go to tab Boot -> Advanced Options…, check option “Number of Processors”, change the number to # of vCPUs being utilized.

Or using command line:

bcdedit /set detecthal yes

For Windows 2000 you [can accomplish the same goals in device manager][9]:

How to downgrade the HAL:

  * Right-Click My Computer
  * Properties > Hardware Tab > Device Manager
  * Expand +Computer
  * Right-Click ACPI Multiprocessor
  * Choose Update Driver

From here Windows Dialogs vary – but whatever your version – you need to use

  * Install from a list or specific location (advanced)

then

  * Don’t search. I will choose a driver to install

For Windows 2003 you [can use the devcon tool][10] if you have issues doing so via device manager.

## Conclusion

So what is &#8220;best practice&#8221; when deploying a new VM in your environment? The &#8220;less is more&#8221; mantra is generally still true. The caveats are that you have to be intelligent when selecting the number of vCPUs to deploy for a server. So the default template should always be a single vCPU. Even for smaller environments (as you never know how large they might end up getting!).

But if you are going to be installing multiprocessor aware applications like SQL server, and you know it is going to see some use, then go ahead and give it 2 or more vCPUs. After all, you will know your applications and environment needs and requirements far more than any best practices will dictate. But don&#8217;t over-provision just to over-provision. That will reduce the number of VMs you can put on a single host in the long run. In turn, that makes your virtualization infrastructure investment far less cost effective. And this negates one of the strongest selling factors of this wonderful technology, reducing cost.

 [1]: http://www.amazon.com/Critical-VMware-Mistakes-Should-Avoid/dp/1937061981 "Critical VMware Mistakes You Should Avoid"
 [2]: http://lse.sourceforge.net/numa/faq/
 [3]: http://www.techrepublic.com/blog/networking/how-to-optimize-vm-memory-and-processor-performance/3453
 [4]: http://vmfaq.com/entry/42/
 [5]: http://www.vmware.com/pdf/Perf_Best_Practices_vSphere5.0.pdf
 [6]: http://msdn.microsoft.com/en-us/windows/hardware/gg463394.aspx
 [7]: http://support.microsoft.com/kb/234558
 [8]: http://support.microsoft.com/kb/923425
 [9]: http://vmetc.com/2008/06/11/how-to-p2v-multi-processor-servers-to-uni-processor-vms/
 [10]: http://support.microsoft.com/default.aspx?scid=kb;en-us;311272