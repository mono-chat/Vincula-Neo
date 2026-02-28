;i didnt write the registry alias.. someone from mircscripts.org did.
alias registry {
  Var %k = $1, %d = $readreg(%k)
  return %d
}
alias -l readreg {
  var %n = $+(regread,.,$ticks), %r, %v
  .comopen %n WScript.Shell
  if (!$com(%n)) {
    var %a = 1
    while (%a < 100) { inc %a }
  }
  %v = $com(%n,RegRead,3,bstr,$1)
  if (($comerr) || (!%v)) { .comclose %n | %r = $false }
  else { %r = $com(%n).result }
  .comclose %n
  return %r
}
dialog ticketsfound {
  title %ticknum tickets found! Select one to use.
  size -1 -1 205 94
  option dbu
  button "Update!", 1, 3 80 37 12, ok
  button "Cancel", 2, 42 80 37 12, cancel
  list 3, 2 3 200 74, size
}
on *:dialog:ticketsfound:sclick:1:{
  set %ticket $gettok($read($findfile(%dir,chatroom_ui*.msnw,$did(3).sel),w,*passportticket*),4,34)
  set %profile $gettok($read($findfile(%dir,chatroom_ui*.msnw,$did(3).sel),w,*passportprofile*),4,34)
  echo -a ticket from $did(3).seltext loaded.
}
alias ud {
  if (9 isin $os) || (me isin $os) goto oldwin
  set %dir $gettok($registry(HKEY_CLASSES_ROOT\.bfc\ShellNew\\command),1-2,92) $+ \Temporary Internet Files\Content.IE5
  if ($findfile(%dir,chatroom_ui*,0) > 0) { $findfile(%dir,chatroom_ui*,0,remove " $+ $1- $+ ") }
  :oldwin
  set %dir $registry(HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths\\Directory)
  if ($findfile(%dir,chatroom_ui*,0) > 0) { $findfile(%dir,chatroom_ui*,0,remove " $+ $1- $+ ") }
  window -p @test
  var %hwnd = $dll(nHTMLn.dll,findchild,$window(@test).hwnd)
  echo -a $dll(nHTMLn.dll,attach,%hwnd)
  echo -a $dll(nHTMLn.dll,navigate,http://chat.msn.com/chatroom.msnw?rm=20s)
}
on 1:CLOSE:@test:{
  var %x = 0
  :redo
  if ($findfile(%dir,chatroom_ui*,0) > 1) {
    set %ticknum $findfile(%dir,chatroom_ui*.msnw,0)
    dialog -m ticketsfound ticketsfound
    var %x = $findfile(%dir,chatroom_ui*.msnw,0)
    var %y = 1
    while (%x >= %y) {
      if ($dehex($gettok($read($findfile(%dir,chatroom_ui*.msnw,%y),w,*DecodeHexName $+ $chr(40) $+ "*),2,34)) != $null) { did -a ticketsfound 3 $dehex($gettok($read($findfile(%dir,chatroom_ui*.msnw,%y),w,*DecodeHexName $+ $chr(40) $+ "*),2,34)) }
      else did -a ticketsfound 3 $chr(37) $+ $chr(35) $+ $gettok($read($findfile(%dir,chatroom_ui*.msnw,%y),w,*unescape $+ $chr(40) $+ "*),2,34)
      inc %y
    }
    halt
  }
  if ($findfile(%dir,chatroom_ui*.msnw,1)) {
    %ticket = $gettok($read($findfile(%dir,chatroom_ui*.msnw,1),w,*passportticket*),4,34)
    %profile = $gettok($read($findfile(%dir,chatroom_ui*.msnw,1),w,*passportprofile*),4,34)
    echo -s ticket from $gettok($read($findfile(%dir,chatroom_ui*.msnw,1),w,*unescape $+ $chr(40) $+ "*),2,34) loaded.
  }
  else {
    if (%x == 0) { set %dir $gettok($registry(HKEY_CLASSES_ROOT\.bfc\ShellNew\\command),1-2,92) $+ \Temporary Internet Files\Content.IE5 | inc %x | goto redo }
    else manupdate
  }
}
;IRCVERS IRC5 MSN-OCX!2.03.0202.1201
;IRCVERS IRC6 MSN-OCX!2.03.0109.2801
;IRCVERS IRC7 MSN-OCX!7.00.0206.0401
on *:load:{
  set %createcat CP
  set %createtopic idraft.2
  set %createserver EN-US
  set %away.color 14
  set %back.color 1
  set %tagged
  set %timereply on
  set %timeformat $eval($adate $+ $chr(44) $asctime(h:nn.ss tt),0)
  .timer 1 8 ud
  echo -s blah blah thanks to like one or 2 people and pretty much fuck the rest of you.
  echo -s if it doesnt work then you can add me to messenger indent_@hotmail.com and i'll try to help
  echo -s but be patient because i get busy sometimes.
  echo -s basically just type /ud to update your passport info.. if your too lazy for that or if you think
  echo -s i've backdoored this and am going to steal your password (lol) then just use /manupdate and
  echo -s paste in the passportticket and passportprofile parameters in the source of the chatframe.
  echo -s or just /nick >im_a_wanker and dont worry about passports at all.. you can set your own idents too.
  echo -s 4PREPARING TO UPDATE PASSPORT DATA...
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START LOCALHOST CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:start:{
  write -c web.html <OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49" width="100%" CODEBASE="http://fdl.msn.com/public/chat/msnchat42.cab#Version=7,00,0206,0401">
  write web.html <PARAM NAME="RoomName" VALUE="somewhere">
  write web.html <PARAM NAME="NickName" VALUE="id">
  write web.html <PARAM NAME='BaseURL' VALUE='http://chat.msn.com/'>
  write web.html <PARAM NAME="Server" VALUE="127.0.0.1:6668">
  write web.html </OBJECT>
  set %ircvers IRCVERS IRC7 MSN-OCX!7.00.0206.0401 $eval($chr(10),0)
  hmake channels 1000
  :redo
  var %serverport = $rand(1210,4000)
  if (!$portfree(%serverport)) goto redo
  window -k0 @debug
  socklisten init %serverport
  .timer 0 60 checkem
  .timer -m 1 200 server 127.0.0.1 %serverport
  .timer 1 1 localinfo -h
  .timer 1 1 ifinds
}
on *:socklisten:init: {
  sockaccept iserv
  sockclose init
  sockwrite -n iserv :ident 001 $me :Welcome $me
  sockwrite -n iserv :ident 002 $me :Your host is TK2CHATCHATA07, running version 2.106.4
  sockwrite -n iserv :ident 003 $me :This server was created Mar 13 2002 at 12:52:02 PDT
  sockwrite -n iserv :ident 004 $me TK2CHATCHATA07 2.106.4 aioxz abcdefhiklmnoprstuvxyz
  sockwrite -n iserv :ident 375 $me :- motd
  sockwrite -n iserv :ident 372 $me :-
  sockwrite -n iserv :ident 372 $me :- ** weclome to RyLans MSN chat authentication script **
  sockwrite -n iserv :ident 372 $me :-
  sockwrite -n iserv :ident 376 $me :End of /MOTD command
  sockwrite -n iserv :ident 800 $me 1 0 GateKeeper,NTLM 512 *
  ircx
}
on *:sockread:iserv: {
  var %read
  sockread %read
  tokenize 32 %read
  if ($1 == JOIN) {
    if ($sock(id $+ $hget(channels,$2))) { sockwrite -n id $+ $hget(channels,$2) JOIN $2- | return }
    find $2
    return
  }
  elseif ($me ison $2) {
    if (!$sock(id $+ $hget(channels,$2))) { find $2 | timer 1 10 sockwrite -n id $+ $hget(channels,$2) $1- }
    else sockwrite -n id $+ $hget(channels,$2) $1- 
    return
  }
  elseif ($sock(id*,1) == $null) {
    if ($1 == NICK) { sockwrite -n $sockname : $+ $me NICK $2 }
    if ($1 == USER) { sockwrite -n $sockname :ident 001 $me :msn chat network authentication script by RyLan }
    return 
  }
  elseif ($me == $2) && ($sock(id*,0) > 0) { sockwrite -n id* $1- }
  elseif ($comchan($2,1)) { sockwrite -n id $+ $hget(channels,$comchan($2,1)) $1- | return }
  elseif ($left($2,2) == $chr(37) $+ $chr(35)) { sockwrite -n id $+ $hget(channels,$2) $1- }
  else { sockwrite -n id* $1- }
}
menu @debug {
  clear:clear
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START DIRECTORY CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ifinds {
  if ($sock(conifinds) == $null) {
    window -hpk0 @webloader1
    .echo @debug $dll(nHTMLn,attach,$window(@webloader1).hwnd)
    .echo @debug $dll(nHTMLn,select,$window(@webloader1).hwnd)
    .echo @debug $dll(nHTMLn,navigate,$mircdirweb.html)
    sockopen conifinds 207.68.167.1 $+ $rand(75,86) 6667
  }
  else echo -s * $chr(47) $+ ifinds: you already have a socket ( $+ $sock(conifinds).status $+ ) on a directory server.
}
on *:sockopen:conifinds:{ socklisten initifinds 6668 | .timerkeepfinds 0 8 keepfinds }
on *:socklisten:initifinds:{ sockaccept ifinds | sockclose $sockname }
on *:sockread:ifinds: {
  var %read
  sockread %read
  tokenize 32 %read
  echo @debug ifinds %read
  if ($1 == FINDS) { halt }
  else { 
    if ($sock(conifinds).status == active) { sockwrite -n conifinds $1- }
    else { sockclose $sockname | echo -s couldnt send $1- to directory server. please try reconnecting. }
  }
}
on *:sockclose:ifinds:echo -s ifinds closed
on *:sockread:conifinds: {
  var %read
  sockread %read
  tokenize 32 %read
  if ($2 == 705) && (%705check != on) { halt }
  echo @debug conifinds $1-
  if ($2 == 706) || ($2 == 701) || ($2 == 703) || ($2 == 901) { sockclose $sockname | sockclose web* | echo @debug $dll(nHTMLn,navigate,about:blank) | halt }
  if ($2 == 702) {
    .set %key. [ $+ [ %find ] ] newkey $+ < $+ $rand(10000,99999) $+ >
    if (%createmode == $null) set %createmode -
    sockwrite -n $sockname CREATE %createcat %find %createtopic %createmode %createserver 1 %key. [ $+ [ %find ] ] 0
  }
  if ($2 == 376) { sockclose ifinds | window -c @webloader1 }
  if ($2 == 642) {
    echo -a $time found user $4-
    set %founduser $4
    if ($dialog(finduser) == $null) { dialog -m finduser finduser }
    did -a finduser 1 $6 $5
  }
  if ($2 == 901) { halt }
  if ($2 == 613) {
    echo -s 4Found Channel in $round($calc(($ticks - %cticks) / 1000),2) second
    sockclose ichan
    window -hpk0 @webloader
    echo @debug $dll(nHTMLn,attach,$window(@webloader).hwnd)
    echo @debug $dll(nHTMLn,select,$window(@webloader).hwnd)
    echo @debug $dll(nHTMLn,navigate,$mircdirweb.html)
    socklisten initichan 6668
    sockmark initichan %find
    sockopen id $+ $hget(channels,%find) $remove($4,:) $5
    sockmark id $+ $hget(channels,%find) %find
  }
  if ($2 == 908) { sockclose $sockname }
  elseif ($1 == AUTH) && ($2 != 705) {
    if ($sock(ifinds)) sockwrite -n ifinds $1-
    if (!$sock(ifinds)) .timerwriteauth 1 2 sockwrite -n ifinds $1-
  }
}
on *:sockclose:conifinds:{ timercloseifinds 1 1 sockclose ifinds | timerreopenifinds -m 1 1200 ifinds }
alias find {
  if ($sock(conifinds).status != active) { echo -s you must connect to the directory server before trying to look up a channel. | halt }
  if ($sock(ichan) != $null) { echo -s */find: ichan still open | halt }
  set %cticks $ticks
  var %id = $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z)
  hadd channels $1 %id
  if ($sock(id $+ %id)) {
    sockwrite -n id $+ $hget(channels,$1) join $1
    halt
  }
  sockwrite -n conifinds FINDS $1
  set %find $1
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START CHANNEL CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:socklisten:initichan:{
  sockaccept ichan
  sockmark ichan $sock($sockname).mark
  sockclose $sockname
}
on *:sockopen:id*:{
  if ($left($me,1) != >) { sockwrite -n $sockname $eval(%ircvers,2) AUTH GateKeeperPassport I :GKSSP\0#7\0\0\0\0\0\0 }
  else { sockwrite -n $sockname %ircvers $lf AUTH GateKeeper I :GKSSP\0#7\0\0\0\0\0\0 }
}
on *:sockread:id*:{
  var %buff
  sockread %buff
  tokenize 32 %buff
  if ($window(@debug) == $null) window -k0 @debug
  if ($2 == 914) return
  echo @debug  $+ $sockname $+  $1-
  if ($1-4 == AUTH GateKeeper S :OK) {
    sockwrite -n $sockname AUTH GateKeeperPassport S : $+ $passform(%ticket,%profile) $lf USER * "*" "127.0.0.1" : $+ 14i15d $+ $lf nick $me $+ $lf $+ mode $me +i $+ $lf $+ prop $me MSNPROFILE :9 $lf join %find $lf
    sockclose ichan
    echo @debug $dll(nHTMLn,navigate,about:blank)
    halt
  }
  elseif ($1 == auth) && ($3 == S) {
    if (!$sock(ichan)) { .timerargh -m 1 200 sockwrite -n ichan $1- }
    else sockwrite -n ichan $1-
  }
  elseif ($1-3 == AUTH GateKeeper *) {
    sockwrite -n $sockname USER * "*" "127.0.0.1" : $+ 14i15d $+ $lf nick $me $+ $lf join %find $lf
    sockclose ichan
    echo @debug $dll(nHTMLn,navigate,about:blank)
    halt
  }
  elseif ($2 == 001) {
    if ($sock($sockname).mark == %clone) {
      if ($gettok(%rejoin,1,32)) { set %clone $gettok(%rejoin,1,32) }
      else { set %clone $null }
      join $$gettok(%rejoin,1,32)
      set %rejoin $deltok(%rejoin,1,32)
      halt
    }
    else window -c @webloader
  }
  if ($2 == 432) || ($2 == 910) || ($2 == 465) { sockclose ichan | sockclose $sockname | echo @debug $dll(nHTMLn,navigate,about:blank) | halt }
  elseif ($4-5 == -q $me) && ($gettok($remove($1,$chr(58)),1,33) != $me) && ($me isowner $3) {
    sockwrite -n $sockname $+(mode $me +h %key. [ $+ [ $3 ] ],$lf,mode $3 -q $gettok($remove($1,$chr(58)),1,33),$lf,prop $3 ownerkey $chr($rand(33,255)) $+ $r(a,z),$cr)
    access $3 clear owner
    access $3 add owner $gettok($address($me,1),1,64) @*.*. $+ $gettok($ip,3,46) $+ .* 0 : $me
    unset %checkme
    disable #aop
    unset %aopon
    timer 1 10 enable #aop
    timer 1 10 set %aopon $true
    sockwrite iserv $1- $lf
  }
  elseif ($2 == KICK) && ($4 == $me) && (%kickflood != $true) {
    if ($me isowner $3) { 
      disable #proponq | timer 1 3 enable #proponq
      sockwrite -n $sockname join $3 %key. [ $+ [ $3 ] ] $lf kick $3 $remove($gettok($1,1,33),:) $lf prop $3 ownerkey uhoh $+ $r(A,Z) $+ $chr(127) $lf access $3 clear owner $lf access $3 clear host $lf access $3 add owner $gettok($address($me,1),1,64) @*.*. $+ $gettok($ip,3,46) $+ .* 0 : $me $cr
    }
    else { sockwrite -n $sockname join $3 %hkey. [ $+ [ $3 ] ] $lf kick $3 $remove($gettok($1,1,33),:) $lf access $3 clear host $lf access $3 add host *! $+ %ident $+ @* 0 $chr(32) $+ : %tag }
    echo $3 4 $+ $gettok($remove($1,$chr(58)),1,33) kicked you out of $3 $5-
    echo @kicks $asctime(1h:nn2.ss3 tt) $remove($gettok($1,1,33),:) kicked you out of $3 ..... reason $5-
    set %kickflood $true
    timer 1 1 set %kickflood pass
    disable #aop
    unset %aopon
    timer 1 2 enable #aop
    timer 1 2 set %aopon $true
  }
  elseif ($4 == OWNERKEY) {
    if ($remove($gettok($1,1,33),$chr(58)) != $me) {
      if ($gettok($5,1,58) == $null) {
        sockwrite -nt $sockname mode $3 -q $remove($gettok($1,1,33),$chr(58)) $lf access $3 clear owner $lf prop $3 ownerkey $chr(127) $+ $rand(0000,9999) $+ $chr(127) $cr
        echo $3 $remove($gettok($1,1,33),$chr(58)) NULL KEY!!
        halt
      }
      if ($gettok($5,1,58) == "") {
        sockwrite -nt $sockname mode $me +h "" $lf mode $3 -q $remove($gettok($1,1,33),$chr(58)) $lf prop $3 ownerkey $chr(127) $+ $rand(0000,9999) $+ $chr(127) $lf access $3 clear owner $cr
        echo $3 $remove($gettok($1,1,33),$chr(58)) TRICK KEY!!
        halt
      }
      else { set %key. [ $+ [ $3 ] ] $gettok($5,1,58) | echo $3 3 $+ $asctime(1h:nn2.ss3 tt) $remove($gettok($1,1,33),$chr(58)) $+ 7( $+ $4 $+ ) $+ $3 $gettok($5,1,$asc(:)) | write ownerkeys.txt $3 $asctime(h:nn.ss) $remove($gettok($1,1,33),$chr(58)) $gettok($5,1,$asc(:)) }
    }
    if ($remove($gettok($1,1,33),$chr(58)) == $me) { set %key. [ $+ [ $3 ] ] $gettok($5,1,58) | echo $3 3 $+ $asctime(1h:nn2.ss3 tt) $remove($gettok($1,1,33),$chr(58)) $+ 7( $+ $4 $+ ) $+ $3 $gettok($5,1,$asc(:)) }
  }
  elseif ($4 == HOSTKEY) {
    if ($gettok($5,1,$asc(:)) == $null) || ($gettok($5,1,$asc(:)) == "") {
      prop $3 hostkey $chr(127) $+ $rand(a,z) $+ « $+ $rand(0000,9999) $+ » $+ $rand(a,z) $+ $chr(127)
      echo $3 3 $+ $asctime(1h:nn2.ss3 tt) $remove($gettok($1,1,33),$chr(58)) $+ 7( $+ $4 $+ ) $+ $3 NULL KEY!!!
      halt
    }
    else set %hkey. [ $+ [ $3 ] ] $gettok($5,1,$asc(:)) | echo $3 3 $+ $asctime(1h:nn2.ss3 tt) $remove($gettok($1,1,33),$chr(58)) $+ 7( $+ $4 $+ ) $+ $3 $gettok($5,1,$asc(:))
  }
  elseif ($2 == JOIN) {
    if ($chr(44) isin $3) { sockwrite -n iserv $1 $2 $4- }
    if ($chr(44) !isin $3) { sockwrite -n iserv $1- }
    if ($gettok($remove($1,:),1,33) == $me) { set %jointime 3***Actual Join Time: $round($calc(($ticks - %cticks) / 1000),2) secs }
    if ($gettok($3,4,44)) {
      sockwrite -n iserv :itsmagic MODE $remove($4,:) + $+ $replace($gettok($3,4,44),.,q,@,o,+,v) $remove($gettok($1,1,33),:)
    }
  }
  elseif ($2 == MODE) {
    unset %undomodes
    if ($4 == +k) set %roomkey $5
    if ($remove($gettok($1,1,33),$chr(58)) != $me) && ($4 == +k) mode $3 -k %roomkey 
    if ($remove($gettok($1,1,33),$chr(58)) != $me) && ($4 == +l) && ($5 < 20) && (%limitflood != $true) { mode $3 +l 100 | kick $3 $remove($gettok($1,1,33),:) stop that | set %limitflood $true | timer 1 1 unset %limitflood }
    if (q isin $4) || (o isin $4) || (v isin $4) goto end
    if ($remove($gettok($1,1,33),$chr(58)) != $me) && (+ isin $4) && (%modeflood != $true) {
      if (i isin $4) set %undomodes %undomodes $+ i | if (m isin $4) set %undomodes %undomodes $+ m | if (h isin $4) set %undomodes %undomodes $+ h | if (s isin $4) set %undomodes %undomodes $+ s | if (p isin $4) set %undomodes %undomodes $+ p 
      if (%undomodes != $null) mode $3 - $+ %undomodes
      set %modeflood $true
      timer -m 1 500 unset %modeflood
    }
    :end
    sockwrite -nt iserv $1- 
    halt
  }
  elseif ($2 == 353) {
    if ($chr(44) isin $6) {
      var %a = 6
      var %b
      while (%a <= $0) {
        if (%b == $null) %b = $remove($gettok($gettok($1-,%a,32),4,44),:)
        else %b = %b $gettok($gettok($1-,%a,32),4,44)
        inc %a
      }
      sockwrite -n iserv :ident 353 $me = $5 : $+ %b
    }
    else sockwrite -n iserv $1-
  }
  elseif ($2 == quit) { sockwrite -nt iserv $1 PART $sock($sockname).mark 8[quit $+ $replace($3-,$chr(32),$chr(160)) $+ ] | return }
  elseif ($2 == kill) { echo $sock($sockname).mark 4 $+ $1- | echo @kicks 4 $+ $1- }
  elseif ($1 == PING) sockwrite -n $sockname PONG $2
  elseif ($2 == :Closing Link:) echo -a 4you were killed in $sock($sockname).mark
  elseif ($2-3 == INVITE $me) { window -fk0 @invites -1 -1 400 100 | echo @invites $time(h:nn.ssT) $remove($1,:) invited you to $5 }
  elseif ($2 == PRIVMSG) {
    if (VERSION isin $4) { echo -s 7 $remove($gettok($1,1,33),:) 4VERSION | return }
    elseif (TIME isin $4) {
      echo -s $remove($gettok($1,1,33),:) 4TIME
      if (%ctcpflood != $true) && (%timereply == on) { ctcpreply $remove($gettok($1,1,33),:) TIME $eval(%timeformat,3) | set %ctcpflood $true | timer -m 1 600 unset %ctcpflood | return }
    }
    elseif (PING isin $4) { if (PONG! isin $4) { privmsg $remove($gettok($1,1,33),:) REPLY $eval($remove($5,$chr(1)),2) | return } else echo -s $remove($gettok($1,1,33),:) 4PING | return }
    elseif (ID isin $4) ctcpreply $remove($gettok($1,1,33),:) idraft.2
    elseif (FINGER isin $4) { echo -s $remove($gettok($1,1,33),:) 4FINGER | return }
    elseif ($4 != : $+ $chr(1) $+ S) sockwrite -n iserv $1-
    else sockwrite -n iserv $1-3 : $+ $remove($6-,$chr(1))
    halt
  }
  elseif ($2 == 934) { echo -a 4REGROUP CLOSURE: $sock($sockname.mark | find $sock($sockname).mark | sockclose $sockname }
  elseif ($2 == 403) { sockclose $sockname | join $4 }
  elseif ($2 == 935) {
    sockclose $sockname
    sockwrite -nt iserv : $+ $me $+ ! $+ $address PART $4
    set %closedchan $4
    timer -m 1 200 jcc $remove($4,$chr(37))
  }
  elseif ($2 == 473) { halt }
  elseif ($2 == 451) { sockclose $sockname }
  elseif ($2 == 306) { echo $sock($sockname).mark you have been marked as away }
  elseif ($2 == 305) { echo $sock($sockname).mark you have been marked as back }
  elseif ($2 == 822) { echo $sock($sockname).mark $remove($gettok($1,1,33),:) Away: $right($3-,$calc($len($3-) - 1)) | cline -l 3 $sock($sockname).mark $remove($gettok($1,1,33),:) }
  elseif ($2 == 821) { echo $sock($sockname).mark $remove($gettok($1,1,33),:) Returned | cline -l 15 $sock($sockname).mark $remove($gettok($1,1,33),:) }
  elseif ($2 == 451) sockclose $sockname
  else sockwrite -n iserv $1-
}
on *:sockread:ichan:{
  var %buff
  sockread %buff
  echo @debug  $+ $sockname $+  %buff
  if (AUTH Gatekeeper S isin %buff) {
    if ($left($me,1) != >) { sockwrite -n id $+ $hget(channels,%find) %buff }
    else {
      var %buff1 = $remove(%buff,$left(%buff,44))
      var %x = $len(%buff1)
      var %y = 0
      var %z = 16
      while (%y <= 16) {
        if ($mid(%buff1,%x,1) == \) { dec %x | inc %z }
        dec %x
        inc %y
      }
      var %guestform = $guestform(%guestid)
      var %a = 1
      while (%a <= 32) {
        if ($mid(%guestform,%a,2) == 00) { var %guest_asc = %guest_asc $+ \0 | inc %a 2 }
        if ($mid(%guestform,%a,2) == 09) { var %guest_asc = %guest_asc $+ \t | inc %a 2 }
        if ($mid(%guestform,%a,2) == 0A) { var %guest_asc = %guest_asc $+ \n | inc %a 2 }
        if ($mid(%guestform,%a,2) == 0D) { var %guest_asc = %guest_asc $+ \r | inc %a 2 }
        if ($mid(%guestform,%a,2) == 20) { var %guest_asc = %guest_asc $+ \b | inc %a 2 }
        if ($mid(%guestform,%a,2) == 2C) { var %guest_asc = %guest_asc $+ \c | inc %a 2 }
        if ($mid(%guestform,%a,2) == 5C) { var %guest_asc = %guest_asc $+ \\ | inc %a 2 }
        else { var %guest_asc = %guest_asc $+ $dehex($mid(%guestform,%a,2)) | inc %a 2 }
      }
      sockwrite -n id $+ $hget(channels,%find) $remove(%buff,$right(%buff,%z)) $+ %guest_asc
    }
  }
  else halt
}
on *:sockclose:ichan*:echo @debug $sockname just closed
on 1:sockclose:id*:{
  if (%closeflood != $true) {
    sockwrite -nt iserv : $+ $ial($me) PART $sock($sockname).mark
    find $sock($sockname).mark
  }
  set %closeflood $true
  .timer -m 1 1300 unset %closeflood
  echo -s 4 $+ $sockname closed
  if ($dialog(socketclosed) == $null) { dialog -mo socketclosed socketclosed }
  did -a socketclosed 2 $asctime
  did -a socketclosed 2 $sockname : $sock($sockname).mark
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OTHER STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias dehex {
  var %str_in = $remove($1,$chr(37))
  if ( $right($base($len(%str_in),10,2),1) = 1 ) { echo -a oops }
  else {
    while (%str_in) {
      if ($base($left(%str_in,2),16,10) == 32) {
        var %str_out = %str_out $+ $chr(32) $+ $chr(32)
        var %str_in = $mid(%str_in,3)
      }
      else {
        var %str_out = %str_out $+ $chr($base($left(%str_in,2),16,10))
        var %str_in = $mid(%str_in,3)
      }
    }
    return %str_out
  }
}
alias hex {
  var %i 1
  var %count $len($$1-)
  var %retme
  while (%i <= %count) {
    %retme = %retme $+ $base($asc($mid($1-,%i,1)),10,16,2)
    inc %i
  }
  return %retme
}
alias manupdate dialog -md ticket ticket
dialog ticket {
  title "Rylans Ticket Wizard.. DO NOT PASTE REG COOKIE!"
  size -1 -1 314 37
  option dbu
  button "Ok", 1, 2 24 37 12, ok
  button "Cancel", 2, 41 24 37 12, cancel
  edit "", 5, 2 3 310 20, multi autohs return
}
on *:dialog:ticket:sclick:1:{
  if ($numtok($did(5,1),34) > 1) {
    set %ticket $gettok($did(5,1),4,34)
    set %profile $gettok($did(5,2),4,34)
  }
  else {
    set %ticket $did(5,1)
    set %profile $did(5,2)
  }
}
dialog htable {
  title "RyLans Hash Manager"
  size -1 -1 283 123
  option dbu
  button "Close", 1, 2 108 98 12, ok cancel
  list 2, 1 2 100 105, size vsbar
  list 3, 102 2 180 37, size vsbar
  list 4, 102 40 180 85 size vsbar
}
on *:dialog:htable:init:0:{
  var %x = 1
  while (%x <= $hget(0,0).item) {
    did -a htable 2 $hget(%x)
    inc %x
  }
}
on *:dialog:htable:sclick:2:{
  did -r htable 3
  did -r htable 4
  var %x = 1
  while (%x <= $hget($did(htable,2,$did(2).sel),0).item) {
    did -a htable 3 $hget($did(htable,2,$did(2).sel),%x).item
    inc %x
  }
}
on *:dialog:htable:sclick:3:{
  did -ra htable 4 $hget($did(htable,2,$did(2).sel),$did(htable,3,$did(3).sel))
}
alias hashman { dialog -m htable htable }
dialog finduser {
  title %founduser
  size -1 -1 160 125
  option dbu
  list 1, 1 3 158 97, sort size
  button "Exit", 2, 1 104 50 18, ok cancel
  button "Join", 3, 55 104 50 18
  button "Webchat", 4, 109 104 50 18
}
on *:dialog:finduser:dclick:1:{ join $gettok($did(finduser,1,$did(1).sel),1,32) }
on *:dialog:finduser:sclick:3:{ join $gettok($did(finduser,1,$did(1).sel),1,32) }
on *:dialog:finduser:sclick:4:{
  set %openroom $remove($gettok($did(finduser,1,$did(1).sel),1,32),$chr(35),$chr(37))
  run iexplore.exe http://chat.msn.ca/chatroom.msnw?rm1= $+ $replace(%openroom,$chr(92) $+ $chr(98),+) $+ &rm= $+ $replace(%openroom,$chr(92) $+ $chr(98),$chr(37) $+ 2520,$chr(0160),$chr(37) $+ 2550))
}
;;credit to jesse for the passform alias thx;;
alias passform {
  var %ticketdata
  var %profiledata
  %ticketdata = $base($len($$1),10,16)
  %ticketdata = $str(0,$calc(8 - $len(%ticketdata))) $+ %ticketdata $+ $1
  %profiledata = $base($len($$2),10,16)
  %profiledata = $str(0,$calc(8 - $len(%profiledata))) $+ %profiledata $+ $2
  return %ticketdata $+ %profiledata
}
alias guestform1 {
  return $mid($1,4,1) $+ $mid($1,3,1) $+ $mid($1,2,1) $+ $left($1,1) $+ $mid($1,6,1) $+ $mid($1,5,1) $+ $mid($1,8,1) $+ $mid($1,7,1) $+ $right($1,8)
}
alias guestform {
  return $mid($1,7,2) $+ $mid($1,5,2) $+ $mid($1,3,2) $+ $left($1,2) $+ $mid($1,11,2) $+ $mid($1,9,2) $+ $mid($1,15,2) $+ $mid($1,13,2) $+ $right($1,16)
}
alias socks {
  echo -a 3Open Socket List:
  var %x = 1
  while (%x <= $sock(*,0)) {
    if ($left($sock(*,%x),2) == id) {
      if ($sock(*,%x).ls >= $sock(*,%x).lr) { var %y = $sock(*,%x).lr }
      else var %y = $sock(*,%x).ls
      echo -a 3 $+ $sock(*,%x) 1 $+ $sock(*,%x).mark 3 $+ $sock(*,%x).ip $+ : $+ $sock(*,%x).port 14 $+ $chr(91) $+ $sock(*,%x).type idle 1 $+ %y $+ 14s $sock(*,%x).bindip $+ : $+ $sock(*,%x).bindport $+ $chr(93)
      inc %x
    }
    else inc %x
  }
}
alias findu sockwrite -n conifinds findu $1-
alias create sockwrite -n conifinds CREATE CP $chr(37) $+ $remove($1,$chr(37)) R - EN-US 1 ~x 0
alias keepfinds {
  if ($sock(conifinds).status == connecting) { halt }
  if ($sock(conifinds) != conifinds) { ifinds }
  if ($sock(conifinds).status == active) { sockwrite -n conifinds CREATE CP $chr(37) $+ #somewhere ident - EN-US 1 ^ 0 }
}
alias reconnect { sockclose id $+ $hget(channels,$chan) | hop }
alias IRC0 { unset %ircvers | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC | sockclose id $+ $hget(channels,$chan) | hop }
alias IRC1 { set %ircvers IRCX $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRCX | sockclose id $+ $hget(channels,$chan) | hop }
alias IRC5 { set %ircvers IRCVERS IRC5 MSN-OCX!2.03.0202.1201 $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC5 | sockclose id $+ $hget(channels,$chan) | hop }
alias IRC6 { set %ircvers IRCVERS IRC6 MSN-OCX!2.03.0109.2801 $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC6 | sockclose id $+ $hget(channels,$chan) | hop }
alias IRC7 { set %ircvers IRCVERS IRC7 MSN-OCX!7.00.0206.0401 $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC7 | sockclose id $+ $hget(channels,$chan) | hop }
alias clone {
  timerlag off
  unset %rejoin
  sockclose id*
  nick $1
  var %myadr = $ial($me)
  sockwrite -n iserv : $+ $ial($me) PART $chan
  set %clone #
  set %clticks $ticks
  find #
  var %x = 1
  while (%x <= $chan(0)) {
    set %rejoin %rejoin $chan(%x)
    sockwrite -n iserv : $+ %myadr PART $chan(%x)
    inc %x
  }
  var %y = 1
  while (%y <= $numtok(%rejoin,32)) {
    if ($gettok(%rejoin,%y,32) == #) {
      set %rejoin $deltok(%rejoin,%y,32)
      break
    }
    inc %y
  }
  set %clonenum $calc($numtok(%rejoin,32) + 1)
  set %cloning on
}
dialog socketclosed {
  title "UNEXPECTED SOCKET CLOSE!"
  size -1 -1 175 45
  option dbu
  button "Ok", 1, 1 1 14 42, ok
  list 2, 15 1 160 45, vsbar
}
alias jcc if (%closedsocketflood != $true) join % $+ $1-
on *:join:#:if ($nick == $me) && (%clone == $null) && (%cloning == on) { echo # joined %clonenum channels in $round($calc(($ticks - %clticks) / 1000),2) secs | unset %cloning }
on *:kick:#:{
  if ($knick == $me) {
    if ($nick != $me) { oper $me %oper | kill $nick dont kick me! lol }
    join #
  }
}
on *:ban:#:{
  if ($me isin $2-) {
    var %a = $ifmatch
    var %b = $mid($remove($1,+,-),$findtok($2-,$wildtok($2-,* $+ $ifmatch $+ *,1,32),1,32),1) $findtok($2-,$ifmatch,1,32)
    if (%b == b) && ($nick != $me) { mode $chan -bo+b $wildtok($2-,* $+ %a $+ *,1,32) $nick * $+ $right($ial($nick),$calc($len($ial($nick)) - $len($nick))) | msg chanserv unban $chan | join $chan }
  }
}
on *:usermode:{
  echo -a $nick $1-
  if ($left($1,1) == -) && (a isin $gettok($1,1,43)) && ($nick == $me) { oper $me %oper }
}
alias lagck {
  set %pticks $ticks
  ping $$server
}
alias checkem {
  var %x = 1
  var %y = $chan(0)
  while (%x <= %y) {
    if (!$sock(id $+ $hget(channels,$chan(%x)))) { find $chan(%x) | break }
    inc %x
  }
}
on *:pong:{ echo -a $server $round($calc(($ticks - %pticks) / 1000),2) | return }
