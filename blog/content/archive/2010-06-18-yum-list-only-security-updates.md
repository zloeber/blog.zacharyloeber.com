---
title: Yum – List Only Security Updates
author: Zachary Loeber
type: post
date: 2010-06-18T16:17:39+00:00
url: /blog/2010/06/18/yum-list-only-security-updates/
categories:
  - Linux
  - RedHat/CentOS
  - System Administration

---
I&#8217;ve been really MS inundated at work lately with exchange 2010, UAG 2010, and Communicator deployments/migrations. So to balance my life a bit I better do a quick post of a linux hack 🙂 Here is a quick one I tacked together about 6 months ago. This will generate a detailed report of all the security updates you are missing with a description of what the update will fix. You will need the yum-security package installed for this to work.
  
`yum list-security | awk 'NR!=1 {print $1}' | sed '/list-security/d' | xargs yum info-security > security_report.txt`