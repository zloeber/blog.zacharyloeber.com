---
title: 'Big-IP: Custom IIS SOAP Monitor'
author: Zachary Loeber
type: post
date: 2011-01-22T17:32:01+00:00
url: /blog/2011/01/22/big-ip-custom-iis-soap-monitor/
categories:
  - BIG-IP
  - IIS
  - Linux
  - Microsoft
  - Networking
  - System Administration

---
In working on a production issue with my company&#8217;s flagship SaaS product I worked with some of the brilliant F5 engineers to isolate one web server in the load balanced pool which was intermittently failing. The F5 engineer recommended a health monitor that does more than just poll for a static page. He suggested we implement some kind of soap call to make the application pool do some work and return a result (I guess in case the IIS application pool is misbehaving but not down). So I worked with one of our developers to do just that but ran into some caveats which required yet another custom health monitor.

<!--more-->Their default soap health monitor did not work as advertised on our load balancers. We discovered through some tcpdumps that the default Big-IP monitor sends a &#8220;SoapAction&#8221; header in the request but with no value and by default the SOAP call in IIS does not support this I guess. Rather than push for an effort to fix the web configs to handle empty requests I just hacked together a quick custom health monitor to send the header request in a way that the IIS configuration could handle. There are two parts to this monitor, the monitor itself and an xml file with the actual request to send.  I cannot help you with the actual SOAP method creation on your IIS server though, connect with your devs for that. I didn&#8217;t use the cool F5 script template like I did with the last monitor but this is still fully functional (assuming you modify the xml request to your environment/custom soap page). First the actual monitor:

<pre>#!/bin/bash
# Zachary Loeber 01/21/2011
#
# these arguments supplied automatically for all external monitors:
# $1 = IP (nnn.nnn.nnn.nnn notation or hostname)
# $2 = port (decimal, host byte order)
# $3 = name to be looked up
# $4 = string in expected response
#
# The following variables should be set for this to work properly
# SOAPACTION: the action which is injected into the host header of the request
#               (ie. http://tempuri.org/Status)
# XMLREQUESTFILE: the location of your uploaded XML request (ie. /usr/bin/monitors/myweb.xml)
# URI: Your soap request uri (ie. webservices/f5.asmx)
# SOAPRESPONSE: what you expect in a valid response (ie. OK)

IP=`echo $1 | sed 's/::ffff://'`
pidfile="/var/run/`basename $0`.$IP.$PORT.pid"

if [ -f $pidfile ]
then
 kill -9 `cat $pidfile` &gt; /dev/null 2&gt;&1
fi
echo "$$" &gt; $pidfile

/usr/bin/curl -H 'Content-Type: text/xml; charset=utf-8' -H "SOAPAction: $SOAPACTION" -d @"$XMLREQUESTFILE" -X POST "http://${IP}:${2}/$URI"  | grep -i "$SOAPRESPONSE" 2&gt;&1 &gt; /dev/null

if [ $? -eq 0 ]
then
 echo "UP"
fi

rm -f $pidfile
exit</pre>

Here is a quick example of an xml file you could use, this is based on a quick and dirty custom asmx file that my company&#8217;s devs whipped up that simply returns OK if sent a soap request method called &#8220;Status&#8221;:

<pre>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"&gt;
  &lt;soap:Body&gt;
    &lt;Status xmlns="http://tempuri.org/" /&gt;
  &lt;/soap:Body&gt;
&lt;/soap:Envelope&gt;</pre>

save both files to /usr/bin/monitors/ and chmod +x the customsoap.sh. Then define your custom health monitor to call customsoap.sh. An example is below:

<div id="attachment_249" style="width: 374px" class="wp-caption alignleft">
  <a href="/wp-content/uploads/2011/01/big-ip_custom_soap_monitor.jpg"><img class="size-full wp-image-249" title="big-ip_custom_soap_monitor" src="/wp-content/uploads/2011/01/big-ip_custom_soap_monitor.jpg?resize=364%2C552" alt="Custom Soap Monitor Example Configuration" width="364" height="552" data-recalc-dims="1" /></a>
  
  <p class="wp-caption-text">
    Custom Soap Monitor Example Configuration
  </p>
</div>