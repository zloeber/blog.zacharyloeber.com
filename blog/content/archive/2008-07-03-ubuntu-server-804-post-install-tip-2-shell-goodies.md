---
title: 'Ubuntu Server 8.04 Post Install Tip #2: Shell Goodies'
author: Zachary Loeber
type: post
date: 2008-07-03T17:17:38+00:00
url: /blog/2008/07/03/ubuntu-server-804-post-install-tip-2-shell-goodies/
categories:
  - Uncategorized

---
OK, I promised a friend some time ago that I&#8217;d post all of my post-install procedures and I&#8217;ve not quite followed through with that so I&#8217;m doing a few before finishing up my three part post on the &#8220;Home Hacker&#8217;s Network&#8221;. These are all just little hacks I&#8217;ve come across and modified to suit my needs. I like this one a bunch as it gives me a nice shell prompt when I login as well as when I use screen (although the gnu screen configuration part is mutually exclusive to the shell modification part).

So lets get started&#8230;
  
<!--more-->


  
I got this nice prompt script from http://www.iml.ece.mcgill.ca/~stephan/bash_pompt

`nano ~/myprompt.env`

Add the following and save

    #!/bin/bash
    function myprompt
    {
    local NONE='\[\033[0m\]'
    local WHITE_1='\[\033[0;1m\]'
    local BLACK='\[\033[0;30m\]'
    local GRAY='\[\033[1;30m\]'
    local RED='\[\033[0;31m\]'
    local LIGHT_RED='\[\033[1;31m\]'
    local GREEN='\[\033[0;32m\]'
    local LIGHT_GREEN='\[\033[1;32m\]'
    local BROWN='\[\033[0;33m\]'
    local YELLOW='\[\033[1;33m\]'
    local BLUE='\[\033[0;34m\]'
    local LIGHT_BLUE='\[\033[1;34m\]'
    local PURPLE='\[\033[0;35m\]'
    local LIGHT_PURPLE='\[\033[1;35m\]'
    local CYAN='\[\033[0;36m\]'
    local LIGHT_CYAN='\[\033[0;1;36m\]'
    local LIGHT_GRAY='\[\033[0;37m\]'
    local WHITE='\[\033[1;37m\]'
    
    local BRACE_COLOR=$NONE
    local LBRACE=$BRACE_COLOR[$BRACE_COLOR
    local RBRACE=$BRACE_COLOR]$BRACE_COLOR
    local SYMBOL
    local PWD="\W"
    
    if [ `whoami` = root ]; then
    #echo 'ROOT USER'
    SYMBOL="#"
    else
    #echo 'NON-ROOT USER'
    SYMBOL="\$"
    fi
    
    if [[ $1 = "-h" || $1 = "--help" || $1 = "-?" ]]; then
    echo "USAGE:"
    echo " stephan_prompt [-s | -l]"
    echo " "
    echo "DESCRIPTION:"
    echo " Format the PS1 prompt string to have colors."
    echo " "
    echo " -s, --short"
    echo " Default option shows the path as a truncated."
    echo " "
    echo " -l, --long"
    echo " Show the full path in the prompt. Same as the pwd command"
    echo " "
    echo " -?, -h, --help"
    echo " Display usage options"
    echo " "
    else
    
    if [[ $1 = "--short" || $1 = "-s" ]]; then
    #echo "setting path display to short"
    PWD="\W"
    fi
    
    if [[ $1 = "--long" || $1 = "-l" ]]; then
    #echo "setting path display to long"
    PWD="\w"
    fi
    fi
    
    #PS1="$LBRACE\
    #$LIGHT_BLUE\$(date +%H:%M)\
    #$RBRACE\
    #$LBRACE\
    PS1="$LBRACE\
    $GREEN\u\
    $WHITE@\
    $LIGHT_PURPLE\h\
    $WHITE:\
    $LIGHT_RED$PWD\
    $RBRACE\
    $LIGHT_PURPLE$SYMBOL$NONE "
    }

A quick note here, the prompt is defined by the last statement starting at PS1=, you can change this as you see fit, the &#8220;\&#8221; is an escape character and will be needed at the end of every line. the author conveniently defined all the colors at the top of the script. Typical bash escape characters apply so \h = hostname of machine and \u = username. Uncomment the first 4 lines of PS1 and remove the second PS1 line to add the time at the beginning of the prompt.

Fix up your bash profile by sourcing the above file at each login and by adding a few more sysadmin type paths.
  
`nano ~/.bash_profile`
  
add the following and save:
  
`export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/share<br />
source ~/myprompt.env<br />
myprompt`

> Note: Ok, the previous instructions work just fine on a headless system which, consequently, is what I base my write-ups on. But to be true to the rules of bash you should actually put the previous code at the end of ~/.bashrc

Now make screen act a bit nicer when you open new screens (if, that is, you use screen like every good geek should do)

`sudo apt-get install screen<br />
sudo nano /etc/screenrc`

Add this at the very end:
  
`# make the shell in every window a login shell<br />
shell -$SHELL`

**explanation:**Screen does not source .bash_profile by default as a new screen is not a new login screen but just a derivative of the current running screen. This fixes that so we have nice paths and prompts with new windows in screen. If you are a hard core screen user you can do other things like set it up to start up multiple screens and run a program in each one when you start up screen. Maybe more on that later?