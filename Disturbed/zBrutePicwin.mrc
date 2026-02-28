; Blade Movie
; by zBrute
; ©2004


alias blade.movie {
  var %w $window(-1).w, %h $window(-1).h
  window -adohpkB +d @movie 0 0 %w %h
  drawrect -fr @movie 0 0 0 0 %w %h
  drawrect -fr @movie 0 0 0 0 %w %h
  drawtext -r @movie 16777215 Tahoma 22 100 20 A film by zBrute
  drawtext -r @movie 16777215 Tahoma 22 150 80 About an uber elite hacker
  drawtext -r @movie 16777215 Tahoma 22 200 140 Known As...
  gTimer -m 200 drawtext -r @movie 16777215 Tahoma 100 120 400 BLADE aka Billy!
  gTimer -m 400 drawrect -fr @movie 0 0 100 400 900 500
  gTimer -m 600 drawtext -r @movie 16777215 Tahoma 100 120 400 BLADE aka Billy!
  gTimer -m 800 drawrect -fr @movie 0 0 100 400 900 500
  gTimer -m 1000 drawtext -r @movie 16777215 Tahoma 100 120 400 BLADE aka Billy!
  gTimer -m 1200 drawrect -fr @movie 0 0 100 400 900 500
  gTimer -m 1400 drawtext -r @movie 16777215 Tahoma 100 120 400 BLADE aka Billy!
  gTimer -m 1600 drawrect -fr @movie 0 0 100 400 900 500
  gTimer -m 1800 drawtext -r @movie 16777215 Tahoma 100 120 400 BLADE aka Billy!
  gTimer 3 drawrect -fr @movie 0 0 0 0 %w %h
  gTimer 5 drawtext -r @movie 16777215 Tahoma 30 100 100 One day I got bored and decided to hack Blade.
  gTimer 7 drawtext -r @movie 16777215 Tahoma 30 100 180 Here is a replica of what I saw on his screen.
  gTimer 9 drawtext -r @movie 16777215 Tahoma 30 100 260 Have fun watching this....
  gTimer 11 drawrect -fr @movie 0 0 0 0 %w %h
  gTimer 12 drawScreen
}

alias gTimer {
  if ($1 == -m) { .timer $1 1 $2 $3- }
  else { .timer 1 $1 $2- }
}

menu @movie {
  -
  Close: window -c @movie
  -
}

alias clearScreen { drawrect -fr @movie 16777215 16777215 50 85 749 469 }
alias clearNicklist { drawrect -fr @movie 16777215 16777215 809 85 85 500 }
alias clearEditbox { drawrect -fr @movie 16777215 16777215 60 559 500 26 }

alias drawScreen {
  var %chan = !test
  drawrect -fr @movie 16750848 16750848 50 50 900 30
  drawrect -fr @movie 16777215 16777215 50 85 900 500
  drawline -r @movie 0 2 800 85 800 585
  drawline -r @movie 0 2 48 555 800 555
  drawtext -r @movie 10247424 Tahoma 20 60 52 mIRC - [%#!test [5] [+ntl 31337]: Blade is gay.
  drawtext -r @movie 8421504 Tahoma 16 60 490 * Now talking in %chan
  drawtext -r @movie 8421504 Tahoma 16 60 510 * Blade sets mode: +q Blade
  drawtext -r @movie 8421504 Tahoma 16 60 530 * Topic is 'Blade is gay.'
  drawtext -r @movie 8421504 Tahoma 16 810 90 .Blade
  drawtext -r @movie 8421504 Tahoma 16 810 110 .Game
  drawtext -r @movie 8421504 Tahoma 16 810 130 .Toyz
  drawtext -r @movie 8421504 Tahoma 16 810 150 .Tyrant
  drawtext -r @movie 8421504 Tahoma 16 810 170 .x-c0n
  gTimer 1 clearscreen
  gTimer -m 1001 drawtext -r @movie 8421504 Tahoma 16 60 470 * Now talking in %chan
  gTimer -m 1002 drawtext -r @movie 8421504 Tahoma 16 60 490 * Blade sets mode: +q Blade
  gTimer -m 1003 drawtext -r @movie 8421504 Tahoma 16 60 510 * Topic is 'Blade is gay.'
  gTimer -m 1004 drawtext -r @movie 8421504 Tahoma 16 60 530 * Troy has joined the conversation.
  gTimer -m 1001 clearNicklist
  gTimer -m 1010 drawtext -r @movie 8421504 Tahoma 16 810 90 .Blade
  gTimer -m 1010 drawtext -r @movie 8421504 Tahoma 16 810 110 .Game
  gTimer -m 1010 drawtext -r @movie 8421504 Tahoma 16 810 130 .Toyz
  gTimer -m 1010 drawtext -r @movie 8421504 Tahoma 16 810 150 .Tyrant
  gTimer -m 1010 drawtext -r @movie 8421504 Tahoma 16 810 170 .x-c0n
  gTimer -m 1010 drawtext -r @movie 8421504 Tahoma 16 810 190 Troy
  gTimer -m 1001 drawrect -fr @movie 16750848 16750848 50 50 900 30
  gTimer -m 1010 drawtext -r @movie 10247424 Tahoma 20 60 52 mIRC - [%#!test [6] [+ntl 31337]: Blade is gay.
  gTimer -m 1500 drawtext -r @movie 8421504 Tahoma 16 60 559 t
  gTimer -m 1800 drawtext -r @movie 8421504 Tahoma 16 68 559 h
  gTimer -m 2100 drawtext -r @movie 8421504 Tahoma 16 78 559 e
  gTimer -m 2400 drawtext -r @movie 8421504 Tahoma 16 92 559 p
  gTimer -m 2700 drawtext -r @movie 8421504 Tahoma 16 102 559 r
  gTimer -m 3000 drawtext -r @movie 8421504 Tahoma 16 109 559 o
  gTimer -m 3300 drawtext -r @movie 8421504 Tahoma 16 118 559 t
  gTimer -m 3600 drawtext -r @movie 8421504 Tahoma 16 130 559 l
  gTimer -m 3900 drawtext -r @movie 8421504 Tahoma 16 134 559 u
  gTimer -m 4200 drawtext -r @movie 8421504 Tahoma 16 145 559 k
  gTimer -m 4500 drawtext -r @movie 8421504 Tahoma 16 153 559 e
  gTimer -m 4800 drawtext -r @movie 8421504 Tahoma 16 164 559 m
  gTimer 5 clearEditbox
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 60 559 t
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 68 559 h
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 78 559 e
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 92 559 p
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 102 559 r
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 109 559 o
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 118 559 t
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 130 559 l
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 134 559 u
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 145 559 k
  gTimer -m 5010 drawtext -r @movie 8421504 Tahoma 16 153 559 e
  gTimer -m 5300 clearEditbox
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 60 559 t
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 68 559 h
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 78 559 e
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 92 559 p
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 102 559 r
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 109 559 o
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 118 559 t
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 130 559 l
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 134 559 u
  gTimer -m 5310 drawtext -r @movie 8421504 Tahoma 16 145 559 k
  gTimer -m 5600 clearEditbox
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 60 559 t
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 68 559 h
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 78 559 e
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 92 559 p
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 102 559 r
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 109 559 o
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 118 559 t
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 130 559 l
  gTimer -m 5610 drawtext -r @movie 8421504 Tahoma 16 134 559 u
  gTimer -m 5900 clearEditbox
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 60 559 t
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 68 559 h
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 78 559 e
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 92 559 p
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 102 559 r
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 109 559 o
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 118 559 t
  gTimer -m 5910 drawtext -r @movie 8421504 Tahoma 16 130 559 l
  gTimer -m 6200 clearEditbox
  gTimer -m 6210 drawtext -r @movie 8421504 Tahoma 16 60 559 t
  gTimer -m 6210 drawtext -r @movie 8421504 Tahoma 16 68 559 h
  gTimer -m 6210 drawtext -r @movie 8421504 Tahoma 16 78 559 e
  gTimer -m 6210 drawtext -r @movie 8421504 Tahoma 16 92 559 p
  gTimer -m 6210 drawtext -r @movie 8421504 Tahoma 16 102 559 r
  gTimer -m 6210 drawtext -r @movie 8421504 Tahoma 16 109 559 o
  gTimer -m 6210 drawtext -r @movie 8421504 Tahoma 16 118 559 t
  gTimer -m 6500 drawtext -r @movie 8421504 Tahoma 16 130 559 i
  gTimer -m 6800 drawtext -r @movie 8421504 Tahoma 16 140 559 m
  gTimer -m 7400 drawtext -r @movie 8421504 Tahoma 16 154 559 a
  gTimer -m 7700 drawtext -r @movie 8421504 Tahoma 16 163 559 d
  gTimer -m 8000 drawtext -r @movie 8421504 Tahoma 16 173 559 e
  gTimer -m 8300 drawtext -r @movie 8421504 Tahoma 16 186 559 d
  gTimer -m 8600 drawtext -r @movie 8421504 Tahoma 16 196 559 o
  gTimer -m 8900 drawtext -r @movie 8421504 Tahoma 16 206 559 n
  gTimer -m 9200 drawtext -r @movie 8421504 Tahoma 16 215 559 '
  gTimer -m 9500 drawtext -r @movie 8421504 Tahoma 16 221 559 t
  gTimer -m 9800 drawtext -r @movie 8421504 Tahoma 16 235 559 e
  gTimer -m 10100 drawtext -r @movie 8421504 Tahoma 16 245 559 v
  gTimer -m 10400 drawtext -r @movie 8421504 Tahoma 16 255 559 e
  gTimer -m 10700 drawtext -r @movie 8421504 Tahoma 16 265 559 n
  gTimer -m 11000 drawtext -r @movie 8421504 Tahoma 16 285 559 w
  gTimer -m 11300 drawtext -r @movie 8421504 Tahoma 16 299 559 o
  gTimer -m 11700 drawtext -r @movie 8421504 Tahoma 16 310 559 r
  gTimer -m 12000 drawtext -r @movie 8421504 Tahoma 16 319 559 k
  gTimer -m 12200 clearEditbox
  gTimer -m 12200 clearscreen
  gTimer -m 12210 drawtext -r @movie 8421504 Tahoma 16 60 450 * Now talking in %chan
  gTimer -m 12211 drawtext -r @movie 8421504 Tahoma 16 60 470 * Blade sets mode: +q Blade
  gTimer -m 12212 drawtext -r @movie 8421504 Tahoma 16 60 490 * Topic is 'Blade is gay.'
  gTimer -m 12213 drawtext -r @movie 8421504 Tahoma 16 60 510 * Troy has joined the conversation.
  gTimer -m 12214 drawtext -r @movie 8421504 Tahoma 16 60 530 <Blade> the prot i made don't even work
  gTimer -m 13000 drawTake
}

alias drawTake {
  gTimer -m 1500 drawtext -r @movie 8421504 Tahoma 16 60 559 /
  gTimer -m 1800 drawtext -r @movie 8421504 Tahoma 16 68 559 n
  gTimer -m 2100 drawtext -r @movie 8421504 Tahoma 16 78 559 u
  gTimer -m 2400 drawtext -r @movie 8421504 Tahoma 16 89 559 l
  gTimer -m 2700 drawtext -r @movie 8421504 Tahoma 16 94 559 l
  gTimer -m 3000 clearEditbox
  gTimer -m 3000 clearscreen
  gTimer -m 3010 drawtext -r @movie 8421504 Tahoma 16 60 310 * Now talking in !test
  gTimer -m 3020 drawtext -r @movie 8421504 Tahoma 16 60 330 * Blade sets mode: +q Blade
  gTimer -m 3030 drawtext -r @movie 8421504 Tahoma 16 60 350 * Topic is 'Blade is gay.'
  gTimer -m 3040 drawtext -r @movie 8421504 Tahoma 16 60 370 * Troy has joined the conversation.
  gTimer -m 3050 drawtext -r @movie 8421504 Tahoma 16 60 390 <Blade> the prot i made don't even work
  gTimer -m 3060 drawtext -r @movie 8421504 Tahoma 16 60 410 * Blade PROP OWNERKEY :
  gTimer -m 3070 drawtext -r @movie 8421504 Tahoma 16 60 430 * Blade sets mode: -q Game
  gTimer -m 3080 drawtext -r @movie 8421504 Tahoma 16 60 450 * Blade sets mode: -q Toyz
  gTimer -m 3090 drawtext -r @movie 8421504 Tahoma 16 60 470 * Blade sets mode: -q Tyrant
  gTimer -m 3100 drawtext -r @movie 8421504 Tahoma 16 60 490 * Tyrant sets mode: +q Tyrant
  gTimer -m 3110 drawtext -r @movie 8421504 Tahoma 16 60 510 * Blade sets mode: -q x-c0n
  gTimer -m 3120 drawtext -r @movie 8421504 Tahoma 16 60 530 * Blade was kicked by Tyrant (Lame-Nuller :: Banned)
  gTimer -m 3130 clearNicklist
  gTimer -m 3140 drawtext -r @movie 8421504 Tahoma 16 810 90 .Tyrant
  gTimer -m 3150 drawtext -r @movie 8421504 Tahoma 16 810 110 Game
  gTimer -m 3160 drawtext -r @movie 8421504 Tahoma 16 810 130 Toyz
  gTimer -m 3170 drawtext -r @movie 8421504 Tahoma 16 810 150 Troy
  gTimer -m 3180 drawtext -r @movie 8421504 Tahoma 16 810 170 x-c0n
  gTimer 5 splay stop
  gTimer 5 drawMsgLuke
}

alias drawMsgLuke {
  var %w $window(-1).w, %h $window(-1).h
  signIn Luke has just signed in.
  gTimer 2 drawrect -fr @movie 0 0 0 0 %w %h
  gTimer 3 drawrect -fr @movie 16750848 16750848 275 50 450 30
  gTimer -m 3100 drawrect -fr @movie 16777215 16777215 275 85 450 500
  gTimer -m 3110 drawtext -r @movie 10247424 Tahoma 20 285 52 Luke - (My Idol)
  gTimer -m 3120 drawrect -r @movie 0 1 285 100 430 400
  gTimer -m 3130 drawrect -r @movie 0 1 285 510 430 66
  gTimer -m 3140 drawrect -r @movie 0 1 656 518 50 50
  gTimer -m 3150 drawtext -r @movie 8421504 Tahoma 16 664 533 Send
  gTimer 4 drawtext -r @movie 8421504 Tahoma 16 292 105 Blade says:
  gTimer 4 drawtext -r @movie 8421504 Tahoma 16 300 125 Luke, can you fix my prot?
  gTimer 6 drawtext -r @movie 8421504 Tahoma 16 292 145 Blade says:
  gTimer 6 drawtext -r @movie 8421504 Tahoma 16 300 165 the one you made so it kicks
  gTimer 6 drawtext -r @movie 8421504 Tahoma 16 300 185 troy when he joins?
  gTimer 10 drawtext -r @movie 8421504 Tahoma 16 292 205 Luke says:
  gTimer 10 drawtext -r @movie 8421504 Tahoma 16 300 225 no, go away before I get chris
  gTimer 10 drawtext -r @movie 8421504 Tahoma 16 300 245 to hack your ass!
  gTimer 14 drawtext -r @movie 8421504 Tahoma 16 292 265 Blade says:
  gTimer 14 drawtext -r @movie 8421504 Tahoma 16 300 285 he can't do shit, ill sit here
  gTimer 14 drawtext -r @movie 8421504 Tahoma 16 300 305 here and sip my water.
  gTimer 16 drawtext -r @movie 8421504 Tahoma 16 292 325 Blade says:
  gTimer 16 drawtext -r @movie 8421504 Tahoma 16 300 345 i mean vodka *
  gTimer 19 drawtext -r @movie 8421504 Tahoma 16 292 365 Luke says:
  gTimer 19 drawtext -r @movie 8421504 Tahoma 16 300 385 we'll see about that
  gTimer 22 drawHackz0r
}

alias drawHackz0r {
  var %w $window(-1).w, %h $window(-1).h
  gTimer 2 drawrect -fr @movie 0 0 0 0 %w %h
  gTimer 3 drawrect -fr @movie 16750848 16750848 235 200 490 30
  gTimer -m 3100 drawtext -r @movie 10247424 Tahoma 20 245 202 Command Prompt
  gTimer -m 3110 drawrect -fr @movie 16777215 16777215 235 235 490 260
  gTimer 4 drawtext -r @movie 8421504 Tahoma 16 245 245 Microsoft Windows XP [Version 5.1.2600]
  gTimer 4 drawtext -r @movie 8421504 Tahoma 16 245 265 (C) Copyright 1985-2001 Microsoft Corp.
  gTimer 4 drawtext -r @movie 8421504 Tahoma 16 245 305 C:\>
  gTimer 5 drawtext -r @movie 8421504 Tahoma 16 245 345 Deleting C:\Windows ....
  gTimer 6 drawtext -r @movie 8421504 Tahoma 16 245 385 Hi Blade.
  gTimer 6 drawtext -r @movie 8421504 Tahoma 16 245 425 ~ Tyrant
  gTimer 6 drawtext -r @movie 8421504 Tahoma 16 245 465 P.S. - Rawand's video ownz yourz.
  gTimer 9 drawrect -fr @movie 0 0 0 0 %w %h
  gTimer 9 drawtext -r @movie 16777215 Tahoma 120 300 300 PWNED!!!
  gTimer 9 drawtext -r @movie 16777215 Tahoma 16 310 480 Credit to Rawand for the concept and thanks for the song!
  gTimer 13 window -c @movie
}

alias drawIt {
  var %win = $1, %x = $2, %y = $3, %w = $4, %h = $5, %tx = $6, %ty = $7, %font = $8, %size = $9, %text = $10-
  drawrect -r %win 0 2 %x %y %w %h
  drawrect -r %win $rgb(255,255,255) 1 $calc(%x + 1) $calc(%y + 1) $calc(%w - 2) $calc(%h - 2)
  drawrect -r %win $rgb(151,151,151) 1 $calc(%x + 2) $calc(%y + 2) $calc(%w - 3) $calc(%h - 3)
  drawrect -rf %win 16750848 1 $calc(%x + 2) $calc(%y + 2) $calc(%w - 4) $calc(%h - 4)
  drawtext -r %win 0 %font %size %tx %ty %text
}

alias signIn {
  var %var = @Luke 0 16777215 Tahoma 11 15 40 $1-
  tokenize 32 %var
  window -haodpkB +dnL $1 $calc($window(-1).w - 150) $calc($window(-1).h - 80) 150 80
  drawrect -rf $1 $3 0 0 0 500 500
  drawrect -r $1 $2 1 0 0 150 80
  drawIt $1 0 0 150 22 8 4 $4 12 M$N M3sseng3r
  drawtext -r $deltok($1-,3,32)
  .timer 1 2 window -c $1
}
