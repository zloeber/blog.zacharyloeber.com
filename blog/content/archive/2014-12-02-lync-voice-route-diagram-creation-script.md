---
title: 'Lync: Voice Route Diagram Creation Script'
author: Zachary Loeber
type: post
date: 2014-12-02T18:11:31+00:00
url: /blog/2014/12/02/lync-voice-route-diagram-creation-script/
categories:
  - Lync
  - Microsoft
  - Powershell
  - System Administration
tags:
  - diagram
  - Lync
  - Lync 2010
  - Lync 2013
  - Lync Server 2013
  - Lync Voice
  - Microsoft Lync Server 2013
  - Powershell
  - Powershell Script

---
Lync voice routing boils down to three basic components working in concert to decide call flow. It seems quite simple on paper, you assign voice policies which determine call routes based on PSTN usages (often called the &#8216;glue&#8217;). After looking at Lync voice routing way too many times I finally caved into producing a script to create diagrams of the things over the Thanksgiving holiday weekend.

<!--more-->

There are several reasons why it is inherently difficult to visualize call routing in Lync. Firstly, you can have multiple PSTN usages assigned to both voice policies and routes. You can also have multiple gateways on the routes (if you like unpredictable round robin call behavior). Finally, order of the PSTN usages is important. My first iteration of this script spat out individual PSTN usage nodes in the graphs. But I found that connectors between policies/routes and the usages were really hard to follow ordering based on link labels alone. Because of this I had to settle on a multiple table format where the PSTN usages are shown in order on both the policy and route tables then linked together.

The code isn’t really all that pretty but it gets the job done. I found that for some of the multiple site deployments that output became almost undecipherable. So to compensate I’ve included the ability to filter out your results based on voice policy. Of course you can still use * to get all the results included if you like.

Here is sample output for a centralized SIP trunk based greenfield deployment with a primary and a DR PSTN SIP gateway. I&#8217;m only showing the policy to route diagram portion as the trunks are included in order in the route table. There are parts which can probably be touched up a little but this is a rather clean implementation of Lync voice.

[<img style="margin: 0px; display: inline; background-image: none;" title="image" src="/wp-content/uploads/2014/12/image_thumb.png?resize=244%2C142" alt="image" width="244" height="142" border="0" data-recalc-dims="1" />][1]

This output is actually quite elegant insomuch that almost every PSTN usage has an associated route. There is almost a one to one relationship between the PSTN Usage and the route. This is on purpose to better control call flow paths. I’d go as far as to say that most deployments of this kind should look similar if planned out and designed correctly.

Here is another example of a partial voice deployment with multiple PBX integrations and least cost routing.

[<img style="display: inline; background-image: none;" title="image" src="/wp-content/uploads/2014/12/image_thumb1.png?resize=244%2C99" alt="image" width="244" height="99" border="0" data-recalc-dims="1" />][2]

The graphs start to look pretty wild when you start performing least cost routing and other fun stuff that are the trademark of decentralized voice routing. I highly recommend filtering by voice policy in these cases to better see specific call flows. I&#8217;ve also used a third party function I found to split the route regex pattern down to 20 character lines in the table. This can be modified to suit your needs of course.

This script only creates a base text file for you to feed into graphviz for diagram generation. The default dot generation format should be sufficient to produce fairly decent looking results. You can either [install graphviz][3] and run the included graphviz GUI to generate the graphs from this script output or [use this portable version of graphviz][4] to do the same. If you save the script to one of your Lync servers and run it without any parameters the default output will be for all voice policies and should spit out a file &#8216;Lync-Diagrams.txt&#8217; in the directory which it is run.

> **Side Note:** I opted to use a graphviz definition file yet again purely from lack of other good options for the automatic generation of diagrams. I&#8217;m open to alternative formats if anyone can provide one that is easy to script out.

The script can be downloaded at the [Microsoft Technet Gallery][5] and at [my Github repository][6]. As always, I welcome feedback.

 [1]: wp-content/uploads/2014/12/image.png
 [2]: wp-content/uploads/2014/12/image1.png
 [3]: http://www.graphviz.org/Download.php
 [4]: https://code.google.com/p/graph-viz-portable/
 [5]: https://gallery.technet.microsoft.com/Lync-Voice-Route-Diagram-30259f0a
 [6]: https://github.com/zloeber/Powershell/blob/master/Lync/New-LyncVoiceRouteDiagram.ps1