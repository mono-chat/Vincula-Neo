;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START LOCALHOST CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on 1:load:{
  write -c idreadme.txt id3.3 msn chat authentication script by Rylan
  write idreadme.txt $crlf
  write idreadme.txt - $crlf $+ -thanks to jesse for all the help i have recieved from him in the past. $crlf $+ -thanks to ian for coming up with the window handler idea for the updater! $crlf $+ -&thx to simon for the format to login through a url. $crlf $+ -thanks to mark, andrew, ryan, jamie, chris, brad $crlf $+ -and anyone else who helped me test and debug this. $crlf $+ -fuck you to a few people who i wont mention. $crlf $+ - $crlf $crlf
  write idreadme.txt here is a small list of common problems and their possible solutions. $crlf $+ if you have other problems go to $chr(37) $+ #unknown and ask. $crlf $crlf $+ *** important note: do NOT /sockwrite to id* /command $chr(37) $+ #channelname with this script! it will close all your sockets! $crlf $+ *** /sockwrite to the CORRECT socket using id $eval($+ $hget(channels,$chan),0) if writing anything with a channel as $chr(36) $+ 2 ok?! $crlf $crlf
  write idreadme.txt problem example: $crlf $+ $chr(9) $+ cant see anything in @update $crlf $+ solution: $crlf $+ $chr(9) $+ update your nhtmln.dll with the one included in the .zip file. $crlf $crlf
  write idreadme.txt problem example: $crlf $+ $chr(9) $+ 1 0 GateKeeper,NTLM 512 * $crlf $+ $chr(9) $+ (hangs) $crlf $+ solution: $crlf $+ $chr(9) $+ check @debug if the last thing was $crlf $+ $chr(9) $+ idSOCK AUTH GateKeeper S :OK $crlf $+ $chr(9) $+ run /ud and sign in. you need to set your profile info!
  run notepad idreadme.txt
  if ($version < 6) { if ($input(This script requires mirc 6.x to run properly. Please download it at mirc.com,260,Ugrade mIRC) == $true) { url -n http://mirc.com/get.html } }
  if ($input(please update your passport information,260,Update Passport) == $true) ud
  write ips.id
}
on 1:start:{
  unset %failedonflood
  set %createcat CP
  set %createtopic no\btopic
  set %createserver EN-US
  set %ircvers IRCVERS IRC7 MSN-OCX!7.00.0206.0401 $eval($chr(10),0)
  hmake channels 1000
  hmake ports 1000
  hmake fports 1000
  hmake ips 1000
  if ($exists(ips.id)) hload ips ips.id
  :redo
  var %serverport = $rand(1210,8000)
  if (!$portfree(%serverport)) goto redo
  window -k0 @debug
  window -fk0 @extra 0 0 400 200
  socklisten init %serverport
  localinfo -h
  .timer -m 1 200 server 127.0.0.1 %serverport
  .timer 1 1 ifinds
}
on 1:socklisten:init: {
  sockaccept iserv
  sockclose init
  sockwrite -n iserv :ident 001 $me :Welcome $me
  sockwrite -n iserv :ident 002 $me :This script written by Rylan
  sockwrite -n iserv :ident 003 $me :This server was created on $asctime (timezone offset $duration($timezone) $+ )
  sockwrite -n iserv :ident 004 $me id 2.0 aioxz abcdefhiklmnoprstuvxyz
  sockwrite -n iserv :ident 800 $me 1 0 GateKeeper,NTLM 512 *
}
on 1:sockread:iserv: {
  var %read
  sockread %read
  tokenize 32 %read
  if ($1 == JOIN) {
    if ($sock(id $+ $hget(channels,$2))) { sockwrite -n $sock(id $+ $hget(channels,$2)) join $2 $3- | return }
    find $2 | return
  }
  elseif ($me ison $2) {
    if (!$sock(id $+ $hget(channels,$2))) { find $2 1 | return }
    else sockwrite -n id $+ $hget(channels,$2) $1-
  }
  elseif ($me == $2) && ($sock(id*,0) > 0) sockwrite -n id* $1-
  elseif ($comchan($2,1)) { sockwrite -n id $+ $hget(channels,$comchan($2,1)) $1- | return }
  elseif ($left($2,2) == $chr(37) $+ $chr(35)) && ($sock(id $+ $hget(channels,$2))) { sockwrite -n id $+ $hget(channels,$2) $1- }
  elseif ($sock(id*,1) == $null) {
    if ($1 == NICK) { sockwrite -n $sockname : $+ $me NICK $2 }
    if ($1 == USER) { sockwrite -n $sockname :ident 001 $me : | ircx }
    return 
  }
  elseif ($left($2,2) == $chr(37) $+ $chr(35)) && ($chr(44) isin $2) {
    var %x = 1
    while (%x <= $numtok($2,44)) {
      var %y = $gettok($2,%x,44)
      sockwrite -n id $+ $hget(channels,%y) $1 %y $3-
      inc %x
    }
  }
  elseif ($left($2,2) != $chr(37) $+ $chr(35)) { sockwrite -n id* $1- }
}
menu @debug {
  clear:clear
}
menu @extra {
  clear:clear
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START DIRECTORY CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias find {
  if ($sock(id $+ $hget(channels,$1))) { sockwrite -n $sock(id $+ $hget(channels,$1)) join $1 | return }
  if ($sock(conifindsMAIN).status != active) && (!$2) { echo -s have you ever tried to look up a phone number without opening the telephone book? (/ifinds) | return }
  set %mticks $ticks
  :resock
  var %id = $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z)
  if ($sock(id $+ %id)) goto resock
  hadd channels $1 %id
  :report
  var %chatport = $rand(1210,8000)
  if (!$portfree(%chatport)) goto report
  hadd ports $1 %chatport
  if ($2) {
    echo -s 4 $+ $1 last located on $hget(ips,$1) $+ , attempting to join...
    window -hpk0 @webloader $+ %id
    echo @debug $dll(nHTMLn,attach,$window(@webloader $+ %id).hwnd)
    echo @debug $dll(nHTMLn,select,$window(@webloader $+ %id).hwnd)
    echo @debug $dll(nHTMLn,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49"><PARAM NAME="NickName" VALUE="id"><PARAM NAME="Server" VALUE="127.0.0.1: $+ %chatport $+ "></OBJECT>)
    socklisten initichan $+ %id %chatport
    sockmark initichan $+ %id $1
    sockopen id $+ %id $hget(ips,$1) 6667
    sockmark id $+ %id $1
  }
  set %find $1
  if (!$2) sockwrite -n conifindsMAIN FINDS $1
}
alias multi {
  set %mticks $ticks
  var %x = 1
  while (%x <= $0) {
    var %a = $eval($ $+ %x,2)
    if ($sock(id $+ $hget(channels,%a))) { sockwrite -n id $+ $hget(channels,%a) join %a }
    if (!$sock(id $+ $hget(channels,%a))) var %y = %y %a
    inc %x
  }
  var %x = 1
  while (%x <= $numtok(%y,32)) {
    if ($hget(ips,$gettok(%y,%x,32))) {
      var %z = $gettok(%y,%x,32)
      :resock
      var %id = $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z)
      if ($sock(id $+ %id)) goto resock
      hadd channels %z %id
      :report
      var %chatport = $rand(1210,8000)
      if (!$portfree(%chatport)) goto report
      hadd ports %z %chatport
      echo -s 4 $+ %z last located on $hget(ips,%z) $+ , attempting to join...
      window -hpk0 @webloader $+ $hget(channels,%z)
      echo @debug $dll(nHTMLn,attach,$window(@webloader $+ $hget(channels,%z)).hwnd)
      echo @debug $dll(nHTMLn,select,$window(@webloader $+ $hget(channels,%z)).hwnd)
      echo @debug $dll(nHTMLn,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49"><PARAM NAME="NickName" VALUE="id"><PARAM NAME="Server" VALUE="127.0.0.1: $+ %chatport $+ "></OBJECT>)
      socklisten initichan $+ $hget(channels,%z) $hget(ports,%z)
      sockmark initichan $+ $hget(channels,%z) %z
      sockopen id $+ $hget(channels,%z) $hget(ips,%z) 6667
      sockmark id $+ $hget(channels,%z) %z
    }
    if (!$hget(ips,$gettok(%y,%x,32))) {
      var %b = $gettok(%y,%x,32)
      echo -s 4 $+ %b doesnt exist in recorded ips
      :resock1
      var %id = $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z)
      if ($sock(id $+ %id)) goto resock1
      hadd channels %b %id
      :report1
      var %chatport = $rand(1210,8000)
      if (!$portfree(%chatport)) goto report1
      hadd ports %b %chatport
      ifinds %id %b
    }
    inc %x
  }
}
alias ifinds {
  if ($sock(conifindsMAIN) == $null) && (!$1) {
    window -hpk0 @webloaderMAIN
    echo @debug $dll(nHTMLn,attach,$window(@webloaderMAIN).hwnd)
    echo @debug $dll(nHTMLn,select,$window(@webloaderMAIN).hwnd)
    echo @debug $dll(nHTMLn,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49"><PARAM NAME="RoomName" VALUE="id"><PARAM NAME="NickName" VALUE="id"><PARAM NAME="Server" VALUE="127.0.0.1:6663"></OBJECT>)
    sockopen conifindsMAIN 207.68.167.1 $+ $rand(75,86) 6667
    return
  }
  if ($1) {
    sockopen conifinds $+ $1 207.68.167.1 $+ $rand(75,86) 6667
    sockmark conifinds $+ $1 $2
    :report
    var %fport = $rand(1210,8000)
    if (!$portfree(%fport)) goto report
    hadd fports $2 %fport
    window -hpk0 @webloader $+ $1
    echo @debug $dll(nHTMLn,attach,$window(@webloader $+ $1).hwnd)
    echo @debug $dll(nHTMLn,select,$window(@webloader $+ $1).hwnd)
    echo @debug $dll(nHTMLn,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49"><PARAM NAME="RoomName" VALUE="id"><PARAM NAME="NickName" VALUE="id"><PARAM NAME="Server" VALUE="127.0.0.1: $+ %fport $+ "></OBJECT>)
    return
  }
  if ($sock(conifindsMAIN) != $null) echo -s * $chr(47) $+ ifinds: you already have a socket ( $+ $sock(conifindsMAIN).status $+ ) on a directory server.
}
on 1:sockopen:conifinds????:{
  if ($sockname == conifindsMAIN) .timerfinds 0 15 keepfinds MAIN
  socklisten initifinds $+ $right($sockname,4) $iif($sockname == conifindsMAIN,6663,$hget(fports,$sock($sockname).mark))
}
on 1:socklisten:initifinds????:{ sockaccept ifinds $+ $right($sockname,4) | sockclose $sockname }
on 1:sockread:ifinds????: {
  var %read | sockread %read | tokenize 32 %read
  echo @debug  $+ $sockname $+  %read
  if ($1 == FINDS) { }
  else { 
    if ($sock(conifinds $+ $right($sockname,4)).status == active) { sockwrite -n conifinds $+ $right($sockname,4) $1- }
    else { sockclose $sockname | echo -s couldnt send $1- to directory server. please try reconnecting. }
  }
}
on 1:sockclose:ifinds????:echo -s $sockname closed
on 1:sockread:conifinds????: {
  var %read | sockread %read | tokenize 32 %read
  echo @debug  $+ $sockname $+  $1-
  if ($sock($sockname).mark == $null) var %sockmark = $false
  if ($sock($sockname).mark != $null) var %sockmark = $true
  var %finds = $iif(%sockmark,$sock($sockname).mark,%find)
  if ($2 == 705) && ($sock($sockname).mark) { sockwrite -n $sockname finds $sock($sockname).mark }
  if ($2 == 702) {
    .set %key. [ $+ [ %finds ] ] newkey $+ < $+ $rand(10000,99999) $+ >
    if (%createmode == $null) set %createmode -
    if (%createsection == $null) set %createsection EN-US
    if (%createcat == $null) set %createcat CP
    if (%createtopic == $null) set %createtopic id3.3
    sockwrite -n $sockname CREATE %createcat %finds %createtopic %createmode %createsection 1 %key. [ $+ [ %finds ] ] 0
  }
  if ($2 == 376) {
    sockclose ifinds $+ $right($sockname,4)
    window -c @webloader $+ $right($sockname,4)
    if ($sock($sockname).mark) sockwrite -n $sockname FINDS $sock($sockname).mark
  }
  if ($2 == 642) {
    echo -a $time found user $4-
    set %founduser $4
    if ($dialog(finduser) == $null) { dialog -m finduser finduser }
    did -a finduser 1 $6 $5
  }
  if ($2 == 709) { echo -a this person could not be located on these servers }
  if ($2 == 901) { halt }
  if ($2 == 613) {
    echo -s 4Found %finds on $remove($4,:)
    hadd ips %finds $remove($4,:)
    window -hpk0 @webloader $+ $hget(channels,%finds)
    echo @debug $dll(nHTMLn,attach,$window(@webloader $+ $hget(channels,%finds)).hwnd)
    echo @debug $dll(nHTMLn,select,$window(@webloader $+ $hget(channels,%finds)).hwnd)
    echo @debug $dll(nHTMLn,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49"><PARAM NAME="NickName" VALUE="id"><PARAM NAME="Server" VALUE="127.0.0.1: $+ $hget(ports,%finds) $+ "></OBJECT>)
    sockclose initichan $+ $hget(channels,%finds)
    socklisten initichan $+ $hget(channels,%finds) $hget(ports,%finds)
    sockmark initichan $+ $hget(channels,%finds) %finds
    sockopen id $+ $hget(channels,%finds) $remove($4,:) $5
    sockmark id $+ $hget(channels,%finds) %finds
    hsave -o ips ips.id
    if ($sock($sockname).mark) sockclose $sockname
  }
  if ($2 == 908) { sockclose $sockname }
  if ($2 == 706) || ($2 == 701) || ($2 == 703) || ($2 == 901) { sockclose $sockname | sockclose finds $+ $right($sockname,4) | window -c @webloader $+ $right($sockname,4) | halt }
  elseif ($1 == AUTH) && ($2 != 705) sockwrite -n ifinds $+ $right($sockname,4) $1-
}
on 1:sockclose:conifinds????:{ echo -s 6 $sockname closed | timerfinds $+ $right($sockname,4) off | sockclose ifinds $+ $right($sockname,4) | timerreopenifinds -m 1 600 ifinds }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START CHANNEL CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on 1:socklisten:initichan????:{ sockaccept ichan $+ $right($sockname,4) | sockmark ichan $+ $right($sockname,4) $sock($sockname).mark | sockclose $sockname }
on 1:sockopen:id????:{
  if ($left($me,1) != >) { sockwrite -n $sockname $eval(%ircvers,2) AUTH GateKeeperPassport I :GKSSP\0#7\0\0\0\0\0\0 }
  else { sockwrite -n $sockname $eval(%ircvers,2) $lf AUTH GateKeeper I :GKSSP\0#7\0\0\0\0\0\0 }
}
on 1:sockread:ichan????:{
  var %buff | sockread %buff
  echo @debug  $+ $sockname $+  %buff
  if (AUTH Gatekeeper S isin %buff) {
    if ($left($me,1) != >) { sockwrite -n id $+ $right($sockname,4) %buff }
    else {
      if (!%guestid) set %guestid 123456781234567812345678 $+ $rand(11111111,99999999)
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
      sockwrite -n id $+ $right($sockname,4) $remove(%buff,$right(%buff,%z)) $+ %guest_asc
    }
  }
  else halt
}
on 1:sockread:id????:{
  var %buff | sockread %buff | tokenize 32 %buff
  if ($window(@debug) == $null) window -k0 @debug
  if ($2 == 914) return
  echo @debug  $+ $sockname $+  $1-
  if ($1-4 == AUTH GateKeeper S :OK) {
    sockwrite -n $sockname AUTH GateKeeperPassport S : $+ $passform(%ticket,%profile) $lf USER * "*" "127.0.0.1" : $+ 14i15d $+ $lf nick $me $+ $lf $+ mode $me +i $+ $lf $+ prop $me MSNPROFILE :9 $lf join $sock($sockname).mark $lf
    sockclose ichan $+ $right($sockname,4)
    window -c @webloader $+ $right($sockname,4)
  }
  elseif ($1 == auth) && ($3 == S) {
    if ($sock(ichan $+ $right($sockname,4)).status != active) { .timerdw $+ $right($sockname,4) -m 1 300 sockwrite -n ichan $+ $right($sockname,4) $1- }
    else sockwrite -n ichan $+ $right($sockname,4) $1-
  }
  elseif ($1-3 == AUTH GateKeeper *) {
    sockwrite -n $sockname USER * "*" "127.0.0.1" : $+ 14i15d $+ $lf nick $me $+ $lf join $sock($sockname).mark $lf
    set %address $4
    sockclose ichan $+ $right($sockname,4)
    window -c @webloader $+ $right($sockname,4)
  }
  elseif ($1-3 == AUTH GateKeeperPassport *) { set %address $4 }
  elseif ($4-5 == -q $me) && ($gettok($remove($1,:),1,33) != $me) {
    sockwrite -n iserv $1-
    echo $3 4add deop protection in line $scriptline of $script
  }
  elseif ($2 == KICK) && ($4 == $me) && (%kickflood != $true) {
    echo $3 4* $gettok($remove($1,$chr(58)),1,33) kicked you out of $3 $5-
    sockwrite -n $sockname join $3 %key. [ $+ [ $3 ] ] $lf kick $3 $remove($gettok($1,1,33),:) $lf prop $3 ownerkey $rand(000,999) $+ $r(A,Z) $lf access $3 clear $lf access $3 add owner *! $+ %address 0 : id3.3 $+ $me $cr
    set %kickflood $true
    timer 1 1 set %kickflood pass
  }
  elseif ($4 == OWNERKEY) {
    sockwrite -n iserv $1-
    if ($remove($gettok($1,1,33),$chr(58)) != $me) {
      if ($gettok($5,1,58) == $null) {
        sockwrite -nt $sockname mode $3 -q $remove($gettok($1,1,33),$chr(58)) $lf access $3 clear owner $lf prop $3 ownerkey $chr(127) $+ $rand(0000,9999) $+ $chr(127) $cr
        echo $3 $remove($gettok($1,1,33),$chr(58)) 4NULL OWNERKEY
      }
      else { set %key. [ $+ [ $3 ] ] $gettok($5,1,58) }
    }
    if ($remove($gettok($1,1,33),$chr(58)) == $me) set %key. [ $+ [ $3 ] ] $gettok($5,1,58)
  }
  elseif ($4 == HOSTKEY) {
    sockwrite -n iserv $1-
    if ($gettok($5,1,$asc(:)) == $null) {
      prop $3 hostkey $rand(a,z) $+ « $+ $rand(0000,9999) $+ » $+ $rand(a,z)
      sockwrite -n iserv $1-
    }
    else set %hkey. [ $+ [ $3 ] ] $gettok($5,1,$asc(:))
  }
  elseif ($2 == JOIN) {
    if ($chr(44) isin $3) {
      sockwrite -n iserv $1 $2 $4-
      if ($sock($sockname).mark != $remove($4,:)) sockmark $sockname $remove($4,:)
    }
    if ($chr(44) !isin $3) {
      sockwrite -n iserv $1-
      if ($sock($sockname).mark != $remove($3,:)) sockmark $sockname $remove($3,:)
    }
    if ($gettok($remove($1,:),1,33) == $me) {
      var %x = $round($calc(($ticks - %mticks) / 1000),2)
      if (. !isin %x) { var %x = %x $+ .00 }
      if ($len($gettok(%x,2,46)) < 2) { var %x = %x $+ 0 }
      echo @extra %x » $sock($sockname).mark
    }
    if ($gettok($3,4,44)) {
      sockwrite -n iserv :'itsmagic MODE $remove($4,:) + $+ $replace($gettok($3,4,44),.,q,@,o,+,v) $remove($gettok($1,1,33),:)
    }
  }
  elseif ($1 == PING) sockwrite -n $sockname PONG $2
  elseif ($2 == PRIVMSG) {
    if (VERSION isin $4) { echo -s 7 $remove($gettok($1,1,33),:) 4VERSION | return }
    elseif (TIME isin $4) {
      echo -s 7 $remove($gettok($1,1,33),:) 4TIME
      if (%ctcpflood != $true) && (%timereply == on) { ctcpreply $remove($gettok($1,1,33),:) TIME $eval(%timeformat,3) | set %ctcpflood $true | timer -m 1 600 unset %ctcpflood | return }
    }
    elseif (PING isin $4) { if (PONG! isin $4) { privmsg $remove($gettok($1,1,33),:) REPLY $eval($remove($5,$chr(1)),2) | return } else echo -s 7 $remove($gettok($1,1,33),:) 4PING | return }
    elseif (ID isin $4) && (!%idflood) { set %idflood $true | ctcpreply $remove($gettok($1,1,33),:) id3.3 | .timer 1 1 unset %idflood }
    elseif (FINGER isin $4) { echo -s 7 $remove($gettok($1,1,33),:) 4FINGER | return }
    elseif ($4 != : $+ $chr(1) $+ S) sockwrite -n iserv $1-
    else sockwrite -n iserv $1-3 : $+ $remove($6-,$chr(1))
    halt
  }
  elseif ($2 == quit) { sockwrite -nt iserv $1 PART $sock($sockname).mark 8[quit $+ $replace($3-,$chr(32),$chr(160)) $+ ] | return }
  elseif ($2 == kill) { echo $sock($sockname).mark 4 $+ $1- | echo @kicks 4 $+ $1- }
  elseif ($2-3 == INVITE $me) { window -fk0 @invites -1 -1 400 100 | echo @invites $time(h:nn.ssT) $remove($1,:) invited you to $5 }
  elseif ($2 == 305) { echo $sock($sockname).mark you have been marked as back }
  elseif ($2 == 306) { echo $sock($sockname).mark you have been marked as away }
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
  elseif ($2 == 403) {
    if ($left($4,2) == $chr(37) $+ $chr(35)) {
      var %chan = $sock($sockname).mark
      sockclose $sockname
      :resock
      var %id = $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z)
      if ($sock(id $+ %id)) goto resock
      hadd channels $sock($sockname).mark %id
      ifinds %id %chan
    }
  }
  elseif ($2 == 405) && ($me ison $4) echo -s * /join: already on $4
  elseif ($2 == 451) { find $sock($sockname).mark 1 | sockclose $sockname }
  elseif ($2 == 473) { halt }
  elseif ($2 == 822) { echo $sock($sockname).mark $remove($gettok($1,1,33),:) Away: $right($3-,$calc($len($3-) - 1)) | cline -l 3 $sock($sockname).mark $remove($gettok($1,1,33),:) }
  elseif ($2 == 821) { echo $sock($sockname).mark $remove($gettok($1,1,33),:) Returned | cline -l 15 $sock($sockname).mark $remove($gettok($1,1,33),:) }
  elseif ($2 == 432) || ($2 == 465) { sockclose ichan $+ $right($sockname,4) | sockclose $sockname | window -c @webloader $+ $right($sockname,4) | halt }
  elseif ($2 == 910) {
    set %failedon %failedon $sock($sockname).mark
    sockclose ichan $+ $right($sockname,4)
    sockclose $sockname
    window -c @webloader $+ $right($sockname,4)
    if (!%faildonflood) ud
    set %failedflood $true
    .timerfailfloodunset 1 5 unset %failedonflood
  }
  else sockwrite -n iserv $1-
}
on 1:sockclose:ichan????:echo @debug $sockname just closed
on 1:sockclose:id*:{
  var %chan = $sock($sockname).mark
  set %mticks $ticks
  :resock
  var %id = $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z)
  if ($sock(id $+ %id)) goto resock
  hadd channels %chan %id
  :report
  var %chatport = $rand(1210,8000)
  if (!$portfree(%chatport)) goto report
  hadd ports %chan %chatport
  echo -s 4 $+ %chan last located on $hget(ips,%chan) $+ , attempting to join...
  window -hpk0 @webloader $+ %id
  echo @debug $dll(nHTMLn,attach,$window(@webloader $+ %id).hwnd)
  echo @debug $dll(nHTMLn,select,$window(@webloader $+ %id).hwnd)
  echo @debug $dll(nHTMLn,navigate,about:<OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49"><PARAM NAME="NickName" VALUE="id"><PARAM NAME="Server" VALUE="127.0.0.1: $+ %chatport $+ "></OBJECT>)
  socklisten initichan $+ %id %chatport
  sockmark initichan $+ %id %chan
  sockopen id $+ %id $hget(ips,%chan) 6667
  sockmark id $+ %id %chan
  echo -s 4 $+ $sockname closed
  if ($dialog(socketclosed) == $null) { dialog -mo socketclosed socketclosed }
  did -a socketclosed 2 $asctime
  did -a socketclosed 2 $sockname : $sock($sockname).mark
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias clone {
  unset %clone
  var %x = 1
  while (%x <= $chan(0)) {
    set %clone %clone $chan(%x)
    inc %x
  }
  var %x = 1
  while (%x <= $sock(id*,0)) {
    sockwrite -n $sock(id*,%x) QUIT $1
    inc %x
  }
  sockclose id*
  sockwrite -n iserv : $+ $me $+ ! $+ %address NICK : $+ $1
  set %clone $sorttok(%clone,32)
  multi %clone
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
alias hashman { dialog -m htable htable }
alias findu sockwrite -n conifindsMAIN findu $1-
alias create sockwrite -n conifindsMAIN CREATE CP $chr(37) $+ $remove($1,$chr(37)) R - EN-US 1 id 0
alias gkrand { set %profile $left(%profile,$calc($len(%profile) - 1)) | echo -s random address selected }
alias reconnect { sockclose id $+ $hget(channels,$chan) | find $chan 1 }
alias IRC0 { unset %ircvers | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC | sockclose id $+ $hget(channels,$chan) | find $chan 1 }
alias IRC1 { set %ircvers IRCX $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRCX | sockclose id $+ $hget(channels,$chan) | find $chan 1 }
alias IRC3 { set %ircvers IRCVERS IRC3 MSN-OCX!2.1.7.058 $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC3 | sockclose id $+ $hget(channels,$chan) | find $chan 1 }
alias IRC5 { set %ircvers IRCVERS IRC5 MSN-OCX!2.03.0202.1201 $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC5 | sockclose id $+ $hget(channels,$chan) | find $chan 1 }
alias IRC6 { set %ircvers IRCVERS IRC6 MSN-OCX!2.03.0109.2801 $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC6 | sockclose id $+ $hget(channels,$chan) | find $chan 1 }
alias IRC7 { set %ircvers IRCVERS IRC7 MSN-OCX!7.00.0206.0401 $eval($chr(10),0) | sockwrite -n id $+ $hget(channels,$chan) QUIT :IRC7 | sockclose id $+ $hget(channels,$chan) | find $chan 1 }
;IRCVERS IRC3 MSN-OCX!2.1.7.058
;IRCVERS IRC5 MSN-OCX!2.03.0202.1201
;IRCVERS IRC6 MSN-OCX!2.03.0109.2801
;IRCVERS IRC7 MSN-OCX!7.00.0206.0401
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
dialog socketclosed {
  title "Remote socket closure"
  size -1 -1 175 45
  option dbu
  button "Ok", 1, 1 1 14 42, ok
  list 2, 15 1 160 45, vsbar
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
on 1:dialog:ticket:sclick:1:{
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
on 1:dialog:htable:init:0:{
  var %x = 1
  while (%x <= $hget(0,0).item) {
    did -a htable 2 $hget(%x)
    inc %x
  }
}
on 1:dialog:htable:sclick:2:{
  did -r htable 3
  did -r htable 4
  var %x = 1
  while (%x <= $hget($did(htable,2,$did(2).sel),0).item) {
    did -a htable 3 $hget($did(htable,2,$did(2).sel),%x).item
    inc %x
  }
}
on 1:dialog:htable:sclick:3:{
  did -ra htable 4 $hget($did(htable,2,$did(2).sel),$did(htable,3,$did(3).sel))
}
dialog finduser {
  title %founduser
  size -1 -1 160 125
  option dbu
  list 1, 1 3 158 97, sort size
  button "Exit", 2, 1 104 50 18, ok cancel
  button "Join", 3, 55 104 50 18
  button "Webchat", 4, 109 104 50 18
}
on 1:dialog:finduser:dclick:1:{ join $gettok($did(finduser,1,$did(1).sel),1,32) }
on 1:dialog:finduser:sclick:3:{ join $gettok($did(finduser,1,$did(1).sel),1,32) }
on 1:dialog:finduser:sclick:4:{
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
alias -l guestform {
  return $mid($1,7,2) $+ $mid($1,5,2) $+ $mid($1,3,2) $+ $left($1,2) $+ $mid($1,11,2) $+ $mid($1,9,2) $+ $mid($1,15,2) $+ $mid($1,13,2) $+ $right($1,16)
}
alias keepfinds {
  if ($sock(conifinds $+ $1).status == connecting) { halt }
  if ($sock(conifinds $+ $1) != conifinds $+ $1) { ifinds }
  if ($sock(conifinds $+ $1).status == active) { sockwrite -n conifinds $+ $1 $crlf }
}
dialog socketclosed {
  title "UNEXPECTED SOCKET CLOSE!"
  size -1 -1 175 45
  option dbu
  button "Ok", 1, 1 1 14 42, ok
  list 2, 15 1 160 45, vsbar
}
alias ud {
  window -hp @update
  var %a = $$?="email and password?"
  set %c.addr $replace($gettok(%a,1,32),@,$chr(37) $+ 40)
  var %c.pass = $replace($gettok(%a,2,32),@,$chr(37) $+ 40)
  var %dll = $dll(nHTMLn.dll,attach,$window(@update).hwnd)
  if (%dll != S_OK) && (%dll != E_ALREADY_ATTACHED) echo -s nhtmln error. %dll
  echo @debug $dll(nHTMLn,handler,nHTMLn.handler)
  echo -s $dll(nHTMLn.dll,navigate,https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d20s&login= $+ %c.addr $+ &passwd= $+ %c.pass)
}
alias nHTMLn.handler {
  echo @debug nHTMLn $2-
  if ($2- == document_complete about:blank) .timerclosehtml -m 1 50 window -c @update
  if (http://chat.msn.com/chatroom.msnw?did=1&t= isin $3-) {
    set %ticket $left($gettok($3,3,61),$calc($len($gettok($3,3,61)) - 2))
    set %profile $left($gettok($3,4,61),$calc($len($gettok($3,4,61)) - 3))
    if ($dll(nHTMLn.dll,navigate,http://login.passport.com/logout.srf?lc=1033&sf=1&id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d20s&tw=20&fs=0&cb=&cbid=2260&ts=0&login= $+ %c.addr $+ &domain=hotmail.com&sec=&mspp_shared=&lm=S&seclog=0) != S_OK) { echo -s nhtmln error. }
    echo -s 4Passport info updated successfully!
    echo -s 4You may now join a channel.
    if (%failedon) { multi %failedon | unset %failedon }
  }
  if ($2- == navigate_complete http://login.passport.com/logout.srf?lc=1033&sf=1&id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d20s&tw=20&fs=0&cb=&cbid=2260&ts=0&login= $+ %c.addr $+ &domain=hotmail.com&sec=&mspp_shared=&lm=S&seclog=0) { echo @debug $dll(nHTMLn.dll,navigate,about:blank) }
  return S_OK
}
menu status {
  update passport ticket:ud
}