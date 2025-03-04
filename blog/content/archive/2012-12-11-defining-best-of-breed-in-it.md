---
title: Defining Best of Breed in IT
author: Zachary Loeber
type: post
date: 2012-12-11T06:00:42+00:00
excerpt: ' This article is a non-technical personal view of what defines the “Best of breed” technical solutions.'
url: /blog/2012/12/11/defining-best-of-breed-in-it/
categories:
  - Networking
  - Other
  - System Administration
tags:
  - network administration
  - Other
  - System Administration

---
# Introduction

Soon I’ll be starting a new position with a company which produces some of the highest quality products in their industry. The company’s products are of such high quality that they typically set the bar in their industry. This made me think of what a truly comprises an excellent solution within the Information Technology.  This article is a non-technical personal view of what defines the “Best of breed” technical solutions.

<!--more-->

# History

Several years ago I was in an interview situation which I recall as if it were yesterday. The normal interview questions were asked. Tell me more about yourself? What value can you add to my organization? What do you believe are your negative traits? Pretty much all the basic questions meant to learn more about a potential candidate.

Everything went pretty well until I was asked something which I simply could not answer. The question went something like this; “Please define the term ‘best of breed’ to me.” And that was it. The interviewer gave no verbal clues. He gave no facial or physical reads. His face was blank and composed in front of me expecting an answer. The silence which followed was only made more uncomfortable by the florescence lights’ minor and infrequent cackles.

When I felt composed enough to answer, I proceeded to fumble my description of ‘best of breed’  in, what only can be described as a rambling babble-talk which Rainman would be embarrassed to witness.

In retrospect, then I really thought I knew what the IT industry needed, and that need was someone like me. After all, I knew I could solve any issue with Linux, Windows, Juniper, Cisco or any other medium in-between regardless of environment and cost. If you wanted an entirely open source environment with Linux boxes as routers for your remote locations, and a windows box as your firewall, so be it as I could make that manageability and security nightmare-in-a-box a reality.

Best of breed made no sense to me because I was all about solving problems so I thought little of solving them the best of breed way.  And, frankly, I was wrong. Years later, far wiser, and definitely more eloquent, I’m now able to answer that question of what ‘best of breed’ means within Information Technology. So I’m going to finally answer that botched interview question publicly as best I can in hopes of a mental redemption for being so wrong in answering that question in the past.

# Definition

[Wikipedia describes the term “best of breed”][1] as;

“…the title given to the dog who has been judged the best representative specimen of its breed at a conformation show.”

So for each species of dog in a competition, one is chosen as superior to all others of the same species. How does this relate to the IT world? We all know that information technology has more vendors and genres than any one person can claim to be an expert on. That is why we have specialists in all kinds of areas within the technology realm. There are network specialists, quality assurance specialists, business application specialists, and the list goes on.

So to simplify things I’m going to say that within IT there are superior methods and architectural solutions for each kind of business need. So “business need” is the dog, and the “IT solution” is the dog specimen. (Sorry business, you are being made synonymous with dogs…). Just as there are many species of dogs, there are many IT solutions to business needs. And just as there are many other animals other than dogs, there are many business needs. Simply put, best of breed in IT means that there is always a best IT solution for business need.

The really great IT managers recognize this and always try to keep the best of breed solutions on the table and will strive to carry out them out (when feasible) in their environments. This leads us to more questions though, such as, “What makes one IT solution superior to others?” In IT that largely depends on non-technical aspect of the solution.

# Qualities

Going back to dogs; how do you decide that a canine is the best of its kind? There are several qualities which figure that a particular dog is better than others in its class. I’m not an expert, but these qualities may be the physical structure of the dog, its coat, how well it is trained, and more. So what qualities define a superior IT method and architecture? I’ve distilled a few qualities which always seem to percolate to the forefront when making decisions on what to implement in an IT environment. These are talking points I like to bring up for any infrastructure or solution design proposal.

## Cost

This is factors into your Return on Investment (ROI). If this not one of your first considerations then you are in the wrong business. Usually the more you put into a solution the easier it is to support and keep up (but this is not always the case!). The best solutions give ongoing forward thinking value that doesn’t lead the business down the path of vendor lock-in or even worse, employee dependency. No single employee or vendor should hold power over the business based on their solution where possible.

Questions to Ask:

  * If you were to carry out a solution and put a dollar value on the costs of time, end-user training, materials, and vendor costs (licensing/support) what number do you come up with?
  * How long until you get those costs back in the value that solution offers over time?

## Supportability/Maintainability

Sure I could get you setup with an entire email infrastructure based on Linux but if you have no qualified staff to upgrade, support, and troubleshoot Linux environments then maybe you chose the wrong solution. The best of breed solution strongly relies upon the current business staff and resources.  No one person should be able to hold hostage any business processes or investments. There are many smaller shops for which a cloud based solution is the best of breed option primarily for these reasons.

Questions to ask:

  * How long will your solution be supported by the vendor?
  * If there are no vendors involved in your solution then how long do you plan on having internal resources at the level of the employee who developed the solution?
  * If the employee who designed or planned a solution won the lotto (or gets hit by an asteroid) can you still support it?
  * Can you delegate maintenance to other staff members or do you need to have specialist or vendor support?

## Security/Ownership

An insecure solution is no solution at all in IT. Typically the more secure a solution is, the more it costs and the more it takes to support. Security needs to be factored in both internally and externally. The best solutions balance both. Security and ownership tend to go hand in hand. If your business culture is highly security conscious then they likely also are uncomfortable with having their data housed on outside infrastructure (aka. the &#8220;cloud&#8221;). Not all environments are open to their data being “elsewhere” so this is a far more critical factor than many take into account.

Questions to ask:

  * How secure is the solution both from an internal staff perspective and from an external access perspective?
  * Is the solution susceptible to internal data leaks?
  * Is the solution off on some unknown “cloud” which is not your own? If so, does this align with the business culture?

## High Availability

This is new to my list as High Availability (HA) has become an expectation within the IT industry (in some sub-industries more than others). High availability is largely measured by end user perspective. Keep in mind that your internal staff is also categorized as a “client” within Information Technology. So this also includes internal processes which, if delayed or failed, may cause critical business impacting issues for your internal users.

Questions to ask:

  * Is your solution business critical?
  * If you need to reboot equipment for upgrades or have service interruption of any kind, what is the impact on end users and the business?
  * If a disaster were to occur where your solution is in place, how fast can you respond to get the solution back online?

## Features

This is usually the least important if you keep in mind that you are providing a solution to a business need but it should not be ignored either. Extra features are usually associated with new environments and are not always solution based. Extra features may be the icing on the cake but sometimes they are so enticing to end users or management that it is hard to ignore this factor. Also, end user buy-in can often be strongly affected by just a few new features if it makes their lives easier.

Another aspect of feature set of a solution would be integration into the current and future infrastructure. Typically solutions with greater amounts of open standards are more easily integrated with other technologies and have a longer shelf life than black box technologies.

Questions to ask:

  * Am I getting all required features in the solution?
  * What extra features might I be getting in the solution?
  * Are there any extra features which will make adoption of the solution within the company easier?
  * Does the solution involve open standards which allow greater integration with other technologies?

# Conclusion

When I put together infrastructure proposals to solve business issues I always try to start with the best of breed solution regardless of cost or likelihood that it will be approved. A best of breed solution will factor the following qualities;

  * Cost
  * Supportability/Maintainability
  * Security/Ownership
  * High Availability
  * Features

So if you grade each of these properties on a scale of 1 to 5 (or whatever your “scale” preferences are) in determining multiple options for an IT solution to meet a business need, which one is the best of breed solution?

I’ll then offer 2 or 3 other possibilities which are less ideal but still meets the business need being addressed. The last possibility will typically be the one that is technically able to be done but probably shouldn’t be even considered.

&nbsp;

 [1]: http://en.wikipedia.org/wiki/Best_of_Breed