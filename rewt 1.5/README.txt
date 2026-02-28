######  #####    #    ####      #      #  #####
#    #  #       # #   #   #     ##    ##  #
#    #  #####  #   #  #   #     # #  # #  #####
#####   #      #####  #   #     #  ##  #  #
#    #  #      #   #  #   #     #      #  # 
#    #  #####  #   #  ####      #      #  #####


;;;;;;;NOTICE;;;;;;;

After this connection being ripped on its first day of release...
By the guy named Spyder. I had to put this notice up that
I DO NOT WANT ANYBODY ALTERING THIS CODE UNDER ANY CIRCUMSTANCES AND CALLING IT THEIR OWN
If you do you will be banlisted and there will be consequences.

Sorry for the harshness, but I needed to draw the line, I hope you have fun with this con.


Updated to Rewt 1.5

Extra Features:

-Faster Authentication
-Channel Creation Support
-MSN!Theme Extra Menu's ( by bri ^_^ )
-Blocked MSN Notices
-Nickname and Cloning ability
-Resocking ability
-Invalid roomname Error handling
-Efficiant and easy Passport System
-Debug option
-Annoying grayed out things that you'll never get(Search and remove in rewt if it pisses you off :p)

Thank you for downloading Rewt 1.5 made by Sky.

<-- TO SKIP TO THE COMMANDS JUST SCROLL TO THE BOTTOM -->
<-- TO SKIP TO THE COMMANDS JUST SCROLL TO THE BOTTOM -->

Disclaimer:

If you are going to use this you are not to criticize how I have made this. If you have a problem
with this script then why are you even reading this? delete it and go away.
This script I made last year sometime if I remember correctly. Any bug's, errors or screwups or code
that hasnt been coded properly you have to understand I coded this last year and that I most definately
know the fix to it, and most strongly recommend you do not tell me how to improve this script otherwise
I will feel patrinized and get seriously pissed off :S...

A little about me:

Hey incase you didnt know me my name is Sky and I script/program and I love internet communication.
That about sums up a large part of me...

What connections I have made in terms of script:

1) Seasons
2) Codex
3) Athalon
4) Rewt 1.0
5) Rewt 2.0
6) Terminal
7) Rewt 1.5

Somewhere in the middle I have done the odd bits and bobs like made a shell connection for people
to manipulate into their own connection. Also I made a newer version of the shell connection for
Absorbx for him to use. Ungreatfully he gave up on trying to shape it into his own :p.

How to use:

Hello everyone :) I thank you for taking interest in downloading my script.
This little text file will teach you the things you need to know about using rewt.
Sorry if I have bad grammer or if there are any spelling mistakes in this.
The updation process is quite straight forward. All you have to do is enter in your details and wait...
There is no notepad popup for the updater since I update the subscriber info using sockets.[Feature]
This script has optimized flood protection settings. If you click the main menu and goto Flood,
you will see a button saying "Default Settings" and that will then give you the default flood protection
settings of Rewt.

All raws etc are forwarded so unlike <Un-named> you can do somethings that couldnt be done before...

Commands:

[Rewt.mrcx]

Subroutines:

/WHO <Nick> - For Full Who requires 6channels on each TK (couldnt be bothered to improve)
/Scklist - Shows the socket list
/Openmsnsocket <IP> <RoomName> - Joins a room name on that IP and channelname
/R - Restart
/Update - Update
/switchdeown - Toggle deowner prot
/switchkick - Toggle kick prot
/switchnull - Toggle null prot
/plop - refresh all channels
//resck # - Resocks the channel socket (if the password attempts pass 5 and msn locks you out)

Functions:

$TKIdent(IP)
$Lookupsip
$rewtkey

Sockwrite:

sockwrite -tn $hget(channels,#) <Data>

[MSN!Theme.mrcx]

Subroutines:

/example1 - example of a loop
/wtf - Splits up your words by spacebar and messages each word
/msg - what do you think?
/me - what do you think?
/qsn - Owner selected nicknames
/osn - Host selected nicknames
/vsn - voice selected nicknames
/avsn - spec selected nicknames
/mh - make host (force)
/mhh - make host twice (force)
/ph - make participant (force)
/phh - make participant twice (force)
/F8 - Extra Options