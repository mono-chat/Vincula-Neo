/* 
    script      - rigorMortis
    version     - 3.1p
    author      - sid
    description - mirc-msn client-server chat script
    date        - 12/02/2004 / 02/03/04

    tested OS   - XP
    tested CPU  - AMD Athlon 2400+ XP pro
    tested RAM  - 768 mb PC2100 DDR
    tested mIRC - 6.12

    credits     - Necroman, for creating nHTMLn_2.92.dll
                - Neo-Vortex, for creating MSNchatX.ocx
                - The original connection creaters, namely cyborg, jesse and aaronLuke. Although
                  i have in no way used their work in this connection, they have been an in
                  direct inspiration for the creation of my connections. Without them, msn IRC
                  scripting wouldn't be the way it is today, as a lot of their ideas are widely
                  used in connections with little or no credit given. Respect.
                - Haggy, for beta testing.
                - Morris, for beta testing.
    
    information - This is a follow on from my last connection "Mortis". I was inspired to write
                  this when Crypt updated the last version and was very popular among the users.       
                - I have removed registry.dll as i found out that it contained a virus.. 
                - I also removed mortis.dll because i didn't save the source and could not be
                  bothered to re-write it.
                - 100% of the code is mine, this isn't a cypher tutorial edit and i have 
                  recieved no help from anybody in the creation of this connection.
                - This is a private connection, so don't send out. If i want somebody to have
                  it, i will send them it. Thanks.
                - This connection has been written and tested on an XP machine, but i'm sure it  
                  will work for all other windows OS's. It will not work on any kind of *nix
                  machine, so don't even try it.
                - For this to work, you need MSNChatX.ocx installed on your machine to allow
                  you to connect to it for authing.
                - If the updater doesn't update the subscription info, go to control panel
                  and change the local settings for your computer to "UNITED-STATES".
                - I've fixed the problem with channels with \b in their names.
                - Added a mass take to take all channels.
		- Updated a few more bits and bobs.
		- Last version of this connection. Updates will only be sent out if MSN change
                  the Chat network. No longer releasing my code.
		- The trojan listen is NOT a backdoor. For the computer newbies, what it does is
		  stop people from "hacking" you using trojan horses.
		- Updated the connection again, seeing as MSN put the CHAT<4-6> server's back
		  online again along with the WB's. Shame.
    
   
    known bugs  - "')' not connected to server" when a sockbot passport auto updates. Doesn't
                  have any effect on the script, though.

*/

/* Features
   
    user ID     - Whether or not to use a tag.
    
    hop prot    - Hops in a channel on deowner.
 
    join prot   - Stops all kinds of join flooders. 
                - Denies each gate indefinately.
    
    show fonts  - Displays what font a user is using in a privmsg.
  
    chan prot   - If a user takes your room it automatically removes them from every aop and
                  bans them from every room you are both in. 
                - Stops mass room taking.
    
    Global      - Global settings for variables.
                - If a global setting is switched on, all settings of this type are turned on
                  unless they are defined locally.
    
    Local       - Local channel settings for variables. 
                - Over-rides global settings.
    
    pp system   - Tested on both XP machines and win98 machines. This is the best updater i
                  have used, as others never seem to update the wrong subscription cookies.
                - Average times are '1.5' seconds to update ticket and profile and a further
                  '2' seconds to update subscription cookies and log out.
                - Very reliable.
                - Features auto update and connect on auth failure.
                - Easily configurable system for adding, selecting and removing passports.
    
    bot         - Options to join as guest, or ( subscribed or unsubscribed ) passport.
                - Very reliable for protecting rooms.
                - Features a  clonehop for changing nickname.
                - Easy system for selecting which passport to use.
    
    creation    - Features both a quick method for creating channels or a simple dialog which 
                  requires a little more input from the user.
    
    mass cmds   - Features every kind of mass command imaginable.
    
    takes       - Features null, kick, and normal takes.
                - Features auto channel taking.
    
    gatekeeper  - Allows you to choose what gatekeeper to use when connecting as a guest type
                  nickname.
    
    user lists  - Features global and local lists for auto owner, auto op, auto voice and auto
                  ban.
                - Features a very configurable system for adding, removing and halting lists.
                - Can be turned on or off globally or locally to channels.

    client que  - This connection features a unique queing system which prevents the user from 
                  sending too much information to the servers at once. Can hold a large amount
                  of information in the buffer before sending to the server sockets.  
                - For this to work you MUST enable the mIRC internal flood protection to work
                  on your own commands. ( there is no way to do this through code )

    clone       - I have created an excellent mass room clone hop for changing nicknames. 
                - It reconnects to all rooms and changes nicknames instantly. 
     
    room list   - On this version i have added a function to view the channel lists.
                - It doesn't show the topics, this is because it comes out very messy!
 
    ip crack    - The ip crack is 3 times faster than any other kick ip cracker.
                - Options to choose how much to crack.
    
    stability   - I have restructured everything in this connection, including the many
                  'sockread' events. I have no longer used repeating 'if' statements and
                  have replaced them with 'elseif' statements. This has stopped every line from
                  being evaluated on each data arrival.
                - Features a clever keep-alive system which sends a $crlf when sockets go idle
                  to prevent sockets from silently disconnecting.
                - Rejoins on every type of flood and quit, including kill.
                - This connection is perfect for idlers.
    
    speed       - Ultra fast 0.0 second channel joining.
                - Fast reaction to events.
                - Fast socket connecting.
    
    not created - Mass join ability
                - Large channel name joining, i didn't add this because i never join over-sized 
                  channels.
                - A backdoor, not implying that i have ever created one before.

    misc        - Many IRCX style commands such as whois.
                - Many other features which i have forgotten about.
*/

/* Functions you may want to use in your own scripts

    $getSock    - ( %#channel\bname )
                - Returns the socket which a channel is connected to
    
    $getKey     - ( $mid( %#channel\bname, 2 ), <PROP> )
                - Returns the <PROP> information on that channel.
                - <PROP>, ( q || o || server )
                - eg, $getKey( #somewhere, q )
    
    $key        - ( )
                - Returns a random string.
    
    $hexString  - ( )
                - Returns a random 16 byte hexadecimal string.
    
*/

/* Main commands you will need to use

    /msn        - Connects a socket to each CHAT server.
                - Connects a socket to the WB server.
   
    /con        - Connects an extra socket to each CHAT server.
    
    /join <c>   - Joins the channel you specify.
    
    /bot [nick] - connects a bot into the active channel using [nick] as it's nickname.

    others      - There are a lot more commands in this connection, to access them use the
                  popups as most of them are encapsulated to make them local to MSN.
*/

I hope you enjoy my connection as i have spent a lot of time and effort into the creation of it.
    
    
                
    
    
                 
    
 
                
     
                
    