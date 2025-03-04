---
title: 'Email Reputation and Design: A Condensed Guide'
author: Zachary Loeber
type: post
date: 2018-02-24T15:59:26+00:00
url: /blog/2018/02/24/email-reputation-and-design-a-condensed-guide/
categories:
  - Azure
  - Microsoft
  - Office 365
  - Security
  - System Administration
tags:
  - Security
  - System Administration

---
Very few domains implement the holy grail of email identity reputation frameworks, [DMARC][1]. This guide will cover all the steps required to get it implemented for your domain along with some best practices for overall email reputation design.

<!--more-->

# Introduction

Email domain reputation is a complex topic but for the sake of this article assume that it means that recipients of email from your domain know that it is legitimate. There are multiple technologies and techniques one can implement to improve their email domain reputation and they all generally lead towards DMARC.

DMARC is the first and only widely deployed technology that can make the &#8220;header from&#8221; address (what users see in their email clients) trustworthy. Once implemented, email recipients are far less likely to get email spoofs from your domain. This can help protect your brand and greatly reduce the likelihood of your business&#8217;s email going to a recipient&#8217;s spam folder.

A large portion of email security is focused on the inbound aspect of delivery. So it can be a little bewildering when one is tasked to architect domain reputation for outbound email traffic. This becomes even more complicated for larger organizations with several flows of SMTP traffic for several line of business applications, marketing efforts, and more.

In this article I’m going to cover different email reputation techniques and technologies at rapid speed. I’ll cover just enough to get the core knowledge down so that by the end of this article a busy infrastructure architect or manager can begin to formulate a strategy towards implementing DMARC for their own organization.

# Required Knowledge

I’ll assume that the reader is familiar with DNS and SMTP. Generally, if you have ever done troubleshooting on an email delivery issue by analyzing the headers of an email then you are sufficiently technical enough for this article. The truth of things is that DNS is the foundation of any of the email reputation and validation technologies. Most of the &#8216;basics&#8217; we will talk about are based firmly in sensible logic and DNS.

# Designing Email Domains

I’ve seen such a large variance in email domain design over the years that I know for certain the infrastructure you are managing on the inside is a unique snowflake. But no matter how special your email architecture is on the inside of your network, email leaving it still needs to look reputable to outside recipients. Otherwise email from your organization will be unceremoniously dumped in spam folders or even dropped entirely by receiving MTAs (Mail Transport Agents).

This is why it is vital to understand our first design axiom:

## Email Reputation Axiom 1 &#8211; Every email domain has its own reputation.

This includes sub-domains as well. So email from  <support@contoso.com> has a reputation that is completely different than <support@subsite.contoso.com>

Knowing this, you can begin to design your email infrastructure so that it naturally becomes more reputable simply by having different email types use different domains. Easy right? I personally have four broad categories of email that warrant their own sub-domains:

  1. **Corporate** – Email from your user’s mailboxes come from this domain.
  2. **Transaction Based** – Password reset confirmations, payment reminders, or other critical on-demand (result of some transaction occurring) email. _There should be no marketing material that would warrant anyone to want to &#8216;unsubscribe&#8217; from this type of email__**!**_
  3. **Marketing** – Self explanatory. It should be noted that this may be called ‘SPAM’ by some but if you are doing things by the books you will be putting legitimate unsubscribe links in your marketing email and keeping up with all legal requirements. This way email from this domain actually ends up being labeled as ‘BULK’ instead of SPAM.
  4. **Application Specific** – If you have some newly developed web application that needs to sent out email then it would be wise to dedicate an email domain specific to the application.

If you got this far and you only have email being sent from a single domain (your corporate domain) then now is the time to start creating some subdomains. I prefer the following personally:

  * contoso.com – Corporate domain
  * t.contoso.com – Transactional domain
  * e.contoso.com – Marketing domain
  * <app>.contoso.com – Application domain (this, in turn, can have its own transaction and marketing domains OR you can have it use your existing transaction and marketing domains if able to do so).

> **NOTE:** I purposefully don’t use ‘m.contoso.com’ as that can sometimes be the mobile version of a company&#8217;s external website and it is wise to keep these different sub-domains isolated for just email if possible. I also like to keep it down to single characters so the email doesn&#8217;t appear too far off from your actual corporate domain name. These sub-domains can be whatever you like though.

&nbsp;

## Email Reputation Axiom 2 – Reputation is Based on Sender IP

This is a basic level article so this statement does not do all of email domain reputation determination justice. But if you know anything know that the sending IP is of vital importance when determining the reputation of an email sender. Implementing SPF, DKIM, and DMARC don&#8217;t mean anything if your sending IP is on a bunch of blacklists.

This means your reputation starts with the sending IP (or IPs). Here are a few tasks to ensure your sending IPs are not causing issues.

**Task 1** – Validate that your sending IP for each domain is able to reverse lookup to the domain’s MX record.

This is less important to validate but still has a place in your email validation checklist. Some older MTAs will drop or mark as spam email from IPs that don’t reverse lookup to the MX record being published externally for the domain. To be comprehensive I have to include this task.

**Task 2** – Validate your sending IP is not on any blacklists.

This may seem like a simple task but it can easily be overlooked when you are in an active deployment state. Example, say you are developing a web app in the cloud and are sending email notifications from the system for password reminders. To get this going quickly the developer decided to use sendgrid and API level programming. But they decided to use the free sendgrid offering. This would almost certainly mean the sending IPs are on several blacklists and will cause delivery issues.

**Task 3** &#8211; Monitor that your sending IP does end up on any blacklists moving forward.

If your IPs get on several blacklists your life can suddenly become way more difficult. I’m a huge fan of mxtoolbox.com for this particular task. They have lots of extra tools and features beyond blacklist monitoring as well (and the price is right).

**Task 4** – Block outbound port 25 at your perimeter firewall.

It&#8217;s amazing how many times I see this overlooked. Blocking port 25 outbound for all devices except your mail servers is just best practice (more like sysadmin 101). Simply put, you don’t want a single infected end user workstation on your network to mar your reputation by blasting the internet with spam. You may have to monitor outbound connections to this port on your firewall to get all systems that are sending email from within your network to plan things out accordingly.

# Path to DMARC

Once you have the basics covered you can proceed to implement SPF, DKIM, and finally DMARC. Generally implementation of these technologies will occur in that order. Towards the end of this article I&#8217;ll cover a scenario where you may want to actually start with DMARC first though.

## SPF

Sender Policy Framework is just a fancy term for a TXT DNS record that lists out what IPs are allowed to send email as your domain. This is considered the bare minimum for any organization to look even remotely legitimate. There are tons of online tools to help you create and test these records. If you don&#8217;t have this record created properly nothing else really matters.

It should be noted that whenever someone references an &#8216;SPF Record&#8217; that they really mean a TXT record with special formatting that makes it an SPF record. There ARE some old SPF DNS record types that have long since been depreciated and shouldn&#8217;t be setup or used (even if you have that option with your DNS provider).

> **Be Nice:** If you have a vendor you work with that you respect and their emails are always going to your spam folder why don&#8217;t you quickly look at the headers, find the origin IP, and see if it is in their published SPF record? If it isn&#8217;t, then shoot them a friendly email note on the matter to help out. The time to do this is nominal at best and if it does fix email delivery issues for that vendor they will love you forever.

## DKIM

DomainKeys Identified Mail is a bit more complex to implement but is an absolute requirement for DMARC. This is where things get a bit harder as  you will need to set up DKIM selector records individually for each service that sends email as the domain. That sending service needs to be part of the DKIM setup process as well as they will need the keys, the records they are published to, and will need to enable the service on their outbound email services for your domain email.

If you want to implement DMARC then you need to have DKIM configured for **ALL** services sending as your domain. This is another reason why the actual design of your email domain reputation is so important. The more services you have that send as your domain the more difficult is becomes to configure DKIM. In fact, many major services don&#8217;t support DKIM configuration at all (I&#8217;m looking at you ADP). If you use one of these services and MUST be able to send email as your domain from it then you simply cannot implement DMARC.

> **DKIM Technical Note:** You can have any number of DKIM selector records with any names you like. The sending email service simply needs to know what these names are as they get injected into the email headers for lookup. Knowing this makes configuration of this technology much simpler as it can be done one vendor at a time. You shouldn&#8217;t share the DKIM crypto keys between different vendors. They should all have their own selector records and crypto keys.

Do not forget that your on premise email servers need to be setup for DKIM as well! If you us o365 in a hybrid mode but still send email from an on premise relay, that will need to be setup for DKIM the same as any vendor. A free solution that works well enough for Exchange is [DKIM Signer][2] but there are paid solutions as well if you need more support.

## DMARC

If you have made it this far and have properly implemented everything else (SPF and DKIM) for your email domain then you would be foolish not to implement DMARC. This is because it is a simple DNS record. That is why this is the smallest section of the article.

Domain-based Messaging, Authentication, Reporting and Conformance (DMARC) allows you to set policies around SPF and DKIM telling receiving mail transport agents what to do with mail from your domain that isn&#8217;t DKIM signed or that fails your SPF record checks. It is widely adopted but not widely deployed. It also has two parts, the policy part that increases the reputability of your email and the reporting part that allows you to understand more what is going on with email sent on behalf of your domain.

You can use this to your advantage. Theoretically you could start your journey by setting up DMARC records in a reporting mode first. Depending on how you set this up (and how many domains receive email from your organization) this can generate a ton of information about vendors and systems sending on your organization&#8217;s behalf. This can then be used to more intelligently target where your SPF record is lacking and what vendors you will need to work with to implement DKIM. Be careful though, over the course of a month I managed to acquire over 8 thousand DMARC report emails. To parse this deluge of data there are some [scripts][3] and [online tools][4] at your disposal.

# Conclusion

I&#8217;ve not provided any scripts or personally created tools to go with this article. I&#8217;ve also not been highly technical. But what I have been is concise and hopefully helpful to a broad range of technical architects and engineers that deal with email reputation management and design. This may also be valuable to IT managers looking to get the general battle plan for a path to DMARC implementation for their own domains.

 [1]: https://dmarc.org/
 [2]: https://github.com/Pro/dkim-exchange
 [3]: https://gallery.technet.microsoft.com/scriptcenter/Harvest-DMARC-items-for-9c0d911a
 [4]: https://dmarcian.com/dmarc-xml/