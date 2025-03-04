---
title: 'Exchange: Mailbox GUI'
author: Zachary Loeber
type: post
date: 2013-04-08T01:10:21+00:00
url: /blog/2013/04/07/exchange-mailbox-gui/
categories:
  - Active Directory
  - Active Directory
  - Exchange
  - Exchange 2010
  - Microsoft
  - Powershell
  - Security
  - System Administration

---
# Exchange 2010 Mailbox GUI

A powershell GUI for selecting and performing actions against multiple Exchange mailboxes.

<!--more-->

The scope of mailbox selection can be:

  * An entire organization
  * The mailboxes within a DAG
  * The mailboxes on one server
  * The mailboxes on one mailbox database
  * Individually selected mailboxes from any of the above scopes

## Introduction

This GUI was developed specifically for environments with multiple DAGs or where there may be split Exchange organizational responsibility in the same forest. I wanted to be able to work on mailboxes within a singular DAG or other granular scopes without having to reinvent the wheel for every new script. So I came up with this generic container GUI to work on mailboxes instead. This is actually a subset of another script I’ve been working on which I believe may be valuable to others as a general template for their own work.

Many of my other scripts are meant to be scheduled for recurring execution. Currently this script is meant for a more immediate or one off execution. If there is a need in the future this may change.

## Usage

At the moment, you need to define a custom script (aptly called “Custom-Script.ps1”) to call against your selection of mailboxes. This script must take an array of PSObjects and should be self-contained. So if you want to get information back, make sure Custom-Script.ps1 does so within the function called “Custom-Function”. An example custom-script.ps1 file is included with a function which will return activesync information on all selected mailboxes. This function drops a CSV file called ActivesyncDevices.csv.

## Notes

Be patient in larger environments, it can take a while to load up the mailboxes and other form elements. If the form shows “(Not Responding)” very likely it is still working on getting your results.

This script is still very new, there may be kinks to work out. If you run into any “kinks” that you want worked out, clue me in and I’ll do what I can to get things squared away.

Remoting seems to work but you get the fastest results running directly from a server.

If you want to just get results against a DAG, server, or database don’t even select to load the mailboxes. If you do load the mailboxes and want results from larger scopes just make sure that no mailboxes are selected.

Once connected, all DAGs and databases will be listed. Once you select a DAG, only databases within that DAG will be listed. If you just select a DAG, all mailboxes in that DAG are the target audience.

[Exchange-Mailbox-GUI][1]

[Technet Link][2]

 [1]: /wp-content/uploads/2013/04/Exchange-Mailbox-GUI.zip
 [2]: http://gallery.technet.microsoft.com/Exchange-Mailbox-GUI-5b204590