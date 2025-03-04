---
title: 'CSS: Pretty Code Snippet Formatting'
author: Zachary Loeber
type: post
date: 2011-08-05T12:58:12+00:00
excerpt: This is how I publish code snippets on my blog.
url: /blog/2011/08/05/css-pretty-formatting/
wordbooker_options:
  - 'a:9:{s:18:"wordbook_noncename";s:10:"6d3623ac77";s:18:"wordbook_page_post";s:4:"-100";s:18:"wordbook_orandpage";s:1:"2";s:23:"wordbook_default_author";s:1:"2";s:23:"wordbook_extract_length";s:3:"256";s:19:"wordbook_actionlink";s:3:"300";s:26:"wordbooker_publish_default";s:2:"on";s:18:"wordbook_attribute";s:31:"Posted a new post on their blog";s:29:"wordbooker_status_update_text";s:35:": New blog post :  %title% - %link%";}'
wordbooker_extract:
  - |
    I forgot where I dredged this up from but here is how I do my code/script posts. I modified the default theme css and add the following for pre-formatted text:
    pre {
    white-space: pre-wrap; /* css-3 */
    white-space: -moz-pre-wrap !important; /* Mozill ...
categories:
  - Other
  - Web Publishing
tags:
  - Other
  - System Administration
  - Web Publishing

---
I forgot where I dredged this up from but here is how I do my code/script posts. I modified the default theme css and add the following for pre-formatted text:

<pre>pre {
white-space: pre-wrap; /* css-3 */
white-space: -moz-pre-wrap !important; /* Mozilla, since 1999 */
white-space: -pre-wrap; /* Opera 4-6 */
white-space: -o-pre-wrap; /* Opera 7 */
word-wrap: break-word; /* Internet Explorer 5.5+ */
background: #000000;
color: #21FF2C;
}</pre>