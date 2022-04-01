       >>SOURCE FORMAT IS FREE
*>******************************************************
*> star_trek simulates an outer space adventure game   *
*> on a remote terminal.  The user commands the U.S.S. *
*> Enterprise, and thru various offensive and defen-   *
*> sive commands, travels throughout the galaxy on a   *
*> mission to destroy all Klingons, which also maneu-  *
*> ver and fire on the Enterprise.                     *
*>******************************************************
identification division.
program-id. star_trek.
*>author.  Kurt Wilhelm.
*>installation.  Oakland University.
*>date-written.  Completed September 1, 1979.
*>
*> Tectonics:
*>   cobc -free -x star_trek.cob -t star_trek.lst -cb_conf=perform-osvs:yes
*>******************************************************
*> Harald Arnesen <harald@skogtun.org>, 2010-03-24:
*>
*> Ported to OpenCobol 1.1 by changing the comments
*> to free format, as some lines are too long for fixed format.
*>
*> I haven't played it, just checked that it compiles and runs!
*>
*> Original source:
*> <http://www.dunnington.u-net.com/public/startrek/ctrek.cob>
*>
*> Brian Tiffin <btiffin@users.sf.net>, 2010-03-24:
*> btiffin updates, it actually works now, when compiled with
*>  perform-osvs:yes  This allows thru with overlapping exits
*>
*> Michael F. Gleason March 2022
*> Converted to free format. Fixed a few bugs as noted with ??? marks.
*> Changed code to eliminate the <thru with overlapping exits> situation.
*> Added some test routines as noted.
*> Compiles free format with no special options needed.
*> I have played it enough to exercise the code and it appears to run as designed.
*> 
*>==== C H A N G E   H I S T O R Y =========FOR MARCH 19 2022==================
*> Changes by Michael F. Gleason March 2022 
*> New Tectonics:
*>   cobc -x star_trek.cob -t star_trek.lst
*>******************************************************
*> THE PROGRAM SORT OF WORKS. I KEEPS GETTING STUCK IN THE 3000- PARAGRAPH.
*> ADDED CODE FOR ABRUPT END PROGRAM SEE 3 ??? FOR THE CODE 
*> <Not needed any more. problem fixed.> CODE LEFT IN AS OPTION.
*>
*> I PUT ??? ON LINES I CHANGED. ADDED CODE IS IN UPPERCASE.
*> ???? ON LINES I WAS NOT SURE OF.
*>  Tectonics:  -cb_conf=perform-osvs:yes SEEMS TO BE OBSOLETE. DOES NOT COMPILE
*> I looked for posts on this and found things from 2013 on ctrek
*> SO NOW I SET OUT ON A WORK AROUND BY CORRECTING PERFORMED EXITS WHERE NEEDED.
*>
*> It looks to me that someone started a conversion from fixed to free format.
*> Good start, I Just finished the conversion.
*>
*> I COMMENTED OUT ALL THE SECTION SECTIONS THINKING IT MIGHT HELP. NO DIFF AS
*> FAR AS I SEE. Anyway the program is not so large as to need SECTIONing.
*>
*> THE 8200- PARAGRAPH IS PROBLEMATIC. I CHANGED AS FOLLOWS;
*>  8200-ck-done.
*>     if bye-bye
*>        DISPLAY "Bye-Bye".
*>     GO TO 8200-EXIT.
*>
*>     if bye-bye          *>???? to put this back to origional, delete the above
*>        go to 2000-exit. *>???? to put this back, delete the above
*>  8200-exit.  exit.
*>        Leave the 8200- paragraph alone. following fixes worked.
*> THEN I CHANGED A LOT OF PARAGRAPHS TO GO TO THEIR OWN EXIT.
*> Adding a check for bye-bye at the beginning of the 2000- and 3000- paragraphs
*> then going to their exits if true apppeares to fix the cross-section exit issue.
*>
*> I found 2 bugs [related to a <.>] and fixed them. There could be more.
*>
*> just for the sake of testing I added a JMP command to jump close to headquarters
*> and a KIL command to jump close to a Klingon and a BAS command to jump close 
*> to a base. These are not added to the instruction display on purpose.
*> They are not to be used as cheat options. Easy to remove. To access these three
*> commands, you must be logged in as either <mica> or <test>.
*>
*> I didn't like the refueling at dock. It would actualy leave you with less fuel
*> than you came in with, so I tweeked it. Note, if you doc, nav away and doc again,
*> you end up with a FULL tank vs a partial refil. Not my intent, but it's there.
*>
*> On the commands, you may include the number that is asked for next. for example
*> command entered as com3 will go right to the display without asking for the 3.
*> or nav71 will navigate (7)west at 1.00 warp.
*> The commands may be single letter now n for nav, t for tor s for she and so...
*>
*> You should note that when asked for a reply that would be yes or no, no is the default.
*> You must spell <yes> correctly [no validity check]. Mis-types default to no. 
*>
*> compile and start the game. enter a name and skill level then reply <YES> to do you want
*> instructions. I noted everything I needed to know at first on a PostIt.
*>
*>
*>==== E N D  C H A N G E   H I S T O R Y ==FOR MARCH 19 2022==================
*>
*>==== C H A N G E   H I S T O R Y =========FOR MARCH 31 2022==================
*> Changes by Michael F. Gleason
*> Changed to start timer after reading instructions at game beginning.
*>
*> Changed some working storage abreviated names to be more readable and descriptive.
*> Added more comments to ws and proc devisions for readability.
*>
*> Changed to not subtract damages from total damages in the torpedo routine. 
*> Damages to shields was being subtracted from damages when torpedo hit enemy. This did not
*> appear to be consistent with the other rules for damages. This would be like doing
*> repairs away from a base. Damages repairs are done only after docking at a base.
*>
*> Added some more information when damages occur (damage control report 4500-disp-hit).
*> Only displays extra info when in test mode.
*>
*> Moved the perform of 4500-disp-hit to be done after updating damages and shields. Did this
*> to make the display damages correct for test mode.
*>
*> Added a display of the shield-cnt to the shields command to see what the setting is before
*> entering a new shield amount.
*>
*> Removed redundant 88 levels 
*>        88  nav-c 
*>        88  pha-c
*>        88  tor-c
*>        88  def-c
*>        88  doc-c
*>        88  com-c
*>
*> Tweeked the test commands to display quadrant of targets, and quadrant to jump to.
*> The jumps may not always be to the same quadrant as the targets.
*>
*> Added perform 4000-display-g thru 4000-exit after firing phasers or torpedoes.
*> See 2090-PROCESS-DONE routine.
*>
*> FIXED BUG when time of day is 0 minutes, initialize 1250-move-klingons loops indefinitely.
*>  For some reason happens with skill level 4.
*>
*> Added check for collision with headquarters to 7000-nav-ck AND 8000-bomb routines.
*>
*> Added star dates remaining to complete mission to com 4 command in 3040-com routine.
*>
*> Changed to not report unnecessary info after Enterprise gets destroyed.
*>
*> Changed to display bye-bye message only one time. Depending on where it is turned on,
*> it would be displayed repeatedly while exiting routines and eventually reaching 2000-exit.
*> This is to do with the origional problem of <thru with overlapping exits>.
*>
*> Added more information displays in several places.
*>
*>==== E N D  C H A N G E   H I S T O R Y ==FOR MARCH 31 2022==================
*>
*>==== C H A N G E   H I S T O R Y =========FOR           =====================
*>
*>==== E N D  C H A N G E   H I S T O R Y ==FOR           =====================
environment division.
configuration section.
source-computer.  multics.
object-computer.  multics. *> Mingw 3.1.2 windows 10 *> ???
data division.
working-storage section.
01  STAR-TREK-VERSION         PIC X(15) VALUE "VERSION 1.2.4". *> ??? UPDATE THIS WHEN CHANGES MADE
01  star-table.
    05  row      occurs 42 times.
        10  kolumn            pic x occurs 42 times.
01  rctr                      pic 99.
01  kctr                      pic 99.
01  commands-x.
    05  command               pic x(3).
        88  navigate          value "NAV" "nav" "N" "n".
        88  phasers           value "PHA" "pha" "P" "p".
        88  torpedo           value "TOR" "tor" "T" "t".
        88  shields           value "DEF" "def" "SHI" "shi" "SHE" "she" "S" "s". *> ??? ADDED SHE FOR SHEILDS
        88  dock              value "DOC" "doc" "D" "d".
        88  lib-com           value "COM" "com" "c" "C".
        88  END-PROGRAM       VALUE "END" "end". *> ??? ADDED FOR ABRUPT END PROGRAM
        88  JUMP-TO           VALUE "jmp" "JMP". *> ???? ACTIVE ONLY WHEN TESTING
        88  KILL-KLINGON      VALUE "kil" "KIL". *> ???? ACTIVE ONLY WHEN TESTING
        88  FIND-BASE         VALUE "BAS" "bas". *> ???? ACTIVE ONLY WHEN TESTING
    05  entry1                pic 9.
    05  entry2                pic 9.
01  mini-table.
    05  mrow     occurs 14 times.
        10  mcol              pic x occurs 14 times.
01  rcntr                     pic 99.  *> Row Counter index
01  kcntr                     pic 99.  *> Column Counter index
01  x-idx                     pic 999. *> row idx
01  y-idx                     pic 999. *> col idx
01  ws-date                   pic 9(4).
01  time-flag                 pic 9.
    88  time-flag-set         value 1.
01  max-no                    pic 999.
01  headquarters1             pic 9.   *> quadrant row
01  headquarters2             pic 9.   *> quadrant col
01  t-store                   pic 9(4).
01  attack-flag               pic 9.
    88  klingons-attacking    value 1.
01  too-late-flag             pic 9.
    88  too-late              value 1.
01  klingons-destroyed        pic 99.
01  k-r-move                  pic 99 value 1. *> Decide to move Klingons or Romulans
01  damages1                  pic 9(6). *> Usually general damages
01  damages2                  pic 9(6). *> Usually shields damages
01  phaser-units              pic 9(4). *> Phaser entered converted to a number
01  phaser-units-an           pic x(4). *> Phaser amount entered
01  number-ed                 pic zzz999.
01  number-ed2                pic zzzz99.
01  number-ed3                pic z99.
01  return-x                  pic x. *> place to receive a console reply at eoj.
01  comp-com                  pic 9. *> Place to receive computer com replys.
01  base-cnt                  pic 9 value 0.  *> How many bases in play.
01  random-no                 pic 99 value 0. *> Random number
01  a-idx                     pic 999. *> Row index
01  b-idx                     pic 999. *> Col index
01  SAVE-A                    PIC 999. *> ???? PART OF JMP COMMAND. TESTING
01  SAVE-B                    PIC 999. *> ???? PART OF JMP COMMAND. TESTING
01  SUB1                      PIC 999. *> ???? PART OF JMP & KIL COMMAND. TESTING
01  SUB2                      PIC 999. *> ???? PART OF JMP & KIL COMMAND. TESTING
01  SUB3                      PIC 999. *> ???? PART OF KIL COMMAND. TESTING
01  SUB4                      PIC 999. *> ???? PART OF KIL COMMAND. TESTING
01  warp1                     pic 99.
01  warp2                     pic 99.
01  warp3                     pic 99.
01  warp4                     pic 99.
01  generate-table.                    *> Used to determine [no-way] and [trap-vec] conditions
    05  char                  pic x occurs 25 times.
01  seed-table                pic x(25) value  *> used to initialize generate-table.
        "a4hfxnc89kd3jxf5dks3hb3m1".
01  genrte-result             pic 9.
    88  no-way                value 1.  *> Randomly switched on and off.
01  fuel-count                pic s9(5). *> Fuel remaining
01  INITIAL-fuel-count        pic s9(5).
01  torps                     pic 99 value 5. *> Torpedoes remaining
01  INITIAL-TORPS             PIC 99 VALUE 5. *> ??? ADDED FOR TESTING
01  prt-lines.
    05  con-red.
        10  filler            pic x(16) value
            "*Condition RED* ".
        10  klgns             pic 99.
        10  filler            pic x(21) value
            " Klingons in quadrant".
    05  con-green.
        10  filler            pic x(17) value
            "*Condition GREEN*".
    05  com-req.
        10  filler            pic x(22) value
            "What is your command? ".
01  master-tbl.                         *> main table containing stars, Klingons, Romulans, bases, Enterprise and headquaters
    05  marow     occurs 126 times.
        10  macol             pic x occurs 126 times.
01  mrctr                     pic 999. *> MasterRowCounter
01  mkctr                     pic 999. *> MasterColumnCounter
01  vab1                      pic 9.
01  vab2                      pic 99.
01  roll-x                    pic 999v. *> used in calc of random locations
01  shield-cnt                pic s9(4). *> shields remaining
01  shield-cnt-an             pic x(4).  *> accept input field when setting shields
01  damage-cnt                pic 9(6).  *> counter of damage to Enterprise
01  scan-keep.                           *> used by com 3 command
    05  cv                    pic 99 occurs 18 times. *> total Klingons and bases for com 3 command
01  scan-ctr                  pic 99.
01  scan-table.
    05  scan-row     occurs 14 times.
        10 scan-col           pic x occurs 14 times.
01  rx-s                      pic 99v99.
01  qt                        pic 99.
01  rt                        pic 99.
01  qx                        pic 99.
01  rx                        pic 99.
01  tr1                       pic 9.
01  tr2                       pic 9.
01  ktctr                     pic 99.
01  rtctr                     pic 99.
01  name-var.
    05  name-x                pic x(12). *> players name. Note special cases
        88 TEST-PLAY          VALUE "MICA" "TEST" "mica" "test" "Mica". *> ???
01  inst-reply                pic x(3).  *> reply field for instruction required
    88  yes-reply             value "yes" "YES" "Yes" "y" "Y". *> ??? ADDED MORE YESES
01  indicate-y                pic 9.
    88  trap-vec              value 1. *> Randomly turned on and off
01  indicate-x                pic 9.
    88  bye-bye               value 1.  *> Game over.
01  INDICATE-XX               PIC 9.    *> ???
    88  BEEN-HERE-BEFORE      VALUE 1.  *> ??? TO NOT REPEATE THE DISPLAY
01  indicate-z                pic 9.
    88  just-starting         value 0.
01  quadrant.
    05  filler                pic x(9) value "Quadrant ".
    05  quad1                 pic 9.
    05  filler                pic x value ",".
    05  quad2                 pic 9.
    05  filler                pic x(15) value
        "    STAR DATE: ".
    05  star-date             pic 9(4).
01  ds-date                   pic 9(4).  *> Attack Destruct Date.
01  ds-table.
    05  ds-min                pic 99.
    05  ds-sec                pic 99.
01  klingons                  pic 99.  *> Klingons remaining in play
01  romulons                  pic 99.  *> Romulons remaining in play
01  lst-reply                 pic x(3). *> receiving field for list com options request
    88  yes-lst               values "yes" "YES" "y" "Y". *> ??? added more yeses...
01  rev-str                   pic 9(6).      *> used in creating a random number to place objects in table
01  seed-x                    pic v9(6).     *> used in creating a random number to place objects in table
01  seed-ast                  pic 9(6)v9(6). *> used in creating a random number to place objects in table
01  ws-time.
    05  ws-hour               pic 99.
    05  ws-min                pic 99.
    05  ws-sec                pic 99.
    05  ws-sixty              pic 99.
01  time-rev.
    05  ws-sixty              pic 99.
    05  ws-sec                pic 99.
    05  ws-min                pic 99.
01  warp-speed.
    05  warp-a                pic 9.
    05  warp-pt               pic x.
    05  warp-b                pic 99.
01  course-x.
    05  course-a              pic 9.
    05  course-pt             pic x.
    05  course-b              pic 99.
01  vab5                      pic 99.
01  vab6                      pic 99.
01  klingons-ed               pic z9.
01  total-klingons            pic 99. *> total klingons at game start
01  quad-save-1               pic 9.
01  quad-save-2               pic 9.
01  srctr                     pic s999. *> ??? save row ctr. mostly used in navigation rotines
01  skctr                     pic s999. *> ??? save col ctr. mostly used in navigation rotines
01  mod-ctr                   pic 99.
01  md-row.
    05  md-sub                pic x occurs 28 times.
01  dm-phaser-units           pic 9(4).

01  count-k                   pic 99.
01  count-r                   pic 99.
01  dist-x                    pic 99.
01  dist-r                    pic 99.
01  dist-b                    pic 99.
01  tal4                      pic 9.
01  klgn-hit-tot              pic 9(5). *> count of damage to a Klingon from phaser hit
01  dist-to-klgn              pic 99.
01  dist-to-rmln              pic 99.
01  dist-to-base              pic 99.
01  row-idx                   pic 999.
01  col-idx                   pic 999.
01  row-idx-1                 pic 9.
01  col-idx-1                 pic 9.
01  entr-rcntr                pic 99. *> row and column counter indexes
01  entr-kcntr                pic 99.
01  rmln-rcntr                pic 99.
01  rmln-kcntr                pic 99.
01  klng-rcntr                pic 99.
01  klng-kcntr                pic 99.
01  base-rcntr                pic 99.
01  base-kcntr                pic 99.
01  star-ctr                  pic 999.
01  rep-ctr                   pic 99.
01  fuel-ed                   pic zzz99.
01  shield-ed                 pic zz99.
01  shield-blanks             pic 9.
01  qt1                       pic 9.
01  qt2                       pic 9.
01  qt3                       pic 9.
01  qt4                       pic 9.
01  r9                        pic 9.
01  q9                        pic 9.
01  w-idx                     pic 999.
01  z-idx                     pic 999.
01  skill-lev                 pic 9.
01  dist-k-str.
    05  dkc                   pic 99 occurs 45 times.
01  dist-r-str.
    05  drc                   pic 99 occurs 60 times.

procedure division.

0000-control. *> ??? section.
0000-program-control.
    perform 0100-housekeeping thru 0100-exit.
    perform 1000-mainline thru 1000-exit.
    perform 9000-end-of-job thru 9000-exit.
    stop run.

*>***********************************************
*> 0100-housekeeping initializes variables, and *
*> asks the user for a name and skill level.    *
*> It then determines the quantity of bases,    *
*> klingons, and romulons in the galaxy.        *
*> Instructions are a user option.              *
*>***********************************************

0100-housekeeping-section. *> ??? section.
0100-housekeeping.
    move 0 to shield-cnt.
    move 0 to damage-cnt.
    move 40000 to fuel-count INITIAL-fuel-count.
    move 0 to indicate-z.
    move 0 to genrte-result.
    move spaces to md-row.
    move seed-table to generate-table.
    move 0 to indicate-x.
    move 0 to indicate-y.
    move 0 to attack-flag.
    move 0 to too-late-flag.
    display "      ".
    display "      *STAR TREK* " STAR-TREK-VERSION.
    display "      ".
    display "Congratulations - you have just been appointed ".
    display "Captain of the U.S.S. Enterprise. ".
    display "      ".
    display "Please enter your name, Captain ".
    accept name-x.
    IF NAME-X EQUAL SPACES                          *> ??? Added
       MOVE "Anonymous" TO NAME-X.                  *> ??? Added
    DISPLAY "Welcome aboard Captain " NAME-X.       *> ??? Added
    display "And what is your skill level (1-4)? ". *> ??? Changged
    accept skill-lev.
    if skill-lev not numeric or skill-lev < 1 or skill-lev > 4
        display "INVALID SKILL LEVEL "
        display "Enter your skill level (1-4) "
        accept skill-lev
        if skill-lev not numeric or skill-lev < 1 or skill-lev > 4
            move 1 to skill-lev
            display "Your skill level must be 1 ".
    move 0 to vab5.
    move 0 to vab6.
    inspect name-x tallying vab6 for all "a".
    inspect name-x tallying vab6 for all "A". *> ??? Added
    inspect name-x tallying vab6 for all "e".
    inspect name-x tallying vab6 for all "E". *> ??? Added
    add 1 to vab6.
    inspect name-x tallying vab5 for all " ".
    compute vab6 rounded = (vab5 / 1.75) + (vab6 / skill-lev).
    compute total-klingons rounded = (skill-lev * 4) + vab6 + 5.
    compute vab1 = 9 - skill-lev.
    compute vab2 rounded = (skill-lev / 3) * total-klingons.
    move total-klingons to klingons.
    IF TEST-PLAY                                               *> ???
      IF skill-lev = 1                                         *> ???
       MOVE 5 TO klingons total-klingons                       *> ???
       MOVE 50 TO INITIAL-TORPS                                *> ???
       MOVE INITIAL-TORPS TO torps.                            *> ???
    IF TEST-PLAY                                               *> ???
      IF skill-lev NOT = 1                                     *> ???
       MOVE 50 TO INITIAL-TORPS                                *> ???
       MOVE INITIAL-TORPS TO torps.                            *> ???
    move vab1 to klingons-ed.
    display "      ".
    display "Do you require instructions? ".
    accept inst-reply.
    IF NAME-X EQUAL "Anonymous" AND skill-lev = 1  *> ??? Added because you probably 
       MOVE "yes" TO INST-REPLY.                   *> ??? need instructions for play.
    if yes-reply
        perform 0500-prt-inst thru 0500-exit
        perform 0550-add-inst thru 0550-exit
        PERFORM 0560-det-inst THRU 0560-EXIT.
    accept ws-time from time.            *> calculate star date of Klingon attack on headquarters
    move ws-min of ws-time to ds-min.
    move ws-sec of ws-time to ds-sec.
    move ds-table to star-date.
    add 16 to ds-min.
    if ds-min > 59
        move 1 to time-flag
    else
        move 0 to time-flag.
    move ds-table to ds-date.  *> the star date of attack on headquarters
    display "      ".
    display "      *MESSAGE FROM STAR FLEET COMMAND* ".
    display "      ".
    display "Attention - Captain " name-x.
    display "Your mission is to destroy the ".
    display total-klingons " Klingon ships that have invaded ".
    display "the galaxy to attack Star Fleet HQ ".
    display "on star date " ds-date " - giving you 16 star dates.".
    perform 1200-initialize-galaxy thru 1200-exit. *> place all objects into master table
    display "      ".
0100-exit.  exit.

0500-prt-inst.
    display "      ".
    display "You may use the following commands: ".
    DISPLAY "       END  (TO ABRUPTLY END THE GAME". *> ???
    display "       nav  (to navigate) ".
    display "       pha  (to fire phasers) ".
    display "       tor  (to fire torpedo) ".
    display "she or def  (to raise or lower shields) ".
    display "       doc  (to dock at a star base) ".
    display "       com  (to request info from the library computer) ".
    display "      ".
    display "COURSE PLOT COMPASS: ".
    display "              ".
    display "        1     ".
    display "      8   2   ".
    display "    7  -x-  3 ".
    display "      6   4   ".
    display "        5     ".
    display "              ".
0500-exit.  exit.

0550-add-inst.
    display "There are " klingons-ed " star bases located somewhere in the galaxy, ".
    display "which is made up of 81 quadrants, 1,1 thru 9,9. ".
    display "You may dock at a star base to refuel and effect repairs ".
    display "when there is a base in your quadrant.  You are authorized ".
    display "to destroy Romulon vessels if they interfere with your mission. ".
    display "      ".
0550-exit. exit.

0560-det-inst.
    DISPLAY "Commands may be single letter as follows, y for yes, n for nav, p for pha,".
    DISPLAY "t for tor, s for she, d for doc and c for com.".
    DISPLAY "Reply [enter] defaults to <no> or <0> depending on the type of input requested.". 
    DISPLAY "The default for [pha] is 300. The default for [nav] is not to navigate.".
    DISPLAY "      ".
    DISPLAY "The COM command allows for shortcut thusly; com1 for ship status, com2 for short".
    DISPLAY "range scan, com3 for long range scan, ... com6 to abandon ship.".
    DISPLAY "To relist the computer functions available, reply [enter] to the awaiting".
    DISPLAY "command, then yes to <do you want a list> question".
    DISPLAY "      ".
    DISPLAY "The NAV command allows for shortcut by adding course and warp factor. Example".
    DISPLAY "nav71 will navigate direction 7 <west> for warp 1.".
    DISPLAY "      ".
    DISPLAY "If at any time you need to relist commands, just reply [enter] to the".
    DISPLAY "request <what is your command?>, then reply [yes] to the request".
    DISPLAY "Do you require instructions?".
    DISPLAY "      ".
    display "Hit RETURN to begin game.".
    accept return-x.
0560-exit.  exit.

1000-mainline.
    perform 4000-display-g thru 4000-exit.
    move 1 to indicate-z.
    perform 2000-process thru 2000-exit
        until klingons < 1 or bye-bye.
    perform 8500-finish-game thru 8500-exit.
1000-exit.  exit.

1100-chk-galaxy.                     *> Move Klingons and Romulans around occasionally.
    add 1 to k-r-move.
    if k-r-move = 7
        inspect master-tbl replacing all "      K" by "K      "
        perform 1120-reset thru 1120-exit
    else
        if k-r-move = 12
            inspect master-tbl replacing all "R      " by "      R"
            perform 1120-reset thru 1120-exit
        else
            if k-r-move = 15
                inspect master-tbl replacing all "K           " by "           K"
                perform 1120-reset thru 1120-exit
            else
                if k-r-move > 20
                    inspect master-tbl replacing all "         R" by "R         "
                    perform 1120-reset thru 1120-exit
                    move 1 to k-r-move.
1100-exit.  exit.

1120-reset.
    perform 5900-trans thru 5900-exit. *> move current quadrant to mini table
    move 0 to klgns.
    move 0 to romulons.
    move 0 to base-cnt.
    inspect mini-table tallying klgns for all "K".
    inspect mini-table tallying romulons for all "R".
    inspect mini-table tallying base-cnt for all "B".
1120-exit.  exit.

1145-ck-flag.
    if time-flag-set and ds-min < 40
    add 60 to ds-min.
1145-exit.  exit.

1150-ck-time.
    if klingons > 0
        accept ws-time from time
        move ws-min of ws-time to ds-min
        perform 1145-ck-flag thru 1145-exit
        move ws-sec of ws-time to ds-sec
        move ds-table to star-date
    else
        go to 1150-exit.
    compute t-store = ds-date - star-date.
    if t-store < 90 and not klingons-attacking
        move 14 to max-no
        compute w-idx = ((headquarters2 - 1) * 14)
        compute z-idx = ((headquarters1 - 1) * 14)
        inspect master-tbl replacing all "K" by " "
        move 0 to rx
        perform 1170-move-on-hq thru 1170-exit
            varying kctr from 1 by 1 until kctr > klingons
        move 1 to attack-flag
        perform 5900-trans thru 5900-exit
        if (quad1 not = headquarters1 or quad2 not = headquarters2)
            display "WARNING - STAR DATE: " star-date
            display "Science Officer Spock advises"
            display "you navigate to quadrant " headquarters1 "," headquarters2
            display "to defend Star Fleet Headquarters".
    if not too-late
        move ds-date to ws-date.
    if star-date > ws-date and quad1 = headquarters1 and quad2 = headquarters2 and not too-late
        move 1 to too-late-flag
        add 230 to ws-date
    else
        if star-date > ws-date
            move 1 to indicate-x
            perform 8200-ck-done thru 8200-exit.
1150-exit.  exit.

1160-dbl-k.
    perform 1225-dbl-roll thru 1225-exit.
    add 1 to rx.
    compute a-idx = w-idx + a-idx.
    compute b-idx = z-idx + b-idx.
1160-exit.  exit.

1170-move-on-hq.
    move 0 to a-idx.
    perform 1160-dbl-k thru 1160-exit
        until macol (a-idx , b-idx) = " " and a-idx > 0.
    move "K" to macol (a-idx , b-idx).
1170-exit.  exit.

*>*********************************************
*> 1200-initialize-galaxy moves stars, kling- *
*> ons, romulons, bases, and finally, the en- *
*> terprise to master-tbl in random position, *
*> and in the quantities determined in 0100-  *
*> housekeeping.                              *
*>*********************************************

1200-initialize-galaxy.
    move spaces to master-tbl.
    accept ws-time from time.

    IF ws-min OF WS-TIME = 0 MOVE 1 TO ws-min OF WS-TIME. *> ??? FIX for initialize loop bug.

    move corresponding ws-time to time-rev.
    move time-rev to rev-str.
    compute seed-x = (rev-str / 1000000).    
    move 126 to max-no.
    perform 1230-move-stars thru 1230-exit
        varying star-ctr from 1 by 1 until star-ctr > 275.
    perform 1240-move-romulons thru 1240-exit
        varying star-ctr from 1 by 1 until star-ctr > vab2.
    perform 1250-move-klingons thru 1250-exit
        varying star-ctr from 1 by 1 until star-ctr > total-klingons.
    perform 1260-move-base thru 1260-exit
        varying star-ctr from 1 by 1 until star-ctr > vab1.
    perform 1270-move-e thru 1270-exit.
    perform 1280-move-hq thru 1280-exit.
1200-exit.  exit.

1220-roll.
    compute seed-ast = (262147.0 * seed-x).
    move seed-ast to seed-x.
    compute roll-x = (seed-x * max-no) + 1.
1220-exit.  exit.

1225-dbl-roll.
    perform 1220-roll thru 1220-exit.
    move roll-x to a-idx.
    perform 1220-roll thru 1220-exit.
    move roll-x to b-idx.
1225-exit.  exit.

1230-move-stars.
    perform 1225-dbl-roll thru 1225-exit.
    move "*" to macol (a-idx , b-idx).
1230-exit.  exit.

1240-move-romulons.
    perform 1225-dbl-roll thru 1225-exit.
    move "R" to macol (a-idx , b-idx).
1240-exit.  exit.

1250-move-klingons.
    perform 1225-dbl-roll thru 1225-exit
        until macol (a-idx , b-idx) = " ".
    move "K" to macol (a-idx , b-idx).
1250-exit.  exit.

1260-move-base.
    perform 1225-dbl-roll thru 1225-exit
        until macol (a-idx , b-idx) = " ".
    move "B" to macol (a-idx , b-idx).
1260-exit.  exit.

1270-move-e.
    perform 1225-dbl-roll thru 1225-exit
        until macol (a-idx , b-idx) = " ".
    move a-idx to mrctr.
    move b-idx to mkctr.
    move "E" to macol (mrctr , mkctr).
1270-exit.  exit.

1280-move-hq.
    perform 1225-dbl-roll thru 1225-exit
        until macol (a-idx , b-idx) = " ".
    move "H" to macol (a-idx , b-idx).
    MOVE A-idx TO SAVE-A.                     *> ???? SAVE FOR JMP COMMAND
    MOVE B-idx TO SAVE-B.                     *> ???? SAVE FOR JMP COMMAND
    compute headquarters1 = (b-idx - 1) / 14 + 1.
    compute headquarters2 = (a-idx - 1) / 14 + 1.
1280-exit.  exit.

1700-ck-var-warp.
    inspect course-b replacing all " " by zeros.
    inspect warp-a replacing all " " by zeros.
    inspect warp-b replacing all " " by zeros.
    if course-b not numeric
        move zero to course-b.
    if warp-a not numeric
        move zero to warp-a.
    if warp-b not numeric
        move zero to warp-b.
1700-exit.  exit.

*>*******************************************
*> 2000-process is an iterative loop that   *
*> requests and executes a command until    *
*> all klingons are destroyed, or the En-   *
*> terprise is no longer able to continue.  *
*>*******************************************

2000-process.
    IF BYE-BYE GO TO 2000-EXIT. *> ??? JUST TRYING TO GET CONTROL OF PERFORM EXITS
    perform 8400-generate thru 8400-exit. *> Flip no-way and trap-vec on and off randomly.
    if no-way or klgns > 1
        add 4 to random-no.
    display com-req.
    accept commands-x.

    IF END-PROGRAM GOBACK.         *> ??? ADDED FOR ABRUPT END PROGRAM

*> THIS "TEST" JUMP DOES NOT TAKE INTO CONSIDERATION FUEL CONSUMPTION, DAMAGES
*> OR THE POSIBILITY OF A COLISION WITH A BASE, KLINGON, ROMULAN OR HEADQUARTERS.
*> Jump to a position close to headqutars.      *> ??? FOR TESTING
*> This is for testing only. Not regular play.  *> ??? FOR TESTING
    IF TEST-PLAY *> ??? is user name-x <test> or <mica>
      IF JUMP-TO *> ???? WHEN TESTING ACTIVE, jump to headquaters
       PERFORM   *> ??? A STAR SHIP SOULD ALWAYS KNOW WHERE HEADQUARTERS IS
          VARYING SUB1 FROM 1 BY 1 UNTIL SUB1 > 126 *> ??? SO WHAT DOES THIS HURT.
          AFTER   SUB2 FROM 1 BY 1 UNTIL SUB2 > 126
          IF macol (SUB1, SUB2) = "E"
             EXIT PERFORM
          END-IF
       END-PERFORM
       compute row-idx-1 = (SAVE-B - 1) / 14 + 1
       compute col-idx-1 = (SAVE-A - 1) / 14 + 1
       DISPLAY "Headquarters in QUADRANT " row-idx-1 "," col-idx-1
       IF SAVE-A > 2
          COMPUTE srctr = SAVE-A - 1
       ELSE
          COMPUTE srctr = SAVE-A + 1 END-IF
       IF SAVE-B > 2
          COMPUTE skctr = SAVE-B - 1
       ELSE
          COMPUTE skctr = SAVE-B + 1 END-IF
       IF srctr > 126 MOVE 120 TO srctr END-IF
       IF skctr > 126 MOVE 120 TO skctr END-IF
       MOVE SUB1 TO mrctr
       MOVE SUB2 TO mkctr
       compute row-idx-1 = (skctr - 1) / 14 + 1
       compute col-idx-1 = (srctr - 1) / 14 + 1
       DISPLAY "JUMPING TO QUADRANT " row-idx-1 "," col-idx-1
       PERFORM 7000-nav-ck THRU 7000-EXIT
       perform 4000-display-g thru 4000-exit
       go to 2090-PROCESS-DONE           *> ???
      END-IF
    END-IF.                                 *> ??? JMP TESTING ENDS HERE

*> THIS "TEST" JUMP DOES NOT TAKE INTO CONSIDERATION FUEL CONSUMPTION, DAMAGES
*> OR THE POSIBILITY OF A COLISION WITH A BASE, KLINGON, ROMULAN OR HEADQUARTERS.
*> ??? JUMP TO A POSITION CLOSE TO AN ENEMY SO YOU MAY KIL IT.
*> ??? THERE IS NO GUARANTEE THE ENEMY IS THERE. YOU MAY NEED TO SEARCH.
*> ??? THE ENEMY IS WITHIN 4 PARSECS AWAY FROM WHERE YOU EXITED WARP.
*> ???? This is for testing only.
    IF TEST-PLAY *> ??? is user name-x <test> or <mica>
      IF KILL-KLINGON
       PERFORM
          VARYING SUB3 FROM 1 BY 1 UNTIL SUB3 > 126
          AFTER   SUB4 FROM 1 BY 1 UNTIL SUB4 > 126
          IF macol (SUB3, SUB4) = "K"
             compute row-idx-1 = (SUB4 - 1) / 14 + 1
             compute col-idx-1 = (SUB3 - 1) / 14 + 1
             DISPLAY "Klingon in QUADRANT " row-idx-1 "," col-idx-1
             EXIT PERFORM
          END-IF
       END-PERFORM
       PERFORM
          VARYING SUB1 FROM 1 BY 1 UNTIL SUB1 > 126
          AFTER   SUB2 FROM 1 BY 1 UNTIL SUB2 > 126
          IF macol (SUB1, SUB2) = "E"
             EXIT PERFORM
          END-IF
       END-PERFORM
       IF SUB3 < 11 MOVE 1 TO SUB3 END-IF
       IF SUB4 < 11 MOVE 1 TO SUB4 END-IF
       IF SUB3 > 115 MOVE 115 TO SUB3 END-IF
       IF SUB4 > 115 MOVE 115 TO SUB4 END-IF
       COMPUTE srctr = SUB3 + 4
       COMPUTE skctr = SUB4 + 4
       MOVE SUB1 TO mrctr
       MOVE SUB2 TO mkctr
       compute row-idx-1 = (skctr - 1) / 14 + 1
       compute col-idx-1 = (srctr - 1) / 14 + 1
       DISPLAY "JUMPING TO QUADRANT " row-idx-1 "," col-idx-1
       PERFORM 7000-nav-ck THRU 7000-EXIT
       perform 4000-display-g thru 4000-exit
       go to 2090-PROCESS-DONE           *> ???
      END-IF
    END-IF.                                  *> ??? KILL TESTING ENDS HERE

*> THIS "TEST" JUMP DOES NOT TAKE INTO CONSIDERATION FUEL CONSUMPTION, DAMAGES
*> OR THE POSIBILITY OF A COLISION WITH A BASE, KLINGON, ROMULAN OR HEADQUARTERS.
*> JUMP TO A POSITION CLOSE TO A BASE.
*> ???? This is for testing only.
    IF TEST-PLAY *> ??? is user name-x <test> or <mica>
      IF FIND-BASE
       PERFORM
          VARYING SUB3 FROM 1 BY 1 UNTIL SUB3 > 126
          AFTER   SUB4 FROM 1 BY 1 UNTIL SUB4 > 126
          IF macol (SUB3, SUB4) = "B"
             compute row-idx-1 = (SUB4 - 1) / 14 + 1
             compute col-idx-1 = (SUB3 - 1) / 14 + 1
             DISPLAY "BASE in QUADRANT " row-idx-1 "," col-idx-1
             EXIT PERFORM
          END-IF
       END-PERFORM
       PERFORM
          VARYING SUB1 FROM 1 BY 1 UNTIL SUB1 > 126
          AFTER   SUB2 FROM 1 BY 1 UNTIL SUB2 > 126
          IF macol (SUB1, SUB2) = "E"
             EXIT PERFORM
          END-IF
       END-PERFORM
       IF SUB3 > 125 MOVE 125 TO SUB3 END-IF
       IF SUB4 > 125 MOVE 125 TO SUB4 END-IF
       COMPUTE srctr = SUB3 - 1
       COMPUTE skctr = SUB4 - 1
       IF SUB3 > 2
          COMPUTE srctr = SUB3 - 1
       ELSE
          COMPUTE srctr = SUB3 + 1 END-IF
       IF SUB4 > 2
          COMPUTE skctr = SUB4 - 1
       ELSE
          COMPUTE skctr = SUB4 + 1 END-IF
       MOVE SUB1 TO mrctr
       MOVE SUB2 TO mkctr
       compute row-idx-1 = (skctr - 1) / 14 + 1
       compute col-idx-1 = (srctr - 1) / 14 + 1
       DISPLAY "JUMPING TO QUADRANT " row-idx-1 "," col-idx-1
       PERFORM 7000-nav-ck THRU 7000-EXIT
       perform 4000-display-g thru 4000-exit
       go to 2090-PROCESS-DONE           *> ???
      END-IF
    END-IF.                                  *> ??? BAS TESTING ENDS HERE


    if navigate
        if entry1 not numeric or entry1 < 1 or entry1 > 8 or entry2 not numeric
            display "What course (1 - 8.99)? "
            accept course-x
            display "What warp factor (0.00 - 9.99)? "
            accept warp-speed
            perform 1700-ck-var-warp thru 1700-exit
            perform 7100-nav thru 7100-exit
            perform 4000-display-g thru 4000-exit
        else
            move entry1 to course-a
            move entry2 to warp-a
            move 0 to course-b
            move 0 to warp-b
            perform 7100-nav thru 7100-exit
            perform 4000-display-g thru 4000-exit
    else
        if phasers
            perform 7200-pha thru 7200-exit
        else
            if torpedo
                perform 7300-tor thru 7300-exit
            else
                if shields
                    perform 7500-def thru 7500-exit
                else
                    if dock
                        perform 7600-doc thru 7600-exit
                    else
                        if lib-com
                            perform 3000-com-fun thru 3000-exit
                        else
                            display "INVALID COMMAND - Do you want a list of commands? "
                            accept lst-reply
                            if yes-lst
                                perform 0500-prt-inst thru 0500-exit
                                PERFORM 0560-det-inst THRU 0560-EXIT.
2090-PROCESS-DONE.
    perform 1150-ck-time thru 1150-exit.
    perform 1100-chk-galaxy thru 1100-exit. *> Move Klingons and Romulans around occasionally.
    if phasers or torpedo                     *> ??? added for information
       perform 4000-display-g thru 4000-exit. *> ??? added for information
2000-exit.  exit.

*>**************************************
*> 3000-com-fun simulates the opera-   *
*> tion of an on-board library compu-  *
*> ter, and responds to numeric com-   *
*> mands , range 1 - 6.                *
*>**************************************

3000-com-fun.
    IF BYE-BYE GO TO 3000-EXIT. *> ??? JUST TRYING TO GET CONTROL OF PERFORM EXITS
    display "      ".
    if entry1 not numeric or entry1 < 1 or entry1 > 6
        display "[COMPUTER ACTIVE AND AWAITING COMMAND] " *> ??? PUT [ AND ] AROUND MESSAGE FOR UNIQUENESS
        accept comp-com
    else
        move entry1 to comp-com.
    if comp-com not numeric or comp-com < 1 or comp-com > 6
        display "INVALID COMPUTER COMMAND "
        display "Do you want a list  of computer commands? "

        accept lst-reply
        if yes-lst
            display "Functions available from the library computer: "
            display "     1  To request ship status "
            display "     2  To request short range scan of quadrant "
            display "     3  To request long range scan "
            display "     4  To request Klingons spy report "
            display "     5  To request intelligence report "
            display "     6  To abandon ship "
            display "      "
            display "*COMPUTER ACTIVE AND AWAITING COMMAND* "
            accept comp-com
        else
            display "COMPUTER COMMAND?"
            accept comp-com.
    go to
        3010-com
        3020-com
        3030-com
        3040-com
        3050-com
        3060-com
            depending on comp-com.
    display " INVALID COMPUTER COMMAND ".
    go to 3000-exit.

3010-com.
    perform 7400-status-rpt thru 7400-exit.
    go to 3000-exit.

3020-com.
    perform 4000-display-g thru 4000-exit.
    go to 3000-exit.

3030-com.
    perform 7700-lrs thru 7700-exit.
    go to 3000-exit.

3040-com.
    compute klingons-destroyed = total-klingons - klingons.
    display "      ".
    DISPLAY "Intelligence from a Klingon counter spy has been received". *> ??? for fun
    DISPLAY "at headquarters. An attack has been planned!".              *> ??? for fun
    display klingons-destroyed " Klingons destroyed, " klingons " remain ".
    display "ATTACK DATE: " ds-date.
    display "STAR DATE: " star-date.
    COMPUTE number-ed3 = (ds-date - star-date) / 100.                            *> ??? Added
    DISPLAY number-ed3 " Star dates remaining to complete your mission " name-x. *> ??? Added
    display "      ".
    perform 8100-dmg-com thru 8100-exit.
    go to 3000-exit.

3050-com.
    perform 7800-int thru 7800-exit.
    go to 3000-exit.

3060-com.
    display "Do you want to rethink that decision? "
    accept lst-reply
    if yes-lst
        go to 3000-exit.
    move 1 to indicate-x.
    display "      ".
    display "*ENTERPRISE STRANDED - CAPTAIN BOOKED  * ".
    display "      ".
    perform 8200-ck-done thru 8200-exit.
    go to 3000-exit.

3000-exit.  exit.

*>******************************************
*> 4000-display-g determines what quadrant *
*> the enterprise is in, and displays the  *
*> quadrant, notifying user of presence of *
*> klingons in quadrant.                   *
*>******************************************

4000-display-g.
    move 0 to klgns.
    move 0 to romulons.
    move 0 to base-cnt.
    move quad1 to quad-save-1.
    move quad2 to quad-save-2.
    compute quad1 = (mkctr - 1) / 14 + 1.
    compute quad2 = (mrctr - 1) / 14 + 1.
    if quad1 not = quad-save-1 or quad2 not = quad-save-2
        move 0 to klgn-hit-tot.
    compute x-idx = (quad1 - 1) * 14.
    compute y-idx = (quad2 - 1) * 14.
    perform 5900-trans thru 5900-exit.            *> Transfer current quadrant to mini table
    inspect mini-table tallying klgns for all "K".
    inspect mini-table tallying romulons for all "R".
    inspect mini-table tallying base-cnt for all "B".
    display "      ".
    if just-starting
        display "You begin in quadrant " quad1 "," quad2 " with 40,000 "
        display "units of fuel and " torps " photon torpedoes. "
        display "      "
        display "Good luck, Captain " name-x
        display "      "
        if klgns > 0
            display con-red 
        else
            display con-green
    else
        if klgns > 0 AND NOT BYE-BYE  *> ??? Added "AND NOT BYE-BYE" to this compair
            display con-red
            compute damages1 = klgns * fuel-count / (shield-cnt + 27)
            perform 4200-test-var thru 4200-exit
            compute damages2 = .75 * damages1
            add damages1 to damage-cnt
            subtract damages2 from shield-cnt
            display "*ENTERPRISE ENCOUNTERING KLINGON FIRE* "
            perform 4500-disp-hit thru 4500-exit
        else
            IF KLGNS = 0    *> ??? DON'T REPORT A CONDITION WHEN ENTERPRISE WAS DESTROYED.
                display con-green.
    display quadrant.
    perform 6500-display-mini-table thru 6500-exit. 
    display "      ".
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
4000-exit.  exit.

4200-test-var.
    if damages1 < 1776 and klgns > 0
        add 223 to damages1
        compute damages1 = (klgns * damages1 / 3.5) + (damages1 * damage-cnt / 760) + (random-no * 17).
4200-exit.  exit.

4500-disp-hit.
    move damages1 to number-ed.
    display number-ed " units hit on Enterprise ".
    IF TEST-PLAY                                          *> ??? 
        MOVE SHIELD-CNT TO SHIELD-ED                      *> ???
        COMPUTE number-ed3 = (SHIELD-CNT / 9999) * 100    *> ???
        DISPLAY "Shields at" number-ed3 "%"               *> ???
        COMPUTE number-ed3 = (damage-cnt / 60)            *> ???
        IF DAMAGE-CNT > 6000                              *> ???
           MOVE 100 TO NUMBER-ED3                         *> ???
        END-IF                                            *> ???
        DISPLAY "Damages at" NUMBER-ED3 "%".              *> ???
4500-exit.  exit.

4700-disp-hit.
    move phaser-units to number-ed.
    display number-ed " units hit on Klingon ".
4700-exit.  exit.

5400-trans-back.                   *> Move mini table back into master table current quadrant
    perform 5500-transfer-back thru 5500-exit
        varying kcntr from 1 by 1 until kcntr > 14
        after rcntr from 1 by 1 until rcntr > 14.
5400-exit.  exit.

5500-transfer-back.
    compute a-idx = y-idx + rcntr.
    compute b-idx = x-idx + kcntr.
    move mcol (rcntr , kcntr) to macol (a-idx , b-idx).
5500-exit.  exit.

5900-trans.                          *> Move current quadrant from master table to mini table
    perform 6000-transfer thru 6000-exit
        varying kcntr from 1 by 1 until kcntr > 14
        after rcntr from 1 by 1 until rcntr > 14.
5900-exit.  exit.

6000-transfer.
    compute a-idx = y-idx + rcntr.
    compute b-idx = x-idx + kcntr.
    move macol (a-idx , b-idx) to mcol (rcntr , kcntr).
6000-exit.  exit.

6500-display-mini-table.
    display "= = = = = = = = = = = = = = = =".
    perform 6600-mini-dis thru 6600-exit
        varying rcntr from 1 by 1 until rcntr > 14.
    display "= = = = = = = = = = = = = = = =".
6500-exit.  exit.

6600-mini-dis.
    perform 6700-mini-mod thru 6700-exit
        varying kcntr from 1 by 1 until kcntr > 14.
    display "=" md-row " =".
6600-exit.  exit.

6700-mini-mod.
    compute mod-ctr = 2 * kcntr.
    move mcol (rcntr , kcntr) to md-sub (mod-ctr).
6700-exit.  exit.

7000-nav-ck.
    if srctr < 1 or srctr > 126 or skctr < 1 or skctr > 126
        display "Warp drive shut down - "
        display "UNAUTHORIZED ATTEMPT TO LEAVE GALAXY "
        perform 8100-dmg-com thru 8100-exit
*>       go to 2000-exit   *> ??? COMMENTED THIS AN REPLASED WITH FOLLOWING BECAUSE go to 2000-exit IS PROBLEMATIC FOR ME
        go to 7000-exit   *> ??? THIS PREVENTS POOR NAVIGATION FROM ENDING GAME
    else
        move " " to macol (mrctr , mkctr)
        move srctr to mrctr            *> ???? REMOVED THE <.> PERIOD
        move skctr to mkctr            *> ???? REMOVED THE <.> PERIOD
        if   macol (mrctr , mkctr) = "K" or macol (mrctr , mkctr) = "R" 
          or macol (mrctr , mkctr) = "B" or macol (mrctr , mkctr) = "H" *> Added "H"
            perform 8000-bomb thru 8000-exit
        else
            move "E" to macol (mrctr , mkctr).
7000-exit.  exit.

*>*******************************************
*> 7100-nav thru 7800-int execute various   *
*> commands from the user, and present the  *
*> results and consequences of each command *
*>                                          *
*> Called from 2000-process or 3000-com-fun *
*>*******************************************

7100-nav.
    perform 8340-ck-fl thru 8340-exit.
    IF FUEL-COUNT < (200 * WARP-A)
       DISPLAY "*INSUFFICIENT FUEL TO NAVIGATE*"
       GO TO 7100-EXIT.
    compute fuel-count = fuel-count - (200 * warp-a).
    if warp-a > 0
        move warp-a to rx-s
    else
        compute rx-s rounded = warp-b / 100.
    move mrctr to srctr.
    move mkctr to skctr.
    compute warp1 rounded = (warp-a * 5) + (warp-b * .05).
    compute warp2 rounded = (warp-a * 8) + (warp-b * .08).
    compute warp3 rounded = (course-b * .05) * rx-s.
    compute warp4 rounded = (course-b * .03) * rx-s.
    go to
        7110-nav
        7120-nav
        7130-nav
        7140-nav
        7150-nav
        7160-nav
        7170-nav
        7180-nav
            depending on course-a.
    display "INVALID COURSE".
    go to 7100-exit.
7110-nav.
    compute srctr = srctr - warp2 + warp4.
    compute skctr = skctr + warp3.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7120-nav.
    compute srctr = srctr - warp1 + warp3.
    compute skctr = skctr + warp1 + warp4.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7130-nav.
    compute srctr = srctr + warp3.
    compute skctr = skctr + warp2 - warp4.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7140-nav.
    compute srctr = srctr + warp1 + warp4.
    compute skctr = skctr + warp1 - warp3.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7150-nav.
    compute srctr = srctr + warp2 - warp4.
    compute skctr = skctr - warp3.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7160-nav.
    compute srctr = srctr + warp1 - warp3.
    compute skctr = skctr - warp1 - warp4.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7170-nav.
    compute srctr = srctr - warp3.
    compute skctr = skctr - warp2 + warp4.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7180-nav.
    compute srctr = srctr - warp1 - warp4.
    compute skctr = skctr - warp1 + warp3.
    perform 7000-nav-ck thru 7000-exit.
    go to 7100-exit.
7100-exit.  exit.

7200-pha.                  *> Fire phasers. Uses a minimum of 300 fuel units to fire.
    if klgns < 1 and romulons < 1
        display "Science Officer Spock reports no enemy "
        display "vessels in this quadrant, " name-x
        go to 7200-exit.
    perform 8340-ck-fl thru 8340-exit.
    if fuel-count < 9999
        move fuel-count to fuel-ed
        display "Maximum of " fuel-ed " units available to phasers ".
    display "How many units to phaser banks? ".
    accept phaser-units-an.
    perform 7210-rep-bl thru 7210-exit. *> Make phaser amount entered into a number
    perform 7220-compute-dist thru 7220-exit.
    compute damages1 = 450000 / (shield-cnt + 100).
    perform 8150-test-agn thru 8150-exit.
    if klgns > 1 and trap-vec
        display "*ENTERPRISE DESTROYED* "
        display "Direct hits from " klgns " klingons "
        move 1 to indicate-x                     *> ???? REMOVED <.>
        perform 8200-ck-done thru 8200-exit.

    IF BYE-BYE GO TO 7200-exit. *> ???? I'M NOT SURE ABOUT THIS

    compute dm-phaser-units = phaser-units - (damage-cnt / 15).
    compute damages2 = damages1 / 2.
    if romulons > 0
        display "*ROMULON VESSELS PRESENT IN QUADRANT* "
        display "Do you want to fire on Romulons? "
        accept lst-reply
        if yes-lst
            perform 7250-romulon-ck thru 7250-exit
            go to 7200-exit.
    if klgns > 0
        compute damages1 = damages1 / (dist-x / 10)
        subtract phaser-units from fuel-count
        move dm-phaser-units to phaser-units
        add klgn-hit-tot to phaser-units
        if phaser-units < 400
            perform 4700-disp-hit thru 4700-exit
            display "*KLINGON DISABLED* "
            compute phaser-units = .75 * phaser-units
            add phaser-units to klgn-hit-tot
            add damages1 to damage-cnt
            subtract damages2 from shield-cnt
            perform 4500-disp-hit thru 4500-exit
        else
            perform 7201-replace thru 7201-exit
                varying rep-ctr from 1 by 1 until rep-ctr > rx
            inspect mini-table replacing first "K" by " "
            inspect mini-table replacing all "x" by "K"
            compute phaser-units = phaser-units / (dist-x ** .224)
            perform 4700-disp-hit thru 4700-exit
            display "*KLINGON DESTROYED* "
            move 0 to klgn-hit-tot
            subtract 1 from klgns
            subtract 1 from klingons
            perform 5400-trans-back thru 5400-exit
            if klgns > 0
                add damages1 to damage-cnt
                compute damages1 = .75 * damages1
                subtract damages1 from shield-cnt
                perform 4500-disp-hit thru 4500-exit
            else
                move damages2 to damages1
                add damages2 to damage-cnt
                subtract damages2 from shield-cnt
                perform 4500-disp-hit thru 4500-exit
    else
        display "There are 0 Klingons in this quadrant, " name-x.
    perform 8120-dam-com thru 8120-exit.
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
7200-exit.  exit.

7201-replace.
    inspect mini-table replacing first "K" by "x".
7201-exit.  exit.

7202-replace.
    inspect mini-table replacing first "R" by "x".
7202-exit.  exit.

7210-rep-bl.                                   *> Make phaser amount entered into a number
    move 0 to tal4.
    inspect phaser-units-an tallying tal4 for all " ".
    if tal4 > 0
        inspect phaser-units-an replacing all " " by zeros
        if phaser-units-an numeric
            move phaser-units-an to phaser-units
            compute phaser-units = phaser-units / (10 ** tal4)
        else
            move 300 to phaser-units
    else
        if phaser-units-an numeric
            move phaser-units-an to phaser-units
        else
            move 300 to phaser-units.
    if phaser-units < 300
        move 300 to phaser-units.
7210-exit.  exit.

7220-compute-dist.
    move 30 to dist-b.
    move 30 to dist-x.
    move 30 to dist-r.
    move 0 to count-k.
    move 0 to count-r.
    perform 7225-find-e thru 7225-exit
        varying rcntr from 1 by 1 until rcntr > 14
        after kcntr from 1 by 1 until kcntr > 14.
    perform 7230-compute thru 7230-exit
        varying rcntr from 1 by 1 until rcntr > 14
        after kcntr from 1 by 1 until kcntr > 14.
    perform 7247-est-nbr thru 7247-exit.
7220-exit.  exit.

7225-find-e.
    if mcol (rcntr , kcntr) = "E"
        move rcntr to entr-rcntr
        move kcntr to entr-kcntr.
7225-exit.  exit.

7230-compute.
    if mcol (rcntr , kcntr) = "K"
        move rcntr to klng-rcntr
        move kcntr to klng-kcntr
        add 1 to count-k
        move dist-x to dist-to-klgn
        perform 7240-dist-k thru 7240-exit
        if dist-x > dist-to-klgn
            move dist-to-klgn to dist-x.
    if mcol (rcntr , kcntr) = "R"
        move rcntr to rmln-rcntr
        move kcntr to rmln-kcntr
        add 1 to count-r
        move dist-r to dist-to-rmln
        perform 7243-dist-r thru 7243-exit
        if dist-r > dist-to-rmln
            move dist-to-rmln to dist-r.
    if mcol (rcntr , kcntr) = "B"
        move rcntr to base-rcntr
        move kcntr to base-kcntr
        move dist-b to dist-to-base
        perform 7245-dist-b thru 7245-exit
        if dist-b > dist-to-base
            move dist-to-base to dist-b.
7230-exit.  exit.

7240-dist-k.                                       *> Distance to Klingon from Enterprise
    if klng-rcntr > entr-rcntr
        compute klng-rcntr = klng-rcntr - entr-rcntr
    else
        compute klng-rcntr = entr-rcntr - klng-rcntr.
    if klng-kcntr > entr-kcntr
        compute klng-kcntr = klng-kcntr - entr-kcntr
    else
        compute klng-kcntr = entr-kcntr - klng-kcntr.
    compute dist-x rounded = ((klng-rcntr ** 2) + (klng-kcntr ** 2)) ** .5.
    move dist-x to dkc (count-k).
7240-exit.  exit.

7243-dist-r.                                       *> Distance to Romulon from Enterprise
    if rmln-rcntr > entr-rcntr
        compute rmln-rcntr = rmln-rcntr - entr-rcntr
    else
        compute rmln-rcntr = entr-rcntr - rmln-rcntr.
    if rmln-kcntr > entr-kcntr
        compute rmln-kcntr = rmln-kcntr - entr-kcntr
    else
        compute rmln-kcntr = entr-kcntr - rmln-kcntr.
    compute dist-r rounded = ((rmln-rcntr ** 2) + (rmln-kcntr ** 2)) ** .5.
    move dist-r to drc (count-r).
7243-exit.  exit.

7245-dist-b.                                       *> Distance to a base from Enterprise
    if base-rcntr > entr-rcntr
        compute base-rcntr = base-rcntr - entr-rcntr
    else
        compute base-rcntr = entr-rcntr - base-rcntr.
    if base-kcntr > entr-kcntr
        compute base-kcntr = base-kcntr - entr-kcntr
    else
        compute base-kcntr = entr-kcntr - base-kcntr.
    compute dist-b rounded = ((base-rcntr ** 2) + (base-kcntr ** 2)) ** .5.
7245-exit.  exit.

7247-est-nbr.
    move 30 to dist-to-base.
    perform 7248-est-k thru 7248-exit
    varying rt from 1 by 1 until rt > count-k.
    perform 7249-est-r thru 7249-exit
        varying qt from 1 by 1 until qt > count-r.
7247-exit.  exit.

7248-est-k.
    if dkc (rt) < dist-to-base
        move dkc (rt) to dist-to-base
        compute rx = rt - 1.
7248-exit.  exit.

7249-est-r.
    if drc (qt) < dist-to-rmln
        move drc (qt) to dist-to-rmln
        compute qx = qt - 1.
7249-exit.  exit.

7250-romulon-ck.
    if romulons > 2 and no-way
        display "*ENTERPRISE FIRING ON ROMULONS*"
        display "*ROMULONS RETURNING FIRE* "
        display "Simultaneous hits from " romulons " Romulons "
        display "*ENTERPRISE DESTROYED*"
        move 1 to indicate-x
        perform 8200-ck-done thru 8200-exit
        GO TO 7250-exit                       *> ????
    else
        perform 8400-generate thru 8400-exit *> Flip no-way and trap-vec on and off randomly.
        display "*ENTERPRISE FIRING ON ROMULONS* "
        subtract phaser-units from fuel-count
        if no-way or phaser-units < 447
            compute phaser-units = phaser-units / (dist-r ** .224)
            move phaser-units to number-ed
            display number-ed " units hit on Romulon "
            display "*ROMULON RETURNING FIRE*"
            perform 8400-generate thru 8400-exit *> Flip no-way and trap-vec on and off randomly.
            if no-way
                display "*ENTERPRISE DESTROYED BY ROMULON TORPEDO* "
                move 1 to indicate-x
                perform 8200-ck-done thru 8200-exit
                GO TO 7250-exit *> ????
            else
                compute damages1 = 3 * damages1 / (dist-r / 10)
                add damages1 to damage-cnt
                compute damages2 = damages1 / 2
                if damages2 < 9999
                    subtract damages2 from shield-cnt
                    perform 4500-disp-hit thru 4500-exit
                else
                    move 0 to shield-cnt
                    perform 4500-disp-hit thru 4500-exit
        else
            compute phaser-units = phaser-units / (dist-x ** .125)
            move phaser-units to number-ed
            display number-ed " units hit on Romulon "
            display "*ROMULON DESTROYED*"
            perform 7202-replace thru 7202-exit
                varying rep-ctr from 1 by 1 until rep-ctr > qx
            inspect mini-table replacing first "R" by " "
            inspect mini-table replacing all "x" by "R"
            subtract 1 from romulons
            perform 5400-trans-back thru 5400-exit.
    perform 8100-dmg-com thru 8100-exit.
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
7250-exit.  exit.

7300-tor.
    if klgns < 1 and romulons < 1
        display "There are 0 enemy vessels in this quadrant, " name-x
        go to 7300-exit.
    perform 8400-generate thru 8400-exit. *> Flip no-way and trap-vec on and off randomly.
    compute damages1 = 250000 / (shield-cnt + 100).
    perform 8150-test-agn thru 8150-exit.
    perform 7220-compute-dist thru 7220-exit.
    if klgns > 2
        compute damages1 = damages1 * (klgns + 1) / 2.
    compute damages2 = .75 * damages1.
    if romulons > 0 and torps > 0
        display "*ROMULONS PRESENT IN QUADRANT*"
        display "Do you want to fire on them? "
        accept lst-reply
        if yes-lst
            perform 7350-romulon-ck thru 7350-exit
            go to 7300-exit.
    if torps > 0
        if klgns > 0
            if shield-cnt < 475 and no-way
                display "*ENTERPRISE DESTROYED*"
                display "Low shields at time of enemy attack "
                move 1 to indicate-x
                perform 8200-ck-done thru 8200-exit
                GO TO 7300-exit *> ????
            else
                if no-way and dist-x > 4
                    compute damages1 = damages1 / (dist-x / 10)
                    display "torpedo missed "
                    add damages1 to damage-cnt
                    subtract 1 from torps
                    subtract damages2 from shield-cnt
                    perform 4500-disp-hit thru 4500-exit
                    perform 8120-dam-com thru 8120-exit
                else
                    display "*KLINGON DESTROYED*"
            *>      subtract damages2 from damage-cnt     *> ???? why? At least why not damages1
                    perform 7201-replace thru 7201-exit
                        varying rep-ctr from 1 by 1 until rep-ctr > rx
                    inspect mini-table replacing first "K" by " "
                    inspect mini-table replacing all "x" by "K"
                    subtract 1 from torps
                    subtract 1 from klgns
                    subtract 1 from klingons
                    perform 5400-trans-back thru 5400-exit
                    if klgns > 0
                        add damages1 to damage-cnt
                        subtract damages2 from shield-cnt
                        perform 4500-disp-hit thru 4500-exit
                        perform 8120-dam-com thru 8120-exit
                    else
                        perform 8120-dam-com thru 8120-exit
        else
            display "There are 0 Klingon vessels in this quadrant, " name-x
    else
        display "0 torpedoes remaining, " name-x.
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
7300-exit.  exit.

7350-romulon-ck.
    if romulons > 1 and no-way
        display "*ENTERPRISE FIRING ON ROMULONS*"
        display "*ROMULONS RETURNING FIRE*"
        display "Simultaneous hits from " romulons " Romulons "
        display "*ENTERPRISE DESTROYED*"
        move 1 to indicate-x
        perform 8200-ck-done thru 8200-exit
        GO TO 7350-exit *> ????
    else
        display "*ENTERPRISE FIRING ON ROMULONS*"
        subtract 1 from torps
        if no-way and dist-r > 4
            display "torpedo missed "
            display "*ROMULONS RETURNING FIRE*"
            perform 8400-generate thru 8400-exit *> Flip no-way and trap-vec on and off randomly.

            if no-way and shield-cnt < 4000
                display "*ENTERPRISE DESTROYED BY ROMULON TORPEDO*"
                move 1 to indicate-x
                perform 8200-ck-done thru 8200-exit
                GO TO 7350-exit *> ????
            else
                compute damages1 = 3 * damages1 / (dist-r / 10)
                add damages1 to damage-cnt
                compute damages2 = damages1 / 2
                subtract damages2 from shield-cnt
                perform 4500-disp-hit thru 4500-exit
        else
            display "*ROMULON DESTROYED*"
            perform 7202-replace thru 7202-exit
                varying rep-ctr from 1 by 1 until rep-ctr > qx
            inspect mini-table replacing first "R" by " "
            inspect mini-table replacing all "x" by "R"
            subtract 1 from romulons
            perform 5400-trans-back thru 5400-exit.
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
7350-exit.  exit.

7400-status-rpt.
    compute damages2 = (damage-cnt / 60).
    move damages2 to number-ed2.
    move fuel-count to fuel-ed.
    move shield-cnt to shield-ed.
    display "      ".
    display "FUEL UNITS   DAMAGE ".
    display "REMAINING    LEVEL  ".
    display "      ".
    display "   " fuel-ed "  " number-ed2 "%".
    display "      ".
    display "===================".
    display "      ".
    display " PHOTON      SHIELD ".
    display "TORPEDOES    LEVEL ".
    display "      ".
    display "    " torps "         " shield-ed.
    display "      ".
    perform 8100-dmg-com thru 8100-exit.
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
7400-exit.  exit.

7500-def.
    add shield-cnt to fuel-count. *> put back unused shield power
    MOVE shield-cnt to shield-ed.                    *> ???
    DISPLAY "Current shield level is " shield-ed.    *> ???
    display "How many units to shields (0 - 9999)? ".
    perform 7520-accept-shield-cnt thru 7520-exit.
    if shield-cnt < fuel-count
        subtract shield-cnt from fuel-count
    else
        move fuel-count to fuel-ed
        display "Maximum amount to shields: " fuel-ed
        display "How many units to shields? "
        perform 7520-accept-shield-cnt thru 7520-exit
        subtract shield-cnt from fuel-count.
    move shield-cnt to shield-ed.
    display "Shields at " shield-ed " per your command ".
7500-exit.  exit.

7520-accept-shield-cnt.
    accept shield-cnt-an.
    move 0 to shield-blanks.
    inspect shield-cnt-an tallying shield-blanks for all " ".
    inspect shield-cnt-an replacing all " " by zeros.
    if shield-cnt-an not numeric
        move 0 to shield-blanks
        display "INVALID - Entry must be numeric "
        display "How many units to shields? "
        accept shield-cnt-an
        inspect shield-cnt-an tallying shield-blanks for all " "
        inspect shield-cnt-an replacing all " " by zeros
        if shield-cnt-an not numeric
            move 0 to shield-cnt
            go to 7520-exit.
    move shield-cnt-an to shield-cnt.
    if shield-blanks > 0
        compute shield-cnt = shield-cnt / (10 ** shield-blanks).
7520-exit.  exit.

7600-doc.
    IF BYE-BYE 
       DISPLAY "*UNSUCCESSFUL DOCKING ATTEMPT* "
       DISPLAY "*Enterprise dammaged beyond repair"
       GO TO 7600-exit.
    perform 8400-generate thru 8400-exit. *> Flip no-way and trap-vec on and off randomly.
    if base-cnt > 0
        perform 7220-compute-dist thru 7220-exit
        if dist-b < 7
            if no-way
                display "*UNSUCCESSFUL DOCKING ATTEMPT* "
                display "Star base reports all bays in use "
                perform 8100-dmg-com thru 8100-exit
            else
                display "Shields dropped to dock at star base "
                display "*DOCK SUCCESSFUL* "
                move 5 to torps
                MOVE INITIAL-TORPS TO torps            *> ??? OUTRAGIOUS AMOUNT WHEN TESTING
                PERFORM 7610-REFUEL THRU 7610-EXIT     *> ??? My Idea
                DISPLAY "Damage control reports repairs to ship complete." *> ???
                DISPLAY "Ship and crew ready for departure"                *> ???
                move 0 to damage-cnt
                move 0 to shield-cnt
        else
            display "The nearest star base is " dist-b " parsecs "
            display "You must maneuver to within 6 parsecs to dock "
    else
        display "There are 0 star bases in this quadrant, " name-x.
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
7600-exit.  exit.

7610-REFUEL.
    ADD shield-cnt TO fuel-count.
    move 0 to shield-cnt.
    IF TEST-PLAY                              *> ??? FILL UP FUEL WHEN TESTING
       MOVE INITIAL-FUEL-COUNT TO FUEL-COUNT. *> ??? THIS IS 40,000
    IF (fuel-count + 25000) < 40000
       ADD 25000 TO FUEL-COUNT
       DISPLAY "*25,000 units of deuterium taken onboard.*"
       DISPLAY "*Dilithium crystals supply is sufficient.*"
       GO TO 7610-EXIT.
    IF (fuel-count + 25000) > 40000 
       MOVE 40000 TO FUEL-COUNT
       DISPLAY "*Maximum units of deuterium taken onboard.*"
       DISPLAY "*Dilithium crystals supply is sufficient. *"
       GO TO 7610-EXIT.
7610-EXIT. EXIT.

7650-trans-star.
    if quad1 = 1
        move 2 to q9
    else
        if quad1 = 9
            move 8 to q9
        else
            move quad1 to q9.
    if quad2 = 1
        move 2 to r9
    else
        if quad2 = 9
            move 8 to r9
        else
            move quad2 to r9.
    compute w-idx = (q9 - 2) * 14.
    compute z-idx = (r9 - 2) * 14.
    perform 7670-strans thru 7670-exit
        varying rctr from 1 by 1 until rctr > 42
        after kctr from 1 by 1 until kctr > 42.
7650-exit.  exit.

7670-strans.
    compute a-idx = z-idx + rctr.
    compute b-idx = w-idx + kctr.
    move macol (a-idx , b-idx) to kolumn (rctr , kctr).
7670-exit.  exit.

7700-lrs.                                    *> Long Range Scan
    perform 7650-trans-star thru 7650-exit.
    move zeros to scan-keep.
    move 0 to scan-ctr.
    if quad1 = 1
        move 1 to qt1
        move 3 to qt3
    else
        if quad1 = 9
            move 7 to qt1
            move 9 to qt3
        else
            compute qt1 = quad1 - 1
            compute qt3 = quad1 + 1.
    if quad2 = 1
        move 1 to qt2
        move 3 to qt4
    else
        if quad2 = 9
            move 7 to qt2
            move 9 to qt4
        else
            compute qt2 = quad2 - 1
            compute qt4 = quad2 + 1.
    perform 7730-trade-tbl thru 7730-exit
        varying tr2 from 0 by 1 until tr2 > 2
        after tr1 from 0 by 1 until tr1 > 2.
    display "      ".
    display "====" qt1 "===============" qt3 "====".
    display "=       =       =       =".
    display "= " cv (1) "," cv (2) " = " cv (3) "," cv (4) " = " cv (5) "," cv (6) " = ".
    display "=       =       =       =".
    display "=========================".
    display "=       =       =       =".
    display "= " cv (7) "," cv (8) " = " cv (9) "," cv (10) " = " cv (11) "," cv (12) " =".
    display "=       =       =       =".
    display "=========================".
    display "=       =       =       =".
    display "= " cv (13) "," cv (14) " = " cv (15) "," cv (16) " = " cv (17) "," cv (18) " =".
    display "=       =       =       =".
    display "=========================".
    display "KEY: ".
    display "Quadrants " qt1 "," qt2 " thru " qt3 "," qt4.
    display "Format - KLINGONS,STAR BASES ".
    if quad1 = 1 or quad1 = 9 or quad2 = 1 or quad2 = 9
        display "*ENTERPRISE ON GALACTIC BOUNDARY*".
    display "Enterprise in quadrant " quad1 "," quad2.
    display "      ".
    perform 8100-dmg-com thru 8100-exit.
    perform 8300-ck-fuel-damage thru 8300-exit.
    perform 8200-ck-done thru 8200-exit.
7700-exit.  exit.

7730-trade-tbl.
    compute qt = (tr1 * 14).
    compute rt = (tr2 * 14).
    perform 7750-trade-act thru 7750-exit
        varying ktctr from 1 by 1 until ktctr > 14
        after rtctr from 1 by 1 until rtctr > 14.
    perform 7770-inspect-scan thru 7770-exit.
7730-exit.  exit.

7750-trade-act.
    compute qx = qt + ktctr.
    compute rx = rt + rtctr.
    move kolumn (rx , qx) to scan-col (rtctr , ktctr).
7750-exit.  exit.

7770-inspect-scan.
    add 1 to scan-ctr.
    inspect scan-table tallying cv (scan-ctr) for all "K".
    add 1 to scan-ctr.
    inspect scan-table tallying cv (scan-ctr) for all "B".
7770-exit.  exit.

7800-int.                  *> intelligence report
    if klingons > 0
        move 1 to row-idx
        move 1 to col-idx
        perform 7850-search thru 7850-exit
            until macol (row-idx , col-idx) = "K" or col-idx > 126
        compute row-idx-1 = (col-idx - 1) / 14 + 1
        compute col-idx-1 = (row-idx - 1) / 14 + 1
        display " "
        display "Latest intelligence gathering reports "
        display "indicate 1 or more Klingon vessels "
        display "in the vicinity of quadrant " row-idx-1 "," col-idx-1
        display " "
        display "Enterprise in quadrant " quad1 "," quad2
        DISPLAY "HEADQUARTERS IS IN QUARRENT " headquarters1 "," headquarters2  *> ???
        display " ".
7800-exit.  exit.

7850-search.
    add 1 to row-idx.
    if row-idx > 126
        add 1 to col-idx
        move 1 to row-idx.
7850-exit.  exit.

8000-bomb.
    if macol (mrctr , mkctr) = "K"
        display "*ENTERPRISE DESTROYED IN COLLISION WITH KLINGON*"
    else
        if macol (mrctr , mkctr) = "R"
            display "*ENTERPRISE DESTROYED IN COLLISION WITH ROMULON*"
        else
            if macol (mrctr , mkctr) = "H"   *> ??? added "H"
                display "*ENTERPRISE DESTROYED IN COLLISION WITH HEADQUARTERS*"
            else
                display "*ENTERPRISE DESTROYED IN COLLISION WITH STAR BASE*".
    move 1 to indicate-x.
    perform 8200-ck-done thru 8200-exit.
8000-exit.  exit.

*>***************************************************
*> 8100-dmg-com and 8120-dam-com calculate and dis- *
*> play hits on the enterprise from enemy vessels   *
*> in quadrant.  --  Called following possible con- *
*> tact with enemy vessels.                         *
*>***************************************************

8100-dmg-com.
    IF BYE-BYE GO TO 8100-EXIT.  *> ??? ADDED, DON'T DO IF ENTERPRISE IS DESTROYED.
    if klgns > 0
        compute damages1 = (total-klingons - klingons) * klgns * fuel-count / (shield-cnt + 21)
        perform 8150-test-agn thru 8150-exit
        compute damages2 = .75 * damages1
        display "*ENTERPRISE ENCOUNTERING KLINGON FIRE*"
        add damages1 to damage-cnt
        subtract damages2 from shield-cnt
        perform 4500-disp-hit thru 4500-exit.
8100-exit.  exit.

8120-dam-com.
    IF BYE-BYE GO TO 8120-EXIT.  *> ??? ADDED, DON'T DO IF ENTERPRISE IS DESTROYED.
    if romulons > 0
        compute damages1 = romulons * fuel-count / (shield-cnt + 7)
        perform 8160-test-agn thru 8160-exit
        compute damages2 = .75 * damages1
        display "*ENTERPRISE ENCOUNTERING ROMULON FIRE*"
        add damages1 to damage-cnt
        subtract damages2 from shield-cnt
        perform 4500-disp-hit thru 4500-exit.
8120-exit.  exit.

8150-test-agn.
    if damages1 < 325 and klgns > 0
        add 177 to damages1
        compute damages1 = (klgns * damages1 / 2.7) + (damages1 * damage-cnt / 980).
8150-exit.  exit.

8160-test-agn.
    if damages1 < 525 and romulons > 0
        add 254 to damages1
        compute damages1 = (romulons * damages1 / 4.7) + (damages1 * damage-cnt / 365).
8160-exit.  exit.

8200-ck-done.
    IF BEEN-HERE-BEFORE           *> ??? IF WE DISPLAYED THIS ALREADY, EXIT.
       GO TO 8200-EXIT.           *> ???
    if bye-bye                    *> ??? IF ENTERPRISE DESTROYED
       MOVE 1 TO INDICATE-XX      *> ??? TURN ON BEEN-HERE-BEFORE 1 TIME SWITCH
       DISPLAY "Bye-Bye".         *> ??? AND DISPLAY BYE-BYE.
    GO TO 8200-EXIT.              *> ???

    if bye-bye          *>???? to put this back to origional, delete the above
       go to 2000-exit. *>???? to put this back, delete the above
8200-exit.  exit.

*>************************************************
*> 8300-ck-fuel-damage checks and notifies the   *
*> user of low shields, low fuel reserves, or    *
*> high damage to the ship, in order that he may *
*> attempt to dock before the enterprise is      *
*> disabled.   --  Called following possible     *
*> contact with enemy vessels.                   *
*>************************************************

8300-ck-fuel-damage.
    IF BYE-BYE GO TO 8300-EXIT.  *> ??? DON'T REPORT AFTER ENTERPRISE DESTROYED.
    if fuel-count < 4500 and fuel-count > 0
        display "Lt. Scott reports fuel is running low, " name-x
    else
        if fuel-count not > 0
            display "Fuel reserves depleted "
            display "the Enterprise is drifting in space "
            perform 8350-ck-shift thru 8350-exit.
    compute number-ed3 = (damage-cnt / 60). *> The % of damages sustainable before destruction.
    if damage-cnt > 6000
        display "Enterprise stranded because of heavy damage to warp drive."
        move 1 to indicate-x
        perform 8200-ck-done thru 8200-exit
        GO TO 8300-EXIT.  *>  ??? Added to skip redundant displays when Enterprise destroyed.
    if damage-cnt > 4500
        display "Damage Control reports heavy damage to Enterprise, " name-x
        display "Enterprise at " number-ed3 "% of maximum sustainable levels, captain " name-x.
    if damage-cnt > 3000 and damage-cnt < 4500
        display "Damage Control reports moderate damage to Enterprise, " name-x
        display "Enterprise at " number-ed3 "% of maximum sustainable levels, captain " name-x.
    if shield-cnt < 800 and (klgns > 0 or romulons > 0)
        display "Lt. Sulu reports shields dangerously low, " name-x.
8300-exit.  exit.

8340-ck-fl.
    if fuel-count not > 180
        display "*INSUFFICIENT FUEL TO CONTINUE*"
        perform 8350-ck-shift thru 8350-exit
        GO TO 8340-exit.                        *> ???? ADDED LIKE OTHER PLACES
   *>     go to 2000-exit.                      *> ????? NOT WISE. INDICATE-X WILL HANDLE THIS
8340-exit.  exit.

8350-ck-shift.
    if shield-cnt > 200
        display "Lt. Sulu advises you lower shields "
        display "to increase fuel supply, " name-x
    else
        move 1 to indicate-x
        perform 8200-ck-done thru 8200-exit.
8350-exit.  exit.

8400-generate.   *> Flip no-way and trap-vec on and off randomly.
    if random-no > 24
        move 0 to random-no.
    add 1 to random-no.
    if char(random-no) numeric
        move 1 to genrte-result
    else
        move 0 to indicate-y
        move 0 to genrte-result
        if char (random-no) = "f"
            move 1 to indicate-y.
8400-exit.  exit.

8500-finish-game.
    display "      ".
    if bye-bye
        if star-date > ds-date
            move klingons to klingons-ed
            move ws-date to ds-date
            display "It is now star date " star-date
            display "STAR DATE " ds-date " Star Fleet HQ"
            display "was destroyed by " klingons-ed " klingon vessels"
            display name-x " COURT MARTIALED"
        else
            COMPUTE klingons-destroyed = total-klingons - klingons                  *> ???
            DISPLAY klingons-destroyed " Klingons destroyed, " klingons " remain "  *> ???
            DISPLAY " "                                                             *> ???
            display name-x " COURT MARTIALED"
    else
        display "Congratulations on a job well done Captain. "
        display "The Federation is proud of you, " name-x
        DISPLAY "You and your crew have performed valiantly."       *> ???
        DISPLAY "Take shore leave then return to fight again.".     *> ???
    display "      ".
8500-exit.  exit.

9000-end-of-job-section. *> ??? section.
9000-end-of-job.
    display "      ".
    DISPLAY "Program at normal end.".          *> ???
    DISPLAY "Review your game now, then".      *> ???
    DISPLAY "Press [enter]".                   *> ???
    ACCEPT inst-reply.                         *> ???

9000-exit.  exit.
