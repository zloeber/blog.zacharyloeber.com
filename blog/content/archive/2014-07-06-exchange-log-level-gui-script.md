---
title: Exchange Log Level GUI Script
author: Zachary Loeber
type: post
date: 2014-07-07T03:30:20+00:00
excerpt: Here is a simple, but useful, Exchange log level GUI script which was written for Exchange 2013 but with compatibility for Exchange 2010 as well.
url: /blog/2014/07/06/exchange-log-level-gui-script/
categories:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Microsoft
  - Powershell
  - System Administration
tags:
  - Exchange
  - Exchange 2010
  - Exchange 2013
  - Powershell
  - PSC
  - Scripting

---
I ran into a situation recently where I was forced to amp up the Exchange logging levels to further troubleshoot an issue with some pretty specific Exchange components. I found myself wanting a quick GUI to view and set the levels but found none. So I used this as an opportunity to learn a bit about xaml based GUIs and powershell. The result is this simple, but useful, Exchange log level GUI script which was written for Exchange 2013 but should also run on 2010.

<!--more-->

Here is an example of the script running on an Exchange 2013 server:

[<img style="margin: 5px; display: inline; background-image: none;" title="ExchangeLogLevelGUI" src="/wp-content/uploads/2014/07/ExchangeLogLevelGUI_thumb.jpg?resize=524%2C577" alt="ExchangeLogLevelGUI" width="524" height="577" border="0" data-recalc-dims="1" />][1]

If you are trying to run this on Exchange 2010 you may need to run it from an administrative powershell.exe console started in STA mode. If you are already in your administrative exchange management shell then just run &#8216;powershell.exe -noprofile -STA&#8217; then run this script with the -Exchange2010Mode parameter.

In the script I use an array of psobjects as the datasource for a basic listview with some predefined column bindings. One of the psobject properties is an array of strings containing the valid exchange logging level values for the combobox selectors. I use another psobject property to bind to the combobox initial value property. Interestingly enough, because some of the default log level values are set to non-standard values on 2013 (typically the number 2) this will mean you will see some unset comboboxes. I didn&#8217;t need to troubleshoot these particular areas of exchange so I never changed the logging level for these particular components. I&#8217;m not certain why they are set this way by default but I&#8217;d probably not change them in production without the thumbs up from MS support though.

You can download [the script at the technet gallery][2].

Cheers!

 [1]: wp-content/uploads/2014/07/ExchangeLogLevelGUI.jpg
 [2]: http://gallery.technet.microsoft.com/Exchange-Log-Level-GUI-f9e8cb21