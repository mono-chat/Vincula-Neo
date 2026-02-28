on *:load:{
  echo -s info:
  echo -s this script is written using all the latest software and protocol available at this time!
  echo -s written on mirc 6.02 and works with msn chat ocx v. 4.2 and uses the brand new IRC7 protocol! (also backwards compatible all the way down to IRC5 if needed)
  echo -s instructions:
  echo -s go to a chatroom and right click the blue bar above the coffee cup...
  echo -s hit view source and search for PassportTicket and copy the PassportTicket and the PassportProfile.
  echo -s come back here and paste them into the labled editboxes and hit ok! /nick yourname if you like.
  echo -s then /join $chr(37) $+ #somewhere or any other msn channel you like!
  echo -s P.S. thx jesse for alias passform and to everyone who helped me test and debug :)
  echo -s -
  echo -s P.P.S. use /clone (name) to change nicks it will rejoin all channels.. /socks to list sockets and, /hashman to view hash tables
  echo -s enjoy! ~Rylan aka ident
  nick idscript $+ $rand(000,999)
  set %away.color 14
  set %back.color 1
  set %tagged
  set %timereply on
  set %timeformat $eval($adate $+ $chr(44) $asctime(h:nn.ss tt),0)
  update
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START LOCALHOST CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
on *:start:{
  write -c web.html <OBJECT ID="ChatFrame" CLASSID="CLSID:7a32634b-029c-4836-a023-528983982a49" width="100%" CODEBASE="http://fdl.msn.com/public/chat/msnchat42.cab#Version=7,00,0206,0401">
  write web.html <PARAM NAME="RoomName" VALUE="somewhere">
  write web.html <PARAM NAME="NickName" VALUE="id">
  write web.html <PARAM NAME='BaseURL' VALUE='http://chat.msn.com/'>
  write web.html <PARAM NAME="Server" VALUE="127.0.0.1:6668">
  write web.html </OBJECT>
  unset %ifindsflood
  hmake channels 1000
  :redo
  var %serverport = $rand(1210,4000)
  if (!$portfree(%serverport)) goto redo
  window -k0 @debug
  socklisten init %serverport
  .timer -m 1 200 server 127.0.0.1 %serverport
  .timer 1 1 localinfo -h
  .timer 1 1 ifinds
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
    if ($sock(id $+ $hget(channels,$2))) { sockwrite -n id $+ $hget(channels,$2) JOIN $2- | return }
    find $2
    return
  }
  elseif ($me ison $2) { sockwrite -n id $+ $hget(channels,$2) $1- | return }
  elseif ($comchan($2,1)) { sockwrite -n id $+ $hget(channels,$comchan($2,1)) $1- | return }
  elseif ($sock(id*,1) == $null) {
    if ($1 == NICK) { sockwrite -n $sockname : $+ $me NICK $2 }
    if ($1 == USER) { sockwrite -n $sockname :ident 001 $me :enjoy | ircx }
    return 
  }
  elseif ($1 == PART) { sockwrite -n id $+ $hget(channels,$2) $1- }
  else { sockwrite -n id* $1- }
}
menu @debug {
  clear:clear
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START DIRECTORY CONNECTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias ifinds {
  if (%ifindsflood == $true) { halt }
  set %ifindsflood $true
  .timer 1 10 unset %ifindsflood
  window -hpk0 @webloader1
  .echo @debug $dll(nHTMLn,attach,$window(@webloader1).hwnd)
  .echo @debug $dll(nHTMLn,select,$window(@webloader1).hwnd)
  .echo @debug $dll(nHTMLn,navigate,$mircdirweb.html)
  sockopen conifinds 207.68.167.184 6667
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
  if ($left($me,1) != >) { sockwrite -n $sockname IRCVERS IRC7 MSN-OCX!7.00.0206.0401 $lf AUTH GateKeeperPassport I :GKSSP\0#7\0\0\0\0\0\0 }
  else { sockwrite -n $sockname IRCVERS IRC7 MSN-OCX!7.00.0206.0401 $lf AUTH GateKeeper I :GKSSP\0#7\0\0\0\0\0\0 }
}
on *:sockread:id*:{
  var %buff
  sockread %buff
  tokenize 32 %buff
  if ($window(@debug) == $null) window -k0 @debug
  if ($2 == 914) return
  echo @debug  $+ $sockname $+  $1-
  if ($1-4 == AUTH GateKeeper S :OK) {
    sockwrite -n $sockname AUTH GateKeeperPassport S : $+ $passform(%ticket,%profile) $lf USER * "*" "127.0.0.1" : $+ 14i15d $+ $lf nick $me $+ $lf prop $me MSNPROFILE :1 $lf join %find $lf
    sockclose ichan
    echo @debug $dll(nHTMLn,navigate,about:blank)
    halt
  }
  elseif ($1 == auth) && ($3 == S) {
    :redo
    if ($sock(ichan)) { sockwrite -n ichan $1- }
    else goto redo
  }
  elseif ($1-3 == AUTH GateKeeper *) {
    sockwrite -n $sockname nick $me $+ $lf join %find
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
  }
  if ($2 == 432) || ($2 == 910) || ($2 == 465) { sockclose ichan | sockclose $sockname | echo @debug $dll(nHTMLn,navigate,about:blank) | halt }
  elseif ($2 == JOIN) {
    if ($chr(44) isin $3) { sockwrite -n iserv $1 $2 $4- }
    if ($chr(44) !isin $3) { sockwrite -n iserv $1- }
    if ($gettok($3,4,44)) {
      sockwrite -n iserv :access MODE $remove($4,:) + $+ $replace($gettok($3,4,44),.,q,@,o,+,v) $remove($gettok($1,1,33),:)
    }
    if ($gettok($remove($1,:),1,33) == $me) { set %jointime 3***Actual Join Time: $round($calc(($ticks - %cticks) / 1000),2) secs }
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
  elseif ($2 == quit) { sockwrite -nt iserv $1 PART $sock($sockname).mark [quit $+ $replace($3-,$chr(32),$chr(160)) $+ ] | return }
  elseif ($2 == kill) { echo $sock($sockname).mark 4 $+ $remove($1-,:) }
  elseif ($2-3 == INVITE $me) { window -fk0 @invites -1 -1 400 100 | echo @invites $time(h:nn.ssT) $remove($1,:) invited you to $5 }
  elseif ($2 == 913) echo -s 4BANNED! from $4 assuming you havent joined already: join would have been $round($calc(($ticks - %cticks) / 1000),2) seconds
  elseif ($1 == PING) sockwrite -n $sockname PONG $2
  elseif ($2 == PRIVMSG) {
    if (VERSION isin $4) { echo -s 7 $remove($gettok($1,1,33),:) 4VERSION | return }
    elseif (TIME isin $4) {
      echo -s 7 $remove($gettok($1,1,33),:) 4TIME
      if (%ctcpflood != $true) && (%timereply == on) { ctcpreply $remove($gettok($1,1,33),:) TIME $eval(%timeformat,3) | set %ctcpflood $true | timer -m 1 600 unset %ctcpflood | return }
    }
    elseif (PING isin $4) { if (PONG! isin $4) { privmsg $remove($gettok($1,1,33),:) REPLY $eval($remove($5,$chr(1)),2) | return } else echo -s 7 $remove($gettok($1,1,33),:) 4PING | return }
    elseif (ID isin $4) ctcpreply $remove($gettok($1,1,33),:) id
    elseif (FINGER isin $4) { echo -s 7 $remove($gettok($1,1,33),:) 4FINGER | return }
    elseif ($4 != : $+ $chr(1) $+ S) sockwrite -n iserv $1-
    else sockwrite -n iserv $1-3 : $+ $remove($6-,$chr(1))
    halt
  }
  elseif ($2 == 473) halt
  elseif ($2 == 822) { echo $sock($sockname).mark $remove($gettok($1,1,33),:) Away: $right($3-,$calc($len($3-) - 1)) | cline -l %away.color $sock($sockname).mark $remove($gettok($1,1,33),:) | sockwrite -n iserv $1- }
  elseif ($2 == 821) { echo $sock($sockname).mark $remove($gettok($1,1,33),:) Returned | cline -l %back.color $sock($sockname).mark $remove($gettok($1,1,33),:) | sockwrite -n iserv $1- }
  else sockwrite -n iserv $1-
}
on *:sockread:ichan:{
  var %buff
  sockread %buff
  echo @debug  $+ $sockname $+  %buff
  if (AUTH Gatekeeper S isin %buff) { sockwrite -n id $+ $hget(channels,%find) %buff }
  else halt
}
on *:sockclose:ichan*:echo @debug $sockname just closed
on 1:sockclose:id*:{
  if (%closeflood != $true) {
    sockwrite -nt iserv : $+ $ial($me) PART $sock($sockname).mark
    find $sock($sockname).mark
  }
  set %closeflood $true
  .timercloseflood -m 1 2200 unset %closeflood
  echo -s 4 $+ $sockname closed
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OTHER STUFF;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
alias update dialog -md ticket ticket
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
alias create sockwrite -n conifinds CREATE TN $chr(37) $+ $remove($1,$chr(37)) idscript - EN-US 1 id $+ $me 0
alias keepfinds {
  if ($sock(conifinds) != conifinds) { ifinds }
  sockwrite -n conifinds CREATE CP $chr(37) $+ #teens idscript - EN-US 1 0 0
}
alias clone {
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
on *:join:#:{
  if ($nick == $me) {
    if ($round($calc(($ticks - %cticks) / 1000),2) <= 5) { set %jointime %jointime Processed Join Time: $round($calc(($ticks - %cticks) / 1000),2) secs | echo -a %jointime | unset %jointime }
    if (%clone == $null) && (%cloning == on) { echo # joined %clonenum channels in $round($calc(($ticks - %clticks) / 1000),2) secs | unset %cloning }
  }
}
on *:kick:#:{
  if ($knick == $me) { join # | kick $chan $nick dont kick me :P lol | access # clear | prop # ownerkey 0 }
}
alias hme {
  if ($1) sockwrite -n id $+ $hget(channels,$chan) mode $me +h $1-
  else sockwrite -n id $+ $hget(channels,$chan) mode $me +h $??
}
raw 332:*:{ if ($3 == idscript) sockwrite -n id $+ $hget(channels,$2) mode $me +h id $+ $me }
