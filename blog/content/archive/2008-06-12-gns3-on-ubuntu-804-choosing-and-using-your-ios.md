---
title: GNS3 on Ubuntu 8.04 – Choosing and Using your IOS
author: Zachary Loeber
type: post
date: 2008-06-12T15:53:53+00:00
url: /blog/2008/06/12/gns3-on-ubuntu-804-choosing-and-using-your-ios/
categories:
  - Cisco
  - Linux
  - Networking
  - Ubuntu

---
As promised here is the post regarding choosing and using an IOS image that will fit your study needs.

If you followed the first post in this series you are technically now ready to start loading up images and making labs of your own. You will need to get your hands on some IOS images (legally of course).But which IOS should you use?
  
<!--more-->


  
This largely depends on your need. The ideal is to get a balance between features that you will need for your labs and physical size of the image. Each instance of a router that you run, does so in memory. So, logically the smaller your images the more you can run at once. Keep in mind that supposedly some images will need to be fully extracted to run properly. So if you have them in a compressed format (you can tell this if the letter &#8220;z&#8221; is in the image name) just use the unzip command to extract them.

That being said, how do you choose an image? Well first you need to look at what dynamips supports first. You can get a good idea of what is supported <a title="Dynamips Site" href="http://www.ipflow.utc.fr/index.php/Cisco_7200_Simulator" target="_blank">here</a>. Here is a nice layout of supported hardware <a title="Hacki Forum" href="http://7200emu.hacki.at/viewtopic.php?t=1831&highlight=supported+hardware" target="_blank">here</a> as well. The basics of it is that you have to choose a chassis for your device. Some devices will only allow one kind of chassis anyway. Others may have multiple options. The chassis is litterally the box that the hardware is in and what you choose determines the router&#8217;s expandibility. You expand a router with Network Modules (NM&#8217;s) that go into slots. Let us use an example.

I&#8217;m interested in a platform that has the ability to be a switch or a router so it must be able to have a switch NM available for it. So I need at least one empty slot available on its chassis (most routers come with a default port configuration on slot0 that cannot be changed). Looking at the list I notice that the 2600 devices look to not have as many NM&#8217;s available which generally means that it is not heavily used as a multiplatform device and probably only has one or two slots available. These lower end devices typically have less memory as they tend to be dedicated to one task so the IOS image requirements are less and will likely be smaller. A 7200 is an enterprise multiple slot, NPE capable (network processing engine) support device which is way more than what I need right now so I will steer clear of this choice for the moment.

So I&#8217;m going for a 2600 of some sort. How do I know what I want? <a title="Cisco Products" href="http://www.cisco.com/en/US/products/hw/routers/index.html" target="_blank">Here</a> is Cisco&#8217;s product line (End of life or not, they are mostly accounted for in this location). Here there are links to available models that have information on what slots they have. There is also a link to relavent NMs that you may want to look at.

To be honest, I know the 2600 and what it is capable of from experience. But if you never seen one how would you know? By doing what I just did. It is a digging process that helps you learn the platforms and terminology so dig right in!

In any case, I chose the 26xx platform. How do I choose an IOS? Well if you actually have a choice of images and are not stuck with what you have then you can use <a title="Cisco Feature Navigator" href="http://tools.cisco.com/ITDIT/CFN/jsp/index.jsp" target="_blank">this</a> resource to see what your images are capable of. I eventually landed on c2691-is-mz.123-22.bin (note: the pictures below are for a different IOS that I ended up not using as the file I had for it was corrupt, besides you will find that the IS feature set is very robust) (second note: Does your image have an MZ in the name? If so then you have to unzip the image first, even if it doesn&#8217;t have the extension of zip the unzip command should work) as it has just the right amount of features and is not to huge in size. Note that an image of c2600 will work on the entire range of 2600 devices, but the feature set determines if it can use the network modules you use with it.

I moved my image to /opt/GNS3/IOS/ and added it to my list of IOS Images in GNS3 (Edit menu -> IOS Images and Hypervisors). It looks like this:

[<img class="alignnone size-thumbnail wp-image-22" title="ios-images" src="/wp-content/uploads/2008/06/ios-images.png?resize=150%2C92" alt="IOS Images Setting" width="150" height="92" data-recalc-dims="1" />][1]

The default of 2691 came up for the model. I&#8217;m fine with that (if not go look at which platform you may want). Go ahead and click on the &#8220;Check for minimum RAM requirement&#8221; and it will nicely bring you to cisco&#8217;s site:

[<img class="alignnone size-thumbnail wp-image-23" title="cisco-ios-selection" src="/wp-content/uploads/2008/06/cisco-ios-selection.png?resize=150%2C48" alt="" width="150" height="48" data-recalc-dims="1" />][2]

Then select the one for your platform to get this:

[<img class="alignnone size-thumbnail wp-image-25" title="cisco-ios-requirements1" src="/wp-content/uploads/2008/06/cisco-ios-requirements1.png?resize=150%2C21" alt="IOS Requirements" width="150" height="21" data-recalc-dims="1" />][3]

Which shows that 128Mb is required for this IOS, exactly what GNS3 put in for its default! Cool!

Click Save in your GNS3 IOS Images window and then close it. Now move a c2691 router to the work area. Then double click on it. If you select the router you will see that the general area does not allow you to select an NPE (network processing engine) or a Midplane (fabric, backplane, whatever you want to call it). These are generally only available on higher end equipment.

The slots tab already has slot0 taken up by GT96100-2FE network module. This is probably because it is built directly into the model. But you can manually select slot1. Remember you can find out what many of these slot types are at the cisco site. I chose a NM-16ESW as I want switch capabilities as well.

Save and close your dialog box and we are almost there. The final aspect of this is figuring out the idle-pc value of the IOS you are using. This value will allow dynamips to skip processing of router cycles that don&#8217;t do anything thus saving your precious CPU from overloading 🙂

When you right click and start the router your cpu will skyrocket. Right click on the started router and select to console into it. It will show some startup things and finally ask if you want to run a configuration wizard of sorts. Type in no and wait for it to stop saying how the lines are down and such. When it is done complaining then right click on the router and select &#8220;Idle PC&#8221; and GNS3 will try to determine a good value to use. Select any that start with a *. If the CPU usage on your computer doesn&#8217;t drop almost immediately then run it again until you get one that does.

 [1]: /wp-content/uploads/2008/06/ios-images.png
 [2]: /wp-content/uploads/2008/06/cisco-ios-selection.png
 [3]: /wp-content/uploads/2008/06/cisco-ios-requirements1.png