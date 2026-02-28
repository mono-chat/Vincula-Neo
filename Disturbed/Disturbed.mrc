;--------------------------------------------------
; Disturbed Connection v2.0
; Made By zBrute
; Created Using Cypher's Tutorial
; ©2003 - All Rights Reserved.
;
; Updated to the latest msn update.
;--------------------------------------------------

on 1:start:{
  hmake Disturbed 100
  if ($readini(Disturbed/settings.ini,Main,ConnectOnStart) = on) disturbed
  if ($readini(Disturbed/settings.ini,Main,AutoUpdate) = on) .timer 1 1 ud
}
on 1:socklisten:start:{ start localhost $sockname }
on 1:sockopen:finds:{ finds }
on 1:sockread:finds:{
  if ($sockerr) { echo -a * Error: Socket error in $sockname . | return }
  sockread %d
  if ($gettok(%d,1,32) = AUTH) { sockwrite -tn msnocx %d }
  if ($gettok(%d,2,32) = 376) { raw 376 }
  elseif ($gettok(%d,2,32) = 613) {
    if (%findroom = on) { .echo -a * $hget(Disturbed,room) does exist. | set %findroom off | halt }
    else { hadd disturbed ip $+ $hget(Disturbed,room) $right($gettok(%d,4,32),-1) | $raw($hget(Disturbed,room)).613 }
  }
  elseif ($gettok(%d,2,32) = 702) {
    if (%findroom = on) { .echo -a * $hget(Disturbed,room) does not exist. | set %findroom off | halt }
    else { echo -a * $hget(Disturbed,room) Was Not Found. Now Opening Room Creation Dialog. | $create($hget(Disturbed,room)) }
  }
  else writelocal %d
}
on 1:sockclose:finds:{
  if ($timer(finds) { .timerfinds off }
}
on 1:sockread:localhost:{
  if ($sockerr) { echo -a * Error: Socket error in $sockname . | return }
  sockread %d
  if ($gettok(%d,1,32) = msn) {
    if ($sock(disturbed $+ $hget(Disturbed,$gettok(%d,2,32)))) { sockwrite -tn disturbed $+ $hget(Disturbed,$gettok(%d,2,32))) Join $gettok(%d,2,32) | return }
    sockwrite -tn finds FINDS $gettok(%d,2,32)
    hadd disturbed room $gettok(%d,2,32)
    if (%r) { set %r $calc(%r + 1) }
    if (!%r) { set %r 1 }
    if (%r = 11) { set %r 1 }
    if ($gettok(%d,2,32) = %recent1) || ($gettok(%d,2,32) = %recent2) || ($gettok(%d,2,32) = %recent3) || ($gettok(%d,2,32) = %recent4) || ($gettok(%d,2,32) = %recent5) || ($gettok(%d,2,32) = %recent6) || ($gettok(%d,2,32) = %recent7) || ($gettok(%d,2,32) = %recent8) || ($gettok(%d,2,32) = %recent9) || ($gettok(%d,2,32) = %recent10) { return }
    set %recent $+ %r $gettok(%d,2,32)
  }
  if ($gettok(%d,1,32) = HOP) { .sockwrite -tn disturbed $+ $hget(Disturbed,$active) $+(part $active,$lf,join $active) }
  if ($gettok(%d,1,32) = NICK) { sockwrite -tn $sockname : $+ $scid($cid).me NICK $gettok(%d,2,32) }
  if ($gettok(%d,1,32) = FINDU) { sockwrite -tn finds FINDU $gettok(%d,2,32) | set %findu.nick $gettok(%d,2,32) }
  if ($gettok(%d,1,32) = PRIVMSG) && ($sock(disturbed*)) { sockwrite -tn $ifmatch %d | return }
  if ($gettok(%d,1,32) = QUIT) {
    sockwrite -tn disturbed* $gettok(%d,2-,32)
    sockclose disturbed*
    var %a = 1
    while ($chan(%a)) {
      sockwrite -tn $sockname : $+ $ial($scid($cid).me) PART $chan(%a)
      inc %a
    }
  }
  if ($gettok(%d,1,32) = take) {
    if ($gettok(%d,2,32) = elitetake) {
      hadd -m take y "" | var %a = 0, %chan = $active
      while (%a <= $nick(%chan,0)) {
        .inc %a
        if ($nick(%chan,%a) = $scid($cid).me) continue
        hadd -m take y $hget(take,y) $nick(%chan,%a)
        hadd -m take People $hget(take,y)
      }
      .sockwrite -tn disturbed $+ $hget(disturbed,%chan) $+(access %chan clear,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,mode %chan $str(-q,$nick(%chan,0)) $hget(take,people),$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear)
      hfree take
    }
    if ($gettok(%d,2,32) = elitetake2) {
      .var %x = 0, %y = ""
      while (%x <= $nick($active,0)) {
        .inc %x
        if ($nick($active,%x) = $scid($cid).me) continue
        %y = %y $nick($active,%x)
      }
      sockwrite -tn disturbed $+ $hget(disturbed,$active) $+(access $active clear,$cr,prop $active ownerkey fj33r~the~flying~c0wz.,$cr,mode $active $str(-q,$nick($active,0)) %y,$cr,access $active clear,$cr,prop $active ownerkey $r(11111111,99999999))
    }
    if ($gettok(%d,2,32) = sockbot) {
      .var %x = 0, %y = ""
      while (%x <= $nick($active,0)) {
        .inc %x
        if ($nick($active,%x) = $scid($cid).me) continue
        if ($nick($active,%x) = $sock.(nick)) continue
        %y = %y $nick($active,%x)
      }
      sockwrite -tn sock $+ $hget(sock,$active) $+(access $active clear,$cr,prop $active ownerkey fj33r~the~sockbot.,$cr,mode $active $str(-q,$nick($active,0)) %y,$cr,access $active clear,$cr,prop $active ownerkey $r(11111111,99999999))
    }
    if ($gettok(%d,2,32) = nulltake) {
      hadd -m take y "" | var %a = 0, %chan = $active
      while (%a <= $nick(%chan,0)) {
        .inc %a
        if ($nick(%chan,%a) = $scid($cid).me) continue
        hadd -m take y $hget(take,y) $nick(%chan,%a)
        hadd -m take People $hget(take,y)
      }
      .sockwrite -tn disturbed $+ $hget(disturbed,%chan) $+(access %chan clear,$lf,prop %chan ownerkey :,$lf,prop %chan hostkey :,$lf,mode %chan $str(-q,$nick(%chan,0)) $hget(take,people),$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear)
      hfree take
      halt
    }
    if ($gettok(%d,2,32) = kicktake) {
      var %a $nick(%chan,0), %chan = $active
      :a
      if ($nick(%chan,%a) != $scid($cid).me) sockwrite -tn disturbed $+ $hget(disturbed,%chan) kick %chan $nick(%chan,%a) [Kick.Take]
      dec %a
      if (%a > 0) goto a
      else {
        .sockwrite -tn disturbed $+ $hget(disturbed,%chan) prop %chan ownerkey $propkey $lf access %chan clear
      }
    }
    if ($gettok(%d,2,32) = closetake) {
      var %chan = $active, %a $nick(%chan,0)
      .sockwrite -tn disturbed $+ $hget(disturbed,%chan) $+(access %chan clear,$lf,access %chan add deny *!*@*,$lf,mode %chan +mik Owned?)
      :a
      if ($nick(%chan,%a) != $scid($cid).me) .sockwrite -tn disturbed $+ $hget(disturbed,%chan) kick %chan $nick(%chan,%a) (auto/close)
      dec %a
      if (%a > 0) goto a
      else halt
    }
  }
  if ($gettok(%d,1,32) = qa) {
    hadd -m take y "" | var %a = 0, %chan = $active
    while (%a <= $nick(%chan,0)) {
      .inc %a
      if ($nick(%chan,%a) = $scid($cid).me) continue
      hadd -m take y $hget(take,y) $nick(%chan,%a)
      hadd -m take People $hget(take,y)
    }
    .sockwrite -tn disturbed $+ $hget(disturbed,%chan) $+(mode %chan $str(+q,$nick(%chan,0)) $hget(take,people))
    hfree take
  }
  if ($gettok(%d,1,32) = sockmassq) {
    hadd -m mass y ""
    var %a = 0
    while (%a <= $nick($active,0)) {
      .inc %a
      if ($nick($active,%a) isowner $active) continue
      hadd -m mass y $hget(mass,y) $nick($active,%a)
      hadd -m mass People $hget(mass,y)
    }
    sockwrite -tn sock $+ $hget(sock,$active) mode $active $str(+q,$nick($active,0)) $hget(mass,people)
    hfree mass
  }
  elseif ($scid($cid).me ison $gettok(%d,2,32)) && ($sock(disturbed $+ $hget(disturbed,$gettok(%d,2,32)))) { sockwrite -tn disturbed $+ $hget(disturbed,$gettok(%d,2,32)) %d | return }
  elseif ($sock(disturbed*)) { sockwrite -tn $ifmatch %d }
}
on 1:sockread:ocx*:{
  sockread %d
  if ($left($scid($cid).me,1) != >) { %d = $replace(%d,gatekeeper,GateKeeperPassport) }
  if ($gettok(%d,1,32) = AUTH) && ($gettok(%d,4,32) != :ok) { sc disturbed* %d }
}
on 1:sockopen:disturbed*:{ 
  if ($left($scid($cid).me,1) != >)  { sockwrite -tn $sockname $+(NICK $scid($cid).me,$lf,IRCVERS IRC7 MSN-OCX!8.00.0211.1802) }
  else { sockwrite -tn $sockname IRCVERS IRC7 MSN-OCX!8.00.0211.1802 }
}
on 1:sockread:disturbed*: {
  if ($sockerr) { echo -a * Error: Socket error in $sockname . | return }
  :disturbed
  sockread %d
  echo @debug %d
  var %chan = $sock($sockname).mark, %nick = $right($gettok(%d,1,33),-1)
  if ($gettok(%d,4-5,32) = -q $scid($cid).me) && ($readini(Disturbed/settings.ini,Prots,DeownerProt) = on) && ($scid($cid).me !isin $gettok(%d,1,32)) && (%-qflood != on) {
    if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) = on) { sockwrite -tn $sockname $+($gettok(%d,2,32) $gettok(%d,5,32) +h $qkey(%chan).qk,$lf,kick %chan %nick : $+ $readini(Disturbed/settings.ini,prots,DeownerKickMsg),$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me),$lf) | set %-qflood on | .timer -m 1 500 unset %-qflood | writelocal %d | goto disturbed }
    if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) != on) { sockwrite -tn $sockname $+($gettok(%d,2,32) $gettok(%d,5,32) +h $qkey(%chan).qk,$lf,$gettok(%d,2-4,32) %nick,$lf,prop %chan ownerkey $propkey,$lf,access %chan clear,$lf,prop %chan hostkey $propkey,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me),$lf) | set %-qflood on | .timer -m 1 500 unset %-qflood | writelocal %d | goto disturbed }
  }
  if ($gettok(%d,4-,32) = +q $scid($cid).me) {
    if ($readini(Disturbed/settings.ini,Autos,NullTake) = on) {
      .var %a = 0, %y = ""
      while (%a <= $nick(%chan,0)) {
        .inc %a
        if ($nick(%chan,%a) = $scid($cid).me) { continue }
        %y = %y $nick(%chan,%a)
      }
      sockwrite -tn $sockname $+(access %chan clear,$lf,prop %chan ownerkey :,$lf,prop %chan hostkey :,$lf,mode %chan $str(-q,$nick(%chan,0)) %y,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf) | topic %chan Auto Null ( Set on %chan @ $time(h:nntt) ) Disturbed Auto Null Made By zBrute
    }
    if ($readini(Disturbed/settings.ini,Autos,KickTake) = on) {
      var %a $nick(%chan,0)
      :a
      if ($nick(%chan,%a) != $scid($cid).me) sockwrite -tn $sockname kick %chan $nick(%chan,%a) (auto/kick.take)
      dec %a
      if (%a > 0) goto a
      else {
        sockwrite -tn $sockname prop %chan ownerkey $propkey $lf access %chan clear
        topic %chan Auto Kick Take ( Set on %chan @ $time(h:nntt) ) Disturbed Auto Kick Take Made By zBrute
      }
    }
    if ($readini(Disturbed/settings.ini,Autos,CloseTake) = on) {
      .var %a = 0, %y = ""
      while (%a <= $nick(%chan,0)) {
        .inc %a
        if ($nick(%chan,%a) = $scid($cid).me) continue
        %y = %y $nick(%chan,%a)
      }
      sockwrite -tn $sockname $+(access %chan clear,$lf,prop %chan ownerkey :,$lf,prop %chan hostkey :,$lf,mode %chan $str(-q,$nick(%chan,0)) %y,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf)
      topic %chan Auto Close ( Set on %chan @ $time(h:nntt) ) Disturbed Auto Close Made By zBrute
      .sockwrite -tn $sockname $+(access %chan clear,$lf,access %chan add deny *!*@*,$lf,mode %chan +mik Owned?)
      var %a $nick(%chan,0)
      :a
      if ($nick(%chan,%a) != $scid($cid).me) sockwrite -tn $sockname kick %chan $nick(%chan,%a) (auto/close)
      dec %a
      if (%a > 0) goto a
      else halt
    }
    if ($readini(Disturbed/settings.ini,Guests,Ban) = on) {
      var %a $nick(%chan,0)
      :a
      if ($left($nick(%chan,%a),1) = >) sockwrite -tn $sockname kick %chan $nick(%chan,%a) $+(: $+ (+q/Guest Ban.))
      dec %a
      if (%a > 0) goto a
      else { sockwrite -tn $sockname access %chan add deny >* }
    }
    sockwrite -tn $sockname PROP %chan OWNERKEY $propkey
    sockwrite -tn $sockname PROP %chan HOSTKEY $propkey
    sockwrite -tn $sockname ACCESS %chan ADD OWNER $remove($$ial($scid($cid).me),$scid($cid).me)
    writelocal %d
    goto disturbed
  }
  if ($gettok(%d,2,32) = kick) {
    if ($gettok(%d,4,32) = $scid($cid).me) && ($readini(Disturbed/settings.ini,Prots,RevengeProt) = on) { 
      if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) = on) { sockwrite -tn $sockname $+(join %chan $qkey(%chan).qk,$lf,$gettok(%d,2,32) %chan %nick : $+ $readini(Disturbed/settings.ini,prots,RevengeKickMsg),$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me),$lf) | goto disturbed }
      if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) != on) { sockwrite -tn $sockname $+(join %chan $qkey(%chan).qk,$lf,mode %chan -q %nick,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me),$lf) | goto disturbed }
    }
    if ($readini(Disturbed/settings.ini,Prots,MassKickProt)) && ($scid($cid).me isop %chan) {
      inc -u2 [ [ % ] $+ [ kick ] $+ [ %chan ] $+ [ $right($gettok(%d,1,33),-1) ] ] 1
      if ([ [ % ] $+ [ kick ] $+ [ %chan ] $+ [ $right($gettok(%d,1,33),-1) ] ] = $readini(Disturbed/settings.ini,Prots,Kicks)) && ($right($gettok(%d,1,33),-1) != $scid($cid).me) {
        sockwrite -tn $sockname $+(kick %chan %nick $+(: $+ $readini(Disturbed/settings.ini,Prots,MassKickProtMsg)),$lf,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me))
      }
    }
    writelocal %d
    goto disturbed
  }
  if ($gettok(%d,2,32) = prop) {
    if ($gettok(%d,4,32) = ownerkey) {
      if (!$right($gettok(%d,5,32),-1)) && (%nick) && ($scid($cid).me !isin $gettok(%d,1,32)) && ($readini(Disturbed/settings.ini,Prots,NullProt) = on) {
        if ($readini(Disturbed/settings.ini,Prots,NullHopProt) = on) {
          if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = on) { sockwrite -tn $sockname $+(part %chan,$lf,join %chan,$lf,KICK %chan %nick : $+ $readini(Disturbed/settings.ini,prots,NullKickMsg),$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me)) }
          if ($readini(Disturbed/settings.ini,Prots,NullKickProt) != on) { sockwrite -tn $sockname $+(part %chan,$lf,join %chan,$lf,mode %chan -q %nick,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me)) }
        }
        if ($readini(Disturbed/settings.ini,Prots,NullHopProt) != on) {
          if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = on) { sockwrite -tn $sockname $+(KICK %chan %nick : $+ $readini(Disturbed/settings.ini,prots,NullKickMsg),$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me)) }
          if ($readini(Disturbed/settings.ini,Prots,NullKickProt) != on) { sockwrite -tn $sockname $+(mode %chan -q %nick,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me)) }
        }
      }
      qkey q %chan $iif(!$right($gettok(%d,5,32),-1),null,$mid($gettok(%d,5,32),2))
      writeini Disturbed/props.ini q %chan $iif(!$right($gettok(%d,5,32),-1),null,$mid($gettok(%d,5,32),2))
    }
    if ($gettok(%d,4,32) = hostkey) {
      set %hostkey $iif(!$right($gettok(%d,5,32),-1),null,$mid($gettok(%d,5,32),2))
      writeini Disturbed/props.ini o %chan $iif(!$right($gettok(%d,5,32),-1),null,$mid($gettok(%d,5,32),2))
    }
    if ($gettok(%d,4,32) = onjoin) { .writeini Disturbed/props.ini $gettok(%d,4,32) %chan $right($gettok(%d,5-,32),-1) }
    if ($gettok(%d,4,32) = onpart) { .writeini Disturbed/props.ini $gettok(%d,4,32) %chan $right($gettok(%d,5-,32),-1) }
    if ($readini(Disturbed/settings.ini,Prots,PassFloodProt) = on) {
      inc -u2 [ [ % ] $+ [ prop ] $+ [ %chan ] $+ [ $right($gettok(%d,1,33),-1) ] ] 1
      if ([ [ % ] $+ [ prop ] $+ [ %chan ] $+ [ $right($gettok(%d,1,33),-1) ] ] = $readini(Disturbed/settings.ini,Prots,Props)) && ($right($gettok(%d,1,33),-1) != $scid($cid).me) {
        sockwrite -tn $sockname $+(kick %chan %nick $+(: $+ $readini(Disturbed/settings.ini,Prots,PassFloodProtMsg)),$lf,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me))
      }
    }
    writelocal %d
    goto disturbed
  }
  if ($gettok(%d,1,32) = AUTH) {
    if ($gettok(%d,3,32) = S) {
      if ($gettok(%d,4,32) != :ok) { sockwrite -tn ocx* %d }
      if ($gettok(%d,4,32) = :ok) { sockwrite -tn $sockname $+(AUTH GateKeeperPassport S : $+ $passform,$lf,USER Toyzx . . :Disturbed by Cypher FUCKING SUCKS -- Sky) | sockwrite -tn $sockname SUBSCRIBERINFO : $+ %subinfo | sockwrite -tn $sockname join $hget(Disturbed,room) $hget(Disturbed,$hget(Disturbed,room)) | sockclose ocx* | window -c @msnchatcontrol $+ $right($sockname,4) }
    }
    elseif ($gettok(%d,3,32) = *) {
      if ($left($scid($cid).me,1) = >) { 
        sockwrite -tn $sockname $+(USER Toyzx . . :Disturbed by Cypher FUCKING SUCKS -- Sky,$lf,nick $scid($cid).me)
        sockwrite -tn $sockname join $hget(Disturbed,room) $hget(Disturbed,$hget(Disturbed,room))
        sockclose ocx*
        window -c @msnchatcontrol $+ $right($sockname,4) 
      }
    }
  }
  if ($gettok(%d,2,32) = 002) { sockclose ocx* | closechatcontrol  }
  if ($gettok(%d,2,32) isin 001 003 004 251 252 253 254 255 265 266 301 366 401 405 422 439 441 442 451 462 306 914 374) { return }
  if ($gettok(%d,2,32) = JOIN) {
    writelocal $gettok(%d,1,32) $gettok(%d,2,32) $gettok(%d,4-,32)
    if ($gettok(%chan,4,44)) { writelocal :access MODE $right($gettok(%d,4,32),-1) + $+ $replace($gettok(%chan,4,44),.,q,@,o,+,v) %nick }
    if (%nick = $scid($cid).me) && ($readini(Disturbed/settings.ini,Main,AutoQ) = on) { .sockwrite -tn $sockname mode $scid($cid).me +h $readini(Disturbed/props.ini,q,%chan) }
    if ($left(%nick,1) = >) && ($readini(Disturbed/settings.ini,Guests,Ban) = on) && ($scid($cid).me isop %chan) { sockwrite -tn $sockname $+(access %chan add deny >*,$lf,kick %chan %nick $+(:Guest Ban.)) }
    halt
  }
  if ($gettok(%d,2,32) = PRIVMSG) {
    if ($gettok(%d,4,32) = :VERSION) {
      if ($readini(Disturbed/settings.ini,Custom,VersionKicker) = on) { sockwrite -tn $sockname $+(kick %chan %nick $+(: $+ $readini(Disturbed/settings.ini,Custom,VersionKick)),$lf,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me)) }
      else { sockwrite -tn $sockname NOTICE %nick :VERSION $readini(Disturbed/settings.ini,Custom,VersionReply)  | return }
    }
    if ($gettok(%d,4,32) = :Time) {
      if ($readini(Disturbed/settings.ini,Custom,TimeKicker) = on) { sockwrite -tn $sockname $+(kick %chan %nick $+(: $+ $readini(Disturbed/settings.ini,Custom,TimeKick)),$lf,$lf,prop %chan ownerkey $propkey,$lf,prop %chan hostkey $propkey,$lf,access %chan clear,$lf,access %chan add owner $remove($$ial($scid($cid).me),$scid($cid).me)) }
      else { sockwrite -tn $sockname NOTICE %nick :Time $readini(Disturbed/settings.ini,Custom,TimeReply)  | return }
    }
    if ($gettok(%d,4,32) != :S) { writelocal %d }
    else { writelocal $gettok(%d,1-3,32) : $+ $remove($gettok(%d,6-,32),) }
    return 
  }
  if ($gettok(%d,2,32) = WHISPER) {
    if ($readini(Disturbed/settings.ini,Main,Whispers) = off) { sockwrite -tn $sockname WHISPER $comchan(%nick,1) %nick : Whispers are disabled. Sorry. | return }
    if ($gettok(%d,5,32) = :S) && ($readini(Disturbed/settings.ini,Main,Whispers) = on) { writelocal $gettok(%d,1,32) PRIVMSG $scid($cid).me : $left($gettok(%d,7-,32),-1) }
    else { writelocal $gettok(%d,1,32) PRIVMSG $scid($cid).me $gettok(%d,5-,32) | return }
  }
  if ($gettok(%d,1,32) = PING) { sockwrite -tn $sockname PONG $gettok(%d,2,32) }
  if ($gettok(%d,2,32) = 353) { var %a = 5, %n = "" | while (%a < $numtok(%d,32)) { inc %a | var %n = %n $gettok($gettok(%d,%a,32),-1,44) } | writelocal $gettok(%d,1-5,32) : $+ %n | return }
  if ($gettok(%d,2,32) = 910) { sockclose $sockname | sockclose ocx* | closechatcontrol | echo -a * Passport Outdated. Now Updating.... | ud }
  if ($gettok(%d,2,32) = 465) { sockclose ocx* | closechatcontrol | echo -a * You Are Banned From This Server. }
  writelocal %d
}
on 1:sockread:msnocx:{
  if ($sockerr) { echo -a * Error: Socket error in $sockname . | return }
  sockread %d
  if ($gettok(%d,1,32) = IRCVERS) || ($gettok(%d,1,32) = AUTH) { sc finds %d }
  if ($gettok(%d,1,32) = Nick) { sockwrite -tn finds Nick $scid($cid).me }
}
on 1:socklisten:startchan*:{ sockaccept ocx* | sockclose $sockname }
on 1:socklisten:msnauth:{ sockaccept msnocx | sockclose $sockname }

;;; end of Sock Events

;;; aliases

alias disturbed {
  dc
  if (!$hget(Disturbed)) hmake Disturbed 100
  begin
}
alias dc {
  $s.c(msn*,localhost,chan*,auth*,star*,disturbed*,finds)
  if ($hget(Disturbed)) hfree disturbed
  .timerfinds off
}
alias begin {
  :p
  var %p $r(1200,7000)
  if (!$portfree(%p)) goto p
  socklisten start %p
  server 127.0.0.1 %p
  sockopen finds $ip.port
}
alias clsid { return ECCDBA05-B58F-4509-AE26-CF47B2FFC3FE }
alias eXploit {
  if ($isid) {
    if ($prop = chatcontrol) {
      window -h @msnchatcontrol
      $nHTMLn attach $window(@msnchatcontrol).hwnd
      $nHTMLn navigate about:<OBJECT ID="ChatFrame" CLASSID="CLSID: $+ $clsid $+ "><PARAM NAME="RoomName" VALUE="Disturbed"><PARAM NAME="NickName" VALUE=" $+ $mnick $+ "><PARAM NAME="Server" VALUE=" $+ $1 $+ : $+ $2 $+ "></OBJECT>
    }
  }
  else {
    if ($1 = raw) { 
      window -h @msnchatcontrol $+ $2
      $nHTMLn attach $window(@msnchatcontrol $+ $2).hwnd
      $nHTMLn navigate about:<OBJECT ID="ChatFrame" CLASSID="CLSID: $+ $clsid $+ "><PARAM NAME="RoomName" VALUE="Disturbed"><PARAM NAME="NickName" VALUE=" $+ $mnick $+ "><PARAM NAME="Server" VALUE=" $+ $hget(Disturbed,ip $+ $hget(Disturbed,room)) $+ : $+ $hget(Disturbed,port $+ $2) $+ "></OBJECT>
    }
  }
}
alias raw {
  if ($isid) {
    if ($prop = 613) {
      writelocal :Msn 001 $scid($cid).me : $+ * Room Found: $1
      hadd disturbed roomid $r(1111,9999)
      hadd disturbed $1 $hget(Disturbed,roomid)
      hadd disturbed port $+ $hget(Disturbed,roomid) $r(1300,8000)
      sockopen disturbed $+ $hget(Disturbed,roomid) $hget(Disturbed,ip $+ $1) $right($ip.port,-15)
      sockmark disturbed $+ $hget(Disturbed,roomid) $1
      eXploit raw $hget(Disturbed,roomid)
      socklisten startchan $+ $hget(Disturbed,roomid) $hget(Disturbed,port $+ $hget(Disturbed,roomid))
    }
  }
  else {
    if ($1 = 376) {
      writelocal :Msn 001 $scid($cid).me : $+  * Connection Established.
      sockclose msnocx
      closechatcontrol
    }
  }
}
alias finds {
  .timerfinds 0 3 keepfinds
  socklisten msnauth $right($ip.port,-15)
  var %a = $left($ip.port,-5), %b = $right($ip.port,-15)
  $eXploit(%a,%b).chatcontrol
}
alias keepfinds {
  if ($sock(finds)) { sockwrite -tn finds }
  else { .timerfinds off }
}
alias start {
  sockaccept $1
  sockclose $2
  writelocal :Msn 001 $scid($cid).me : $+ * Establishing a Connection.........
}
alias passform {
  if ($readini(Disturbed/settings.ini,Main,Rgk) = on) { return $base($len(%ticket),10,16,8) $+ %ticket $+ $base($len($r(aaa,zzz) $+ $r(0,9) $+ $r(aaaa,zzzz) $+ $r(0,9) $+ $r(aa,zz) $+ $r(0,9) $+ $r(a,z) $+ $r(0,9) $+ $r(aa,zz) $+ $r(0,9) $+ $r(a,z)),10,16,8) $+ $r(aaa,zzz) $+ $r(0,9) $+ $r(aaaa,zzzz) $+ $r(0,9) $+ $r(aa,zz) $+ $r(0,9) $+ $r(a,z) $+ $r(0,9) $+ $r(aa,zz) $+ $r(0,9) $+ $r(a,z) | halt }
  else { return $base($len(%ticket),10,16,8) $+ %ticket $+ $base($len(%profile),10,16,8) $+ %profile }
}
alias sc {
  if (!$sock($1)) { halt }
  if ($sock($1).status = active) { sockwrite -tn $1 $2- }
  else { .timer -m 1 5 sc $1 $2- }
}
alias qkey {
  if ($isid) {
    if ($prop = qk) { return $hget(q,$1) }
  }
  else {
    if ($1 = q) { hadd -m $1 $2 $3 }
  }
}
alias m {
  if ($1) { msn $iif($left($roomname($replace($replace($1-,$chr(44),$chr(92) $+ $chr(99)),$chr(32),$chr(92) $+ $chr(98))),2) != $chr(37) $+ $chr(35),$chr(37) $+ $chr(35)) $+ $replace($1-,$chr(44),$chr(92) $+ $chr(99),$chr(32),$chr(92) $+ $chr(98)) }
  if (!$1) { m $?="Please Enter A Room Name:" }
}
alias pass {
  if ($1) { mode $scid($cid).me +h $1- }
  if (!$1) { mode $scid($cid).me +h $?="Enter Pass to Use:" }
}
alias upass { .sockwrite -tn disturbed $+ $hget(Disturbed,#) mode $scid($cid).me +h $readini(Disturbed/props.ini,q,#)  }
alias writelocal { sockwrite -tn localhost $1- }
alias s.c { sockclose $1 | sockclose $2 | sockclose $3 | sockclose $4 | sockclose $5 | sockclose $6 | sockclose $7 | closechatcontrol }
alias closechatcontrol { close -@ @msnchatcontrol* }
alias nHTMLn { return dll $mircdir $+ /nHTMLn_2.92.dll }
alias roomsock { return disturbed $+ $hget(Disturbed,#) }
alias ip.port { return 207.68.167.253 6667 }
alias propkey { return [Disturbed] $+ -- $+ $r(11,99) $+ $r(Aa,Zz) $+ $r(11,99) }

;;; end of aliases

;;; dialogs

alias settings $dialog(settings,settings)
dialog settings {
  title "Disturbed Connection Settings"
  size -1 -1 168 115
  option dbu
  icon Disturbed/Disturbed.ico, 0
  tab "Connection", 1, 3 2 162 110
  text "Disturbed Connection v2.0 By zBrute ©2003", 19, 11 100 109 8, tab 1
  box "Room Joiner", 2, 7 18 156 24, tab 1
  text "Channel Name:", 3, 11 28 40 8, tab 1
  edit "", 4, 53 27 70 10, tab 1 autohs
  button "Join", 5, 127 27 30 10, tab 1
  box "Connection", 6, 7 44 156 52, tab 1
  button "Connect", 7, 12 54 38 10, tab 1
  button "Disconnect", 8, 52 54 38 10, tab 1
  check "Connect on Start", 9, 13 83 53 10, tab 1
  text "Msn Chat CLSID:", 40, 13 69 43 8, tab 1
  edit "", 41, 59 68 100 10, tab 1 autohs
  button "Register MsnChatX.ocx", 10, 92 54 66 10, tab 1
  button "Ok", 12, 128 99 30 10, tab 1 ok
  tab "Passports", 43
  list 11, 7 19 155 50, tab 43 size
  button "Add", 14, 9 83 36 10, tab 43
  button "Delete", 15, 48 83 36 10, tab 43
  button "Edit", 16, 87 83 36 10, tab 43
  button "Update", 17, 126 83 35 10, tab 43
  box "", 32, 7 93 156 17, tab 43
  check "Update Passport on Start", 45, 86 98 72 10, tab 43
  edit "", 13, 7 70 155 10, tab 43 read autohs
  check "Use Random Gatekeeper", 18, 11 98 71 10, tab 43
  tab "Protections and Takes, etc.", 46
  box "Protections", 20, 8 18 153 69, tab 46
  check "Deowner Protection", 21, 12 27 59 10, tab 46 flat
  check "Kick Protection", 25, 12 40 47 10, tab 46 flat
  check "Null Pass Protection", 29, 12 53 59 10, result tab 46 flat
  check "Hop When Ownerkey is Nulled", 30, 12 65 85 10, tab 46
  check "-Q", 39, 74 27 17 10, tab 46
  check "-Q", 22, 74 40 17 10, tab 46
  check "-Q", 26, 74 53 17 10, tab 46
  edit "", 24, 115 27 43 10, tab 46 autohs
  edit "", 28, 115 40 43 10, tab 46 autohs
  edit "", 33, 115 53 43 10, tab 46 autohs
  check "Kick", 31, 94 27 21 10, tab 46
  check "Kick", 23, 94 40 21 10, tab 46
  check "Kick", 27, 94 53 21 10, tab 46
  box "Auto Takes", 34, 8 88 153 21, tab 46
  check "Auto Null", 35, 14 96 35 10, tab 46
  check "Auto Kick Take", 36, 51 96 50 10, tab 46
  check "Auto Close", 37, 103 96 38 10, tab 46
  check "Allow Whispers", 42, 103 65 48 10, tab 46
  check "Guest Ban / Bans guest on join and when you get +q.", 86, 12 75 145 10, tab 46
  tab "Floods, Mass Protections", 38
  box "", 44, 8 17 155 19, tab 38
  check "Mass Kick Protection", 47, 13 23 64 10, tab 38
  box "", 48, 8 32 155 20, tab 38
  text "After", 49, 13 39 13 8, tab 38
  edit "", 50, 28 38 20 10, tab 38 autohs
  text "kicks", 51, 51 39 13 8, tab 38
  check "-Q", 52, 67 38 18 10, tab 38
  check "Kick", 53, 87 38 21 10, tab 38
  edit "", 54, 108 38 51 10, tab 38 autohs
  check "Pass Flood Protection", 56, 13 60 63 10, tab 38
  box "", 55, 8 54 155 19, tab 38
  box "", 57, 8 69 155 39, tab 38
  check "-Q", 61, 13 90 17 10, tab 38
  edit "", 63, 63 90 95 10, tab 38 autohs
  text "After", 58, 13 77 13 8, tab 38
  edit "", 59, 28 76 20 10, tab 38 autohs
  text "ownerkey or hostkey props:", 60, 52 77 71 8, tab 38
  check "Kick", 62, 39 90 21 10, tab 38
  tab "Ctcp Replys , etc.", 64
  box "Version", 65, 8 17 154 39, tab 64
  text "Version Reply:", 66, 15 27 36 8, tab 64
  edit "", 67, 54 26 104 10, tab 64
  check "Kick", 68, 15 39 20 10, tab 64
  text "Kick Message:", 69, 40 40 36 8, tab 64
  edit "", 70, 78 39 80 10, tab 64
  text "Custom Tag:", 77, 9 100 33 8, tab 64
  edit "", 78, 45 99 117 10, tab 64
  box "Time", 71, 8 58 154 39, tab 64
  text "Time Reply:", 72, 15 69 31 8, tab 64
  edit "", 73, 54 68 104 10, tab 64
  edit "", 76, 78 81 80 10, tab 64
  text "Kick Message:", 75, 40 82 36 8, tab 64
  check "Kick", 74, 15 81 20 10, tab 64
  tab "Popups", 79
  box "Popups", 80, 8 18 153 73, tab 79
  check "Show in menubar popups", 81, 13 28 73 10, tab 79
  check "Show in status popups", 82, 13 43 73 10, tab 79
  check "Show in channel popups", 83, 13 59 73 10, tab 79
  check "Show in nicklist popups", 84, 13 75 73 10, tab 79
  tab "Sockbot", 87
  box "Disturbed Sockbot Settings", 85, 8 18 153 90, tab 87
  text "Sockbot Type:", 90, 15 29 36 8, tab 87
  radio "Guest Type", 91, 56 28 38 10, tab 87
  radio "Passport Type", 92, 102 28 47 10, tab 87
  text "Passport Email:", 94, 15 48 38 8, tab 87
  edit "", 95, 67 47 88 10, tab 87 autohs
  text "Passport Password:", 96, 15 60 49 8, tab 87
  box "", 93, 14 40 142 4, tab 87
  edit "", 97, 67 59 88 10, tab 87 autohs pass
  box "", 98, 14 83 142 4, tab 87
  text "Sockbot Nick:", 99, 14 92 34 8, tab 87
  edit "", 100, 51 91 55 10, tab 87 autohs
  button "Save Nick", 101, 111 91 45 10, tab 87
  button "Update Sockbot Passport", 88, 15 72 68 10, tab 87
  button "Save Passport Info", 89, 86 72 68 10, tab 87
}
on *:dialog:settings:init:*:{
  var %d = $dname
  if ($readini(Disturbed/settings.ini,Main,ConnectOnStart) = on) { did -c %d 9 }
  if ($readini(Disturbed/settings.ini,Prots,DeownerProt) = on) { did -c %d 21 }
  if ($readini(Disturbed/settings.ini,Prots,DeownerProt) != on) { did -b %d 24,31,39 }
  if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) = on) { did -c %d 31 }
  if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) != on) { did -c %d 39 | did -b %d 24 }
  if ($readini(Disturbed/settings.ini,Prots,RevengeProt) = on) { did -c %d 25 }
  if ($readini(Disturbed/settings.ini,Prots,RevengeProt) != on) { did -b %d 22,23,28 }
  if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) = on) { did -c %d 23 }
  if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) != on) { did -c %d 22 | did -b %d 28 }
  if ($readini(Disturbed/settings.ini,Prots,NullProt) = on) { did -c %d 29 }
  if ($readini(Disturbed/settings.ini,Prots,NullProt) != on) { did -b %d 26,27,30,33 }
  if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = on) { did -c %d 27 }
  if ($readini(Disturbed/settings.ini,Prots,NullKickProt) != on) { did -c %d 26 | did -b %d 33 }
  if ($readini(Disturbed/settings.ini,Prots,NullHopProt) = on) { did -c %d 30 }
  if ($readini(Disturbed/settings.ini,Autos,NullTake) = on) { did -c %d 35 }
  if ($readini(Disturbed/settings.ini,Autos,KickTake) = on) { did -c %d 36 }
  if ($readini(Disturbed/settings.ini,Autos,CloseTake) = on) { did -c %d 37 }
  if ($readini(Disturbed/settings.ini,Main,Rgk) = on) { did -c %d 18 }
  if ($readini(Disturbed/settings.ini,Main,Whispers) = on) { did -c %d 42 }
  if ($readini(Disturbed/settings.ini,Main,AutoUpdate) = on) { did -c %d 45 }
  if ($readini(Disturbed/settings.ini,Prots,MassKickProt) = on) { did -c %d 47 }
  if ($readini(Disturbed/settings.ini,Prots,MassKickProt) != on) { did -b %d 50,52,53,54 }
  if ($readini(Disturbed/settings.ini,Prots,MassKickKickProt) = on) { did -c %d 53 }
  if ($readini(Disturbed/settings.ini,Prots,MassKickKickProt) != on) { did -c %d 52 | did -b %d 54 }
  if ($readini(Disturbed/settings.ini,Prots,PassFloodProt) = on) { did -c %d 56 }
  if ($readini(Disturbed/settings.ini,Prots,PassFloodProt) != on) { did -b %d 59,61,62,63 }
  if ($readini(Disturbed/settings.ini,Prots,PassFloodKickProt) = on) { did -c %d 62 }
  if ($readini(Disturbed/settings.ini,Prots,PassFloodKickProt) != on) { did -c %d 61 | did -b %d 63 }
  if ($readini(Disturbed/settings.ini,Custom,VersionKicker) = on) { did -c %d 68 }
  if ($readini(Disturbed/settings.ini,Custom,VersionKicker) != on) { did -b %d 70 }
  if ($readini(Disturbed/settings.ini,Custom,TimeKicker) = on) { did -c %d 74 }
  if ($readini(Disturbed/settings.ini,Custom,TimeKicker) != on) { did -b %d 76 }
  if ($readini(Disturbed/settings.ini,Guests,Ban) = on) { did -c %d 86 }
  if ($readini(Disturbed/settings.ini,Sockbot,Type) = guest) { did -c %d 91 }
  if ($readini(Disturbed/settings.ini,Sockbot,Type) != guest) { did -c %d 92 }
  if ($group(#menubar).status = on) { did -c %d 81 }
  if ($group(#status).status = on) { did -c %d 82 }
  if ($group(#channel).status = on) { did -c %d 83 }
  if ($group(#nicklist).status = on) { did -c %d 84 }
  did -a %d 13 Current Passport: %email
  did -a %d 24 $readini(Disturbed/settings.ini,prots,DeownerKickMsg)
  did -a %d 28 $readini(Disturbed/settings.ini,prots,RevengeKickMsg)
  did -a %d 33 $readini(Disturbed/settings.ini,prots,NullKickMsg)
  did -a %d 41 $readini(Disturbed/settings.ini,Main,clsid)
  did -a %d 50 $readini(Disturbed/settings.ini,Prots,Kicks)
  did -a %d 59 $readini(Disturbed/settings.ini,Prots,Props)
  did -a %d 54 $readini(Disturbed/settings.ini,Prots,MassKickProtMsg)
  did -a %d 63 $readini(Disturbed/settings.ini,Prots,PassFloodProtMsg)
  did -a %d 70 $readini(Disturbed/settings.ini,Custom,VersionKick)
  did -a %d 76 $readini(Disturbed/settings.ini,Custom,TimeKick)
  did -a %d 67 $readini(Disturbed/settings.ini,Custom,VersionReply)
  did -a %d 73 $readini(Disturbed/settings.ini,Custom,TimeReply)
  did -a %d 78 $readini(Disturbed/settings.ini,Custom,Tag)
  did -a %d 100 $readini(Disturbed/settings.ini,Sockbot,Nick)
  did -a %d 95 $gettok(%sockinfo,1,32)
  did -a %d 97 $gettok(%sockinfo,2,32)
  getpassports
}
on *:dialog:settings:sclick:5:{ m $did(4) }
on *:dialog:settings:sclick:7:{ disturbed }
on *:dialog:settings:sclick:8:{ dc }
on *:dialog:settings:sclick:9:{
  if ($readini(Disturbed/settings.ini,Main,ConnectOnStart) = on) { .writeini Disturbed/settings.ini Main ConnectOnStart off | halt }
  if ($readini(Disturbed/settings.ini,Main,ConnectOnStart) = off) { .writeini Disturbed/settings.ini Main ConnectOnStart on | halt }
}
on *:dialog:settings:sclick:10:{ run regsvr32 Disturbed/MsnChatX.ocx }
on *:dialog:settings:sclick:11:{
  .set %email $did($dname,11).seltext
  .set %pass $readini(Disturbed/passports.ini,$did($dname,11).seltext,password)
  did -ra $dname 13 Current Passport: %email
}
on *:dialog:settings:sclick:12:{
  .writeini Disturbed/settings.ini Main clsid $did(41)
  .writeini Disturbed/settings.ini Prots DeownerKickMsg $did(24)
  .writeini Disturbed/settings.ini Prots RevengeKickMsg $did(28)
  .writeini Disturbed/settings.ini Prots NullKickMsg $did(33)
  .writeini Disturbed/settings.ini Prots MassKickProtMsg $did(54)
  .writeini Disturbed/settings.ini Prots PassFloodProtMsg $did(63)
  .writeini Disturbed/settings.ini Prots Kicks $did(50)
  .writeini Disturbed/settings.ini Prots Props $did(59)
  .writeini Disturbed/settings.ini Custom VersionReply $did(67)
  .writeini Disturbed/settings.ini Custom VersionKick $did(70)
  .writeini Disturbed/settings.ini Custom TimeReply $did(73)
  .writeini Disturbed/settings.ini Custom TimeKick $did(76)
  .writeini Disturbed/settings.ini Custom Tag $did(78)
  dialog -x $dname $dname
}
on *:dialog:settings:sclick:14:{ dialog -m apass apass }
on *:dialog:settings:sclick:15:{ remini Disturbed/passports.ini $did($dname,11).seltext | getpassports }
on *:dialog:settings:sclick:16:{ editpassport }
on *:dialog:settings:sclick:17:{ ud }
on *:dialog:settings:sclick:18:{
  if ($readini(Disturbed/settings.ini,Main,Rgk) = on) { .writeini Disturbed/settings.ini Main Rgk off | halt }
  if ($readini(Disturbed/settings.ini,Main,Rgk) = off) { .writeini Disturbed/settings.ini Main Rgk on | halt }
}
on *:dialog:settings:sclick:21:{
  if ($readini(Disturbed/settings.ini,Prots,DeownerProt) = on) {
    .writeini Disturbed/settings.ini Prots DeownerProt off
    .did -b $dname 24,31,39
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,DeownerProt) = off) {
    .writeini Disturbed/settings.ini Prots DeownerProt on
    .did -e $dname 31,39
    if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) = on) { did -e $dname 24 }
    halt
  }
}
on *:dialog:settings:sclick:22:{
  if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) = on) {
    .writeini Disturbed/settings.ini Prots RevengeKickProt off
    did -u $dname 23
    did -b $dname 28 
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) = off) {
    .writeini Disturbed/settings.ini Prots RevengeKickProt on
    did -c $dname 23
    did -e $dname 28
    halt
  }
}
on *:dialog:settings:sclick:23:{
  if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) = on) {
    .writeini Disturbed/settings.ini Prots RevengeKickProt off
    did -c $dname 22
    did -b $dname 28
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) = off) {
    .writeini Disturbed/settings.ini Prots RevengeKickProt on
    did -u $dname 22
    did -e $dname 28 
    halt
  }
}
on *:dialog:settings:sclick:25:{
  if ($readini(Disturbed/settings.ini,Prots,RevengeProt) = on) {
    .writeini Disturbed/settings.ini Prots RevengeProt off
    .did -b $dname 22,23,28
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,RevengeProt) = off) {
    .writeini Disturbed/settings.ini Prots RevengeProt on
    .did -e $dname 22,23
    if ($readini(Disturbed/settings.ini,Prots,RevengeKickProt) = on) { did -e $dname 28 }
    halt
  }
}
on *:dialog:settings:sclick:26:{
  if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = on) {
    .writeini Disturbed/settings.ini Prots NullKickProt off
    did -u $dname 27
    did -b $dname 33 
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = off) {
    .writeini Disturbed/settings.ini Prots NullKickProt on
    did -c $dname 27
    did -e $dname 33 
    halt
  }
}
on *:dialog:settings:sclick:27:{
  if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = on) {
    .writeini Disturbed/settings.ini Prots NullKickProt off
    did -c $dname 26
    did -b $dname 33
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = off) {
    .writeini Disturbed/settings.ini Prots NullKickProt on
    did -u $dname 26
    did -e $dname 33 
    halt
  }
}
on *:dialog:settings:sclick:29:{
  if ($readini(Disturbed/settings.ini,Prots,NullProt) = on) {
    .writeini Disturbed/settings.ini Prots NullProt off
    .did -b $dname 26,27,30,33
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,NullProt) = off) {
    .writeini Disturbed/settings.ini Prots NullProt on
    .did -e $dname 26,27,30
    if ($readini(Disturbed/settings.ini,Prots,NullKickProt) = on) { did -e $dname 33 }
    halt
  }
}
on *:dialog:settings:sclick:30:{
  if ($readini(Disturbed/settings.ini,Prots,NullHopProt) = on) {
    .writeini Disturbed/settings.ini Prots NullHopProt off
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,NullHopProt) = off) {
    .writeini Disturbed/settings.ini Prots NullHopProt on
    halt
  }
}
on *:dialog:settings:sclick:31:{
  if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) = on) {
    .writeini Disturbed/settings.ini Prots DeownerKickProt off
    did -c $dname 39
    did -b $dname 24
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) = off) {
    .writeini Disturbed/settings.ini Prots DeownerKickProt on
    did -u $dname 39
    did -e $dname 24 
    halt
  }
}
on *:dialog:settings:sclick:35:{
  if ($readini(Disturbed/settings.ini,Autos,NullTake) = on) { .writeini Disturbed/settings.ini Autos NullTake off | halt }
  if ($readini(Disturbed/settings.ini,Autos,NullTake) = off) { .writeini Disturbed/settings.ini Autos NullTake on | halt }
}

on *:dialog:settings:sclick:36:{
  if ($readini(Disturbed/settings.ini,Autos,KickTake) = on) { .writeini Disturbed/settings.ini Autos KickTake off | halt }
  if ($readini(Disturbed/settings.ini,Autos,KickTake) = off) { .writeini Disturbed/settings.ini Autos KickTake on | halt }
}
on *:dialog:settings:sclick:37:{
  if ($readini(Disturbed/settings.ini,Autos,CloseTake) = on) { .writeini Disturbed/settings.ini Autos CloseTake off | halt }
  if ($readini(Disturbed/settings.ini,Autos,CloseTake) = off) { .writeini Disturbed/settings.ini Autos CloseTake on | halt }
}
on *:dialog:settings:sclick:39:{
  if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) = on) {
    .writeini Disturbed/settings.ini Prots DeownerKickProt off
    did -u $dname 31
    did -b $dname 24 
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,DeownerKickProt) = off) {
    .writeini Disturbed/settings.ini Prots DeownerKickProt on
    did -c $dname 31
    did -e $dname 24 
    halt
  }
}
on *:dialog:settings:sclick:42:{
  if ($readini(Disturbed/settings.ini,Main,Whispers) = on) { .writeini Disturbed/settings.ini Main Whispers off | halt }
  if ($readini(Disturbed/settings.ini,Main,Whispers) = off) { .writeini Disturbed/settings.ini Main Whispers on | halt }
}
on *:dialog:settings:sclick:45:{
  if ($readini(Disturbed/settings.ini,Main,AutoUpdate) = on) { .writeini Disturbed/settings.ini Main AutoUpdate off | halt }
  if ($readini(Disturbed/settings.ini,Main,AutoUpdate) = off) { .writeini Disturbed/settings.ini Main AutoUpdate on | halt }
}
on *:dialog:settings:sclick:47:{
  if ($readini(Disturbed/settings.ini,Prots,MassKickProt) = on) {
    .writeini Disturbed/settings.ini Prots MassKickProt off
    .did -b $dname 50,52,53,54
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,MassKickProt) = off) {
    .writeini Disturbed/settings.ini Prots MassKickProt on
    .did -e $dname 50,52,53
    if ($readini(Disturbed/settings.ini,Prots,MassKickKickProt) = on) { did -e $dname 54 }
    halt
  }
}
on *:dialog:settings:sclick:52:{
  if ($readini(Disturbed/settings.ini,Prots,MassKickKickProt) = on) {
    .writeini Disturbed/settings.ini Prots MassKickKickProt off
    did -u $dname 53
    did -b $dname 54
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,MassKickKickProt) = off) {
    .writeini Disturbed/settings.ini Prots MassKickKickProt on
    did -c $dname 53
    did -e $dname 54
    halt
  }
}
on *:dialog:settings:sclick:53:{
  if ($readini(Disturbed/settings.ini,Prots,MassKickKickProt) = on) {
    .writeini Disturbed/settings.ini Prots MassKickKickProt off
    did -c $dname 52
    did -b $dname 54
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,MassKickKickProt) = off) {
    .writeini Disturbed/settings.ini Prots MassKickKickProt on
    did -u $dname 52
    did -e $dname 54
    halt
  }
}
on *:dialog:settings:sclick:56:{
  if ($readini(Disturbed/settings.ini,Prots,PassFloodProt) = on) {
    .writeini Disturbed/settings.ini Prots PassFloodProt off
    .did -b $dname 59,61,62,63
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,PassFloodProt) = off) {
    .writeini Disturbed/settings.ini Prots PassFloodProt on
    .did -e $dname 59,61,62,
    if ($readini(Disturbed/settings.ini,Prots,PassFloodKickProt) = on) { did -e $dname 63 }
    halt
  }
}
on *:dialog:settings:sclick:61:{
  if ($readini(Disturbed/settings.ini,Prots,PassFloodKickProt) = on) {
    .writeini Disturbed/settings.ini Prots PassFloodKickProt off
    did -u $dname 62
    did -b $dname 63
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,PassFloodKickProt) = off) {
    .writeini Disturbed/settings.ini Prots PassFloodKickProt on
    did -c $dname 62
    did -e $dname 63
    halt
  }
}
on *:dialog:settings:sclick:62:{
  if ($readini(Disturbed/settings.ini,Prots,PassFloodKickProt) = on) {
    .writeini Disturbed/settings.ini Prots PassFloodKickProt off
    did -c $dname 61
    did -b $dname 63
    halt
  }
  if ($readini(Disturbed/settings.ini,Prots,PassFloodKickProt) = off) {
    .writeini Disturbed/settings.ini Prots PassFloodKickProt on
    did -u $dname 61
    did -e $dname 63
    halt
  }
}
on *:dialog:settings:sclick:68:{
  if ($readini(Disturbed/settings.ini,Custom,VersionKicker) = on) {
    .writeini Disturbed/settings.ini Custom VersionKicker off
    .did -b $dname 70
    halt
  }
  if ($readini(Disturbed/settings.ini,Custom,VersionKicker) = off) {
    .writeini Disturbed/settings.ini Custom VersionKicker on
    .did -e $dname 70
    halt
  }
}
on *:dialog:settings:sclick:74:{
  if ($readini(Disturbed/settings.ini,Custom,TimeKicker) = on) {
    .writeini Disturbed/settings.ini Custom TimeKicker off
    .did -b $dname 76
    halt
  }
  if ($readini(Disturbed/settings.ini,Custom,TimeKicker) = off) {
    .writeini Disturbed/settings.ini Custom TimeKicker on
    .did -e $dname 76
    halt
  }
}
on *:dialog:settings:sclick:81:{
  if ($group(#menubar).status = on) { .disable #menubar | halt }
  else { .enable #menubar | halt }
}
on *:dialog:settings:sclick:82:{
  if ($group(#status).status = on) { .disable #status | halt }
  else { .enable #status | halt }
}
on *:dialog:settings:sclick:83:{
  if ($group(#channel).status = on) { .disable #channel | halt }
  else { .enable #channel | halt }
}
on *:dialog:settings:sclick:84:{
  if ($group(#nicklist).status = on) { .disable #nicklist | halt }
  else { .enable #nicklist | halt }
}
on *:dialog:settings:sclick:86:{
  if ($readini(Disturbed/settings.ini,Guests,Ban) = on) { .writeini Disturbed/Settings.ini Guests Ban off | halt }
  else { .writeini Disturbed/Settings.ini Guests Ban on | halt }
}
on *:dialog:settings:sclick:88:{ sockbotud }
on *:dialog:settings:sclick:89:{ set %sockinfo $did(95) $did(97) }
on *:dialog:settings:sclick:91:{
  if ($readini(Disturbed/Settings.ini,Sockbot,Type) = guest) { .writeini Disturbed/Settings.ini Sockbot Type Passport | halt }
  else { .writeini Disturbed/Settings.ini Sockbot Type guest | halt }
}
on *:dialog:settings:sclick:92:{
  if ($readini(Disturbed/Settings.ini,Sockbot,Type) = guest) { .writeini Disturbed/Settings.ini Sockbot Type Passport | halt }
  else { .writeini Disturbed/Settings.ini Sockbot Type guest | halt }
}
on *:dialog:settings:sclick:101:{ .writeini Disturbed/Settings.ini Sockbot Nick $did(100) }

alias editpassport {
  dialog -m epass epass
  did -ra epass 2 $did(settings,11).seltext
  did -ra epass 4 $readini(Disturbed/passports.ini,$did(settings,11).seltext,password)
}
alias getpassports {
  var %x = 1
  did -r settings 11
  while (%x <= $ini(Disturbed/passports.ini,0)) {
    did -i settings 11 $calc(%x) $ini(Disturbed/passports.ini,%x)
    inc %x
  }
}
alias editpassport {
  dialog -m epass epass
  did -ra epass 2 $did(settings,11).seltext
  did -ra epass 4 $readini(Disturbed/passports.ini,$did(settings,11).seltext,password)
}
dialog epass {
  title "Edit Passport"
  size -1 -1 117 48
  option dbu
  icon Disturbed/Disturbed.ico, 0
  text "Email:", 1, 2 3 15 8
  edit "", 2, 20 2 95 10, autohs
  text "Pass:", 3, 2 15 15 8
  edit "", 4, 20 14 95 10, autohs pass
  button "Cancel", 5, 14 32 37 12, cancel
  button "Ok", 11, 55 32 37 12, ok
}
on *:dialog:epass:sclick:11:{ writeini Disturbed/passports.ini $did(2) password $did(4) | getpassports }
dialog apass {
  title "Add a Passport"
  size -1 -1 117 48
  option dbu
  icon Disturbed/Disturbed.ico, 0
  text "Email:", 1, 2 3 15 8
  edit "", 2, 20 2 95 10, autohs
  text "Pass:", 3, 2 15 15 8
  edit "", 4, 20 14 95 10, autohs pass
  button "Cancel", 5, 14 32 37 12, cancel
  button "Ok", 11, 55 32 37 12, ok
}
on *:dialog:apass:sclick:11:{ writeini Disturbed/passports.ini $did(2) password $did(4) | getpassports }

alias create {
  dialog -md create create
  if ($1) did -ra create 3 $1
}
dialog create {
  title "Create a Room"
  size -1 -1 124 114
  option dbu
  icon Disturbed/Disturbed.ico, 0
  box "", 1, 1 -1 122 94
  text "Room Name:", 2, 5 6 32 8
  edit "%#", 3, 40 5 80 10, autohs
  text "Password:", 4, 5 17 26 8
  edit "Disturbed", 5, 40 16 80 10, autohs
  text "Category:", 6, 5 29 27 8
  combo 7, 40 28 80 66, size drop
  combo 8, 40 41 80 66, size drop
  text "Language:", 9, 5 42 26 8
  text "Room Topic:", 10, 5 54 31 8
  edit "Created.", 11, 40 53 80 10, autohs
  text "Room Limit:", 12, 5 66 30 8
  edit "15000", 13, 40 65 80 10, autohs
  check "Enable Chat Room Profanity Filter", 14, 14 79 95 10
  button "Create", 15, 23 100 37 10, ok
  button "Cancel", 16, 63 100 37 10, cancel
}
on *:dialog:create:init:0: {
  didtok $dname 7 44 CP - Computing,SP - Sports & Recreation,UL - Unlisted,GE - City Chats,EA - Entertainment,EV - Events,GN - General,HE - Health,II - Interests,LF - Lifestyles,MU - Music,NW - News,PR - Peers,RL - Religion,RM - Romance,TN - Teens
  did -c $dname 7 1
  didtok $dname 8 44 English,French,German,Japanese,Swedish,Dutch,Korean,Chinese (Simplified),Portuguese,Finnish,Danish,Russian,Italian,Norwegian,Chinese (Traditional),Spanish,Czech,Greek,Hungarian,Polish,Slovene,Turkish,Slovak,Portuguese (Brazilian)
  did -c $dname 8 1
}
on *:dialog:create:sclick:15: {
  writeini Disturbed/props.ini q $did(3) $did(5)
  hadd disturbed room $did(3)
  if ($did(14).state = 1) var %modes = fl $did(13)
  if ($did(14).state != 1)  var %modes = l $did(13)
  sockwrite -tn finds CREATE $gettok($did(7),1,32) $did(3) $replace($did(11),$chr(32),\b,$chr(44),\c) %modes EN-US 1 $did(5) 0
}

alias chanstats dialog -md chanstats chanstats
dialog chanstats {
  title "Channel Stats"
  size -1 -1 124 184
  option dbu
  list 1, 5 19 114 70, size
  box "", 2, 2 0 120 17
  text "Channel List", 3, 5 6 31 8
  box "", 4, 2 13 120 79
  text "Channel Name:", 5, 3 95 39 8
  edit "", 6, 42 94 80 10, autohs
  text "Channel Users:", 7, 3 106 39 8
  edit "", 8, 42 105 80 10, autohs
  text "Channel Modes:", 9, 3 117 39 8
  edit "", 10, 42 116 80 10, autohs
  text "Channel Topic:", 11, 3 128 37 8
  text "Onjoin Msg:", 12, 3 139 30 8
  text "Onpart Msg:", 13, 3 150 30 8
  edit "", 14, 42 127 80 10, autohs
  edit "", 15, 42 138 80 10, autohs
  edit "", 16, 42 149 80 10, autohs
  box "", 17, 2 161 120 4
  button "Close", 18, 45 169 37 12, ok
}

on *:dialog:chanstats:init:0: {
  if ($chan(0) = 0) { $input(You are currently not in any channels.,o,Error) | dialog -x $dname $dname | halt }
  var %x 0
  while (%x < $chan(0)) {
    inc %x
    if ($chan(0) != 0) { did -a $dname 1 $chan(%x) | halt }
  }
}
on *:dialog:chanstats:sclick:1: {
  .var %a = $did($dname,1).seltext
  did -a $dname 6 %a
  did -a $dname 8 $nick(%a,0)
  did -a $dname 10 $chan(%a).mode
  did -a $dname 14 $chan(%a).topic
  did -a $dname 15 $iif($readini(disturbed/props.ini,onjoin,%a),$readini(disturbed/props.ini,onjoin,%a),Unknown)
  did -a $dname 16 $iif($readini(disturbed/props.ini,onpart,%a),$readini(disturbed/props.ini,onpart,%a),Unknown)
  did -c $dname 6
}

;;; End of Dialogs

;;; Menu's

menu status,nicklist,menubar,channel {
  -
  Disturbed Connection
  .$iif($server != $null,$style(2)) Connect: disturbed
  .$iif($server = $null,$style(2)) Disonnect: dc
  .-
  .$iif($readini(Disturbed/settings.ini,Main,ConnectOnStart) = on,$style(1)) Connect on Start: {
    if ($readini(Disturbed/settings.ini,Main,ConnectOnStart) = on) { .writeini Disturbed/settings.ini Main ConnectOnStart off | halt }
    if ($readini(Disturbed/settings.ini,Main,ConnectOnStart) = off) { .writeini Disturbed/settings.ini Main ConnectOnStart on | halt }
  }
  .-
  .$iif($readini(Disturbed/settings.ini,Main,AutoQ) = on,$style(1)) Auto Owner Up on Join: {
    if ($readini(Disturbed/settings.ini,Main,AutoQ) = on) { .writeini Disturbed/settings.ini Main AutoQ off | halt }
    if ($readini(Disturbed/settings.ini,Main,AutoQ) = off) { .writeini Disturbed/settings.ini Main AutoQ on | halt }
  }
  .-
  .Room Options
  ..Join a Room: msn $$?="Enter Room Name:"
  ..-
  ..Join Previous Room 
  ... $+ %recent1: msn %recent1
  ... $+ %recent2: msn %recent2
  ... $+ %recent3: msn %recent3
  ... $+ %recent4: msn %recent4
  ... $+ %recent5: msn %recent5
  ... $+ %recent6: msn %recent6
  ... $+ %recent7: msn %recent7
  ... $+ %recent8: msn %recent8
  ... $+ %recent9: msn %recent9
  ... $+ %recent10: msn %recent10
  ..-
  ..Create a Room: create
  ..-
  ..Check Room Status: set %findroom on | m $?="Enter Room Name:"
  .-
  .Passport Stuff
  ..$iif(%email = $null,$style(2)) Current Passport $+ $chr(58) $iif(%email,%email,No Passport. Add a Passport.) : halt
  ..-
  ..Update Current Passport: ud
  ..-
  ..$iif($readini(Disturbed/settings.ini,Main,Rgk) = on,$style(1)) Random Gatekeeper:{
    if ($readini(Disturbed/settings.ini,Main,Rgk) = on) { .writeini Disturbed/settings.ini Main Rgk off | halt }
    if ($readini(Disturbed/settings.ini,Main,Rgk) = off) { .writeini Disturbed/settings.ini Main Rgk on | halt }
  }
  .-
  .Change Nick: nick $$?="Enter Nick Name:"
  .-
  .Webchat Dialog: webchat
  .-
  .Connection Configuration: settings
  -
}
;;; Passport Updater

alias ud {
  if (!$var(%email)) { $input(Please add a passport to the Passport Tab in the settings dialog.,o,Error) | settings | halt }
  window -h @update
  $nHTMLn attach $window(@update).hwnd
  $nHTMLn handler updater.handler
  $nHTMLn navigate https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d24seven&login= $+ $replace(%email,@,$chr(37) $+ 40) $+ &passwd= $+ $replace(%pass,@,$chr(37) $+ 40)
}
alias updater.handler {
  if (document_complete = $2) && ($gettok($gettok($3,3,$asc(/)),1,46) = uicookiesdisabled) { $nHTMLn navigate http://login.passport.com/login.srf }
  if (navigate_begin = $2) {
    if (did = $gettok($gettok($3,2,63),1,61)) {
      set %ticket $left($gettok($3,3,61),-2)
      set %profile $left($gettok($3,4,61),-3)
      echo -a * Passport Updated %email Successfully.
      $nHTMLn navigate http://login.passport.com/logout.srf?id=486
    }
    if ($gettok($gettok($3,3,$asc(/)),1,46) = uilogin) { $nHTMLn navigate https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d24seven&login= $+ $replace(%email,$chr(64),$+($chr(37),40)) $+ &passwd= $+ %pass }
    if ($gettok($gettok($3,14,61),1,38) = ec) { echo -a * Error in updating: E-Mail and/or Password May Be Wrong. | return S_CANCEL }
  }
  return S_OK
}

;;; end of updater

;;; For you Webchatters =]

alias webchat dialog -md webchat webchat
dialog webchat {
  title "Webchat via mIRC"
  size -1 -1 145 95
  option dbu
  icon Disturbed/Disturbed.ico, 0
  box "", 1, 2 -1 141 45
  text "Email:", 2, 6 5 16 8
  edit "", 3, 35 4 105 10, autohs
  text "Password:", 4, 6 17 27 8
  edit "", 5, 35 16 105 10, pass autohs
  check "Remeber Passport Information", 6, 6 29 86 10
  box "", 7, 2 40 141 32
  text "Room Name:", 8, 6 46 32 8
  edit "", 9, 40 45 100 10
  radio "Use Passport", 10, 14 59 43 10
  radio "Use Guest Form", 11, 65 59 50 10
  button "Join", 12, 30 80 37 10, ok
  button "Cancel", 13, 72 80 37 10, cancel
}
on *:dialog:webchat:init:0: {
  if ($var(%webchatinfo)) { did -c $dname 6,10 | did -ra $dname 3 $gettok(%webchatinfo,1,32)  | did -ra $dname 5 $gettok(%webchatinfo,2,32) | halt }
  did -c $dname 11
}
on *:dialog:webchat:sclick:6: {
  if ($var(%webchatinfo)) { unset %webchatinfo | halt }
  if (!$var(%webchatinfo)) { set %webchatinfo $did(3) $did(5) }
}
on *:dialog:webchat:sclick:12: {
  set %webchatroom $did(9)
  if ($did(10).state = 1) {
    window @Webchat
    $nHTMLn attach $window(@Webchat).hwnd
    $nHTMLn handler web.handler
    $nHTMLn navigate https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d $+ $replace(%webchatroom,$chr(32),%20) $+ &login= $+ $replace($did(3),@,$chr(37) $+ 40) $+ &passwd= $+ $replace($did(5),@,$chr(37) $+ 40)
  }
  if ($did(11).state = 1) { var %a = $?="Type In Your Guest Nick:" | webchatguest %webchatroom %a }
}
alias web.handler {
  if (document_complete = $2) && ($gettok($gettok($3,3,$asc(/)),1,46) = uicookiesdisabled) { $nHTMLn navigate http://login.passport.com/login.srf }
  if (navigate_begin = $2) {
    if (did = $gettok($gettok($3,2,63),1,61)) {
      $nHTMLn navigate http://chat.msn.com/chatroom.msnw?rm= $+ $replace(%webchatroom,\b,+,$chr(37),,$chr(35),,%20,$chr(31))
    }
    if ($gettok($gettok($3,3,$asc(/)),1,46) = uilogin) { $nHTMLn navigate https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d $+ $replace(%webchatroom,$chr(32),%20) $+ &login= $+ $replace($gettok(%webchatinfo,1,32),$chr(64),$+($chr(37),40)) $+ &passwd= $+ $gettok(%webchatinfo,2,32) }
    if ($gettok($gettok($3,14,61),1,38) = ec) { $input(Sorry but your email and or password may be wrong.,o,Error.) | $nHTMLn navigate http://chat.msn.com/ }
  }
  return S_OK
}
alias webchatguest {
  window @Webchat
  $nHTMLn attach $window(@Webchat).hwnd
  $nHTMLn navigate about: $+ $guest($1,$2)
}
alias guest {
  return $&
    <OBJECT ID="ChatFrame" CLASSID="CLSID:F58E1CEF-A068-4c15-BA5E-587CAF3EE8C6" width="100%"  CODEBASE="http://fdl.msn.com/public/chat/msnchat45.cab#Version=9,00,0305,1401"> $&
    <PARAM NAME="RoomName" VALUE=" $+ %webchatroom $+ "> $&
    <PARAM NAME="NickName" VALUE=" $+ $2 $+ "> $&
    <PARAM NAME="Server" VALUE="207.68.167.253:6667"> $&
    <PARAM NAME="BaseURL" VALUE="http://chat.msn.com/"> $&
    </OBJECT>
}

;;; end of webchat


;--------------------------------------------------
; Disturbed v2.0 Connection Sockbot
;
; Here's a little treat =]
; My Sockbot
; Orginally Cypher's, Heavily Updated By zBrute
;--------------------------------------------------

alias sockbot {
  if ($sock(sock $+ $hget(sock,#))) { sockwrite -tn sock $+ $hget(sock,#) join # | halt }
  if (!$hget(sock)) { hmake sock 100 }
  hadd sock room #
  hadd sock # $hget(Disturbed,#)
  var %ip = $hget(Disturbed,ip $+ #)
  sockopen sock $+ $hget(sock,#) %ip $right($ip.port,-15)
  sockmark sock $+ $hget(sock,#) #
  hadd sock port $+ $hget(sock,#) $r(1300,8000)
  window -h @sockcontrol $+ $hget(sock,#)
  $nHTMLn attach $window(@sockcontrol $+ $hget(sock,#)).hwnd
  $nHTMLn navigate about:<OBJECT ID="ChatFrame" CLASSID="CLSID: $+ $clsid $+ "><PARAM NAME="RoomName" VALUE="Sockbot"><PARAM NAME="NickName" VALUE="Sockbot"><PARAM NAME="Server" VALUE=" $+ %ip $+ : $+ $hget(sock,port $+ $hget(sock,#)) $+ "></OBJECT>
  socklisten startsock $+ $hget(sock,#) $hget(sock,port $+ $hget(sock,#))
}
on 1:socklisten:startsock*:{ sockaccept authsock* | sockclose $sockname }
on 1:sockopen:sock*:{ sockwrite -tn $sockname $+(NICK $sock.(nick),$lf,IRCVERS IRC7 MSN-OCX!8.00.0211.1802) }
on 1:sockread:sock*: {
  .sockread %d
  if ($gettok(%d,4,32) = ownerkey) { hadd -m q $gettok(%d,3,32) $gettok(%d,5,32) }
  if ($gettok(%d,4-5,32) = -q $sock.(nick)) { .sockwrite -tn $sockname $+($gettok(%d,2,32) $gettok(%d,5,32) +h $hget(q,$gettok(%d,3,32)),$lf,$gettok(%d,2-4,32) $right($gettok(%d,1,33),-1),$lf,prop $gettok(%d,3,32) ownerkey $propkey,$lf,prop $gettok(%d,3,32) hostkey $propkey,$lf,access $gettok(%d,3,32) clear) }
  if ($gettok(%d,2-4,32) = kick $gettok(%d,3,32) $sock.(nick)) { .sockwrite -tn $sockname $+(join $gettok(%d,3,32) $hget(q,$gettok(%d,3,32)),$lf,$gettok(%d,2-3,32) $right($gettok(%d,1,33),-1) :Revenge.,$lf,prop $gettok(%d,3,32) ownerkey $propkey,$lf,prop $gettok(%d,3,32) hostkey $propkey,$lf,access $gettok(%d,3,32) clear) }
  if ($gettok(%d,2,32) = JOIN) {
    var %blah = $gettok(%d,4,32)
    if  ($scid($cid).me isop $right(%blah,-1)) {
      sockwrite -tn disturbed $+ $hget(disturbed,$right(%blah,-1)) mode $right(%blah,-1) $iif($scid($cid).me isowner $right(%blah,-1),+q,+o) $sock.(nick)
    }
    else { sockwrite -tn $sockname mode $right(%blah,-1) +h $sock.(nick) $hget(q,$right(%blah,-1))
    }
  }
  if (AUTH *@GateKeeper 0 iswm %d) && ($sock.(type) = guest) {
    if ($left($sock.(nick),1) != >) { .writeini Disturbed/Settings.ini Sockbot Nick > $+ $sock.(nick) }
    sockwrite -tn $sockname Nick $sock.(nick)
  }
  if ($gettok(%d,1,32) = AUTH) && ($gettok(%d,4,32) != :ok) { sockwrite -tn authsock* %d }
  if ($gettok(%d,1,32) = AUTH) && ($gettok(%d,4,32) = :ok) { 
    if ($left($sock.(nick),1) = >) { .writeini Disturbed/Settings.ini Sockbot Nick $remove($sock.(nick),>) }
    sockwrite -tn $sockname $+(AUTH GateKeeperPassport S : $+ $sock.(passform),$lf,USER Sockbot Sockbot SockBot : $+ Disturbed v2.0 Sockbot)
  }
  if ($gettok(%d,2,32) = 002) { .sockwrite -tn $sockname join $hget(sock,room) | sockclose authsock* | close -@ @sockcontrol* }
  if ($gettok(%d,1,32) = Ping) { sockwrite -tn $sockname Pong }
}
on 1:sockread:authsock*: {
  .sockread %d
  if ($sock.(type)  = passport) { %d = $replace(%d,gatekeeper,GateKeeperPassport) } 
  if ($gettok(%d,1,32) = IRCVERS) || ($gettok(%d,1,32) = AUTH) { sc sock* %d }
}
alias sock. {
  if ($1 = nick) { return $readini(Disturbed/Settings.ini,Sockbot,Nick) }
  if ($1 = type) { return $readini(Disturbed/Settings.ini,Sockbot,Type) }
  if ($1 = passform) { return $base($len(%sockticket),10,16,8) $+ %sockticket $+ $base($len(%sockprofile),10,16,8) $+ %sockprofile }
}

;;; Sockbot Passport Updater

alias sockbotud {
  if (!$var(%sockinfo)) { 
    set %sockemail $?="Please Enter An Email Address:"
    set %sockpass $?="Please Enter Email Password:"
    set %sockinfo %sockemail %sockpass
    unset %sockemail
    unset %sockpass 
    sockbotud
  }
  window -h @sockbotupdater
  $nHTMLn attach $window(@sockbotupdater).hwnd
  $nHTMLn handler sockbotupdater.handler
  $nHTMLn navigate https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d24seven&login= $+ $replace($gettok(%sockinfo,1,32),@,$chr(37) $+ 40) $+ &passwd= $+ $replace($gettok(%sockinfo,2,32),@,$chr(37) $+ 40)
}
alias sockbotupdater.handler {
  if (document_complete = $2) && ($gettok($gettok($3,3,$asc(/)),1,46) = uicookiesdisabled) { $nHTMLn navigate http://login.passport.com/login.srf }
  if (navigate_begin = $2) {
    if (did = $gettok($gettok($3,2,63),1,61)) {
      set %sockticket $left($gettok($3,3,61),-2)
      set %sockprofile $left($gettok($3,4,61),-3)
      echo -a * Passport Updated $gettok(%sockinfo,1,32) Successfully for the Sockbot.
      $nHTMLn navigate http://login.passport.com/logout.srf?id=486
    }
    if ($gettok($gettok($3,3,$asc(/)),1,46) = uilogin) { $nHTMLn navigate https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/chatroom.msnw%3frm%3d24seven&login= $+ $replace($gettok(%sockinfo,1,32),$chr(64),$+($chr(37),40)) $+ &passwd= $+ $gettok(%sockinfo,2,32) }
    if ($gettok($gettok($3,14,61),1,38) = ec) { echo -a * Error in updating: E-Mail and/or Password May Be Wrong. | return S_CANCEL }
  }
  return S_OK
}

;;; end of updater


;;; End of Sockbot

;--------------------------------------------------
; End of Connection.
;--------------------------------------------------
