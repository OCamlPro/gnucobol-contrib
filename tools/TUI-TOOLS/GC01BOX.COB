              >> SOURCE FORMAT IS FREE
       REPLACE ==:BCOL:== BY ==with BACKGROUND-COLOR==
               ==:FCOL:== BY      ==FOREGROUND-COLOR==.
ID DIVISION.
PROGRAM-ID. GC01BOX is initial.
*> ***********************************************************************************
*> GnuCOBOL TT (TUI TOOLS) COLLECTION
*> Purpose:    DISPLAY A BOX ON SCREEN WITH OPTIONS AND SPECIAL EFFECTS
*> Tectonics:  cobc -m GC01BOX.COB  -lpdcurses (compile with GnuCOBOL 3.1 or greater)
*> Usage:      call GC01BOX using BOX-AREA
*> Parameters: look at GC01BOX.CPY
*> Author:     Eugenio Di Lorenzo - Italia (DILO) - eugenio.dilo@gmail.com
*> License:    (c)2021 E.Di Lorenzo - GNU Lesser General Public License, LGPL, 3.0 (or greater)
*> Version:    2.0 2021.02.02
*> Changelog:  1.0 first release.
*>             2.0 now you can use also colors from 8 to 15 (see GC00COLORS.CPY)
*> ***********************************************************************************
DATA DIVISION.
WORKING-STORAGE SECTION.
copy GC00COLORS.CPY.

01  wInt        BINARY-SHORT.
01  wChar   pic x  value space.
01  i    pic 999.
01  j    pic 999.
01  k    pic 999.
01  w    pic 999.
01  t    pic 999.
01  L    pic X(09) VALUE SPACE.
01  wTitleCol    pic 999.
01  wBox-bco     pic 9(02) value 07.
01  wBox-fco     pic 9(02) value 07.
01  wBox-titbco  pic 9(02) value 07.
01  wBox-titfco  pic 9(02) value 07.

01  BOX-CHARS.  *> UpLeft, UpCenter, UpRight, MiwCharleLeft, MC, MR, LowLeft, LC, LR
   *> DA C4 BF  SINGLE LINE BOX
   *> B3 20 B3
   *> C0 C4 D9
   03 LS PIC X(09) VALUE X"DA" & X"C4" & X"BF" & X"B3" & X"20" & X"B3" & X"C0" & X"C4" & X"D9".
   *> C9 CD BB  DOUBLE LINE BOX
   *> BA 20 BA
   *> C8 CD BC
   03 LD PIC X(09) VALUE X"C9" & X"CD" & X"BB" & X"BA" & X"20" & X"BA" & X"C8" & X"CD" & X"BC".
   *> +  -  +   BOX WITH CHARACHTER (NON GRAPHIC) - TIPE 1
   *> |     |
   *> +  -  +
   03 L1 PIC X(09) VALUE   "+" &  "-" &  "+" &  "|" &  " " &  "|" &  "+" &  "-" &  "+".
   *> .  -  .   BOX WITH CHARACHTER (NON GRAPHIC) - TIPE 2
   *> |     |
   *> '  -  '
   03 L2 PIC X(09) VALUE   "." &  "-" &  "." &  "|" &  " " &  "|" &  "'" &  "-" &  "'".
   *> X  X  X   BOX WITH SOLID BORDERS - TIPE 3
   *> X     X
   *> X  X  X
   03 L3 PIC X(09) VALUE  X"DB" &  X"DB" &  X"DB" &  X"DB"  &  " " &  X"DB" &  X"DB" &  X"DB" &  X"DB".
   *> BOX WITH NO LINE  - USEFUL FOR COLOURING AREAS ON VIDEO
   03 LX PIC X(09) VALUE   SPACE.


LINKAGE SECTION.
copy 'GC01BOX.CPY'.

*> ***********************************************************************************
*>           P R O C E D U R E   D I V I S I O N
*> ***********************************************************************************
PROCEDURE DIVISION using Box-Area.
*> sets in order to detect the PgUp, PgDn, PrtSc(screen print), Esc keys,
set environment 'COB_SCREEN_EXCEPTIONS' TO 'Y'.
set environment 'COB_SCREEN_ESC'        TO 'Y'.

if box-beep = 'Y' CALL X"E5"  END-IF *> ring the bell

evaluate true
   when Box-style = "S" move LS         to L  *> single line box
   when Box-style = "D" move LD         to L  *> double line box
   when Box-style = "C" move Box-custom to L  *> custom line box
   when Box-style = "N" move LX         to L  *> no line box (for painting an area)
   when Box-style = "1" move L1         to L  *> line char 1
   when Box-style = "2" move L2         to L  *> line char 2
   when Box-style = "3" move L3         to L  *> line char 3 (a solid frame)
end-evaluate

if Box-3D = "N"
*> ***********************************************************************************
*> DISPLAY A NORMAL BOX (NOT 3D)
*> ***********************************************************************************
 perform varying i from box-r1 by 1 until i > box-r2         *> write rows
   perform varying j from box-c1 by 1 until j > box-c2       *> write cols
     evaluate true
       *> 1st box row
       when i = box-r1 and j = box-c1                  move L(1:1) to wChar          *> upper left corner
       when i = box-r1 and (j > box-c1 and j < box-c2) move L(2:1) to wChar          *> upper horizontal line
       when i = box-r1 and j = box-c2                  move L(3:1) to wChar          *> upper right corner

       *> intermediate rows
       when (i > box-r1 and i < box-r2) and j = box-c1 move L(4:1) to wChar          *> left vertical line
       when (i > box-r1 and i < box-r2) and (j > box-c1 and j < box-c2)              *> box fill character
             if Box-fill = "Y" move L(5:1) to wChar  else exit perform cycle end-if
       when (i > box-r1 and i < box-r2) and j = box-c2                               *> right vertical line
                 *> display a shadow a right of the box if requested
                 if box-shadow = "Y" compute k = j + 1 end-compute
                    display X"DB" at line i col k :BCOL: black :FCOL: black end-display
                 end-if
                                                       move L(6:1) to wChar
       *> last box row
       when i = box-r2 and j = box-c1                  move L(7:1) to wChar           *> lower left corner
       when i = box-r2 and (j > box-c1 and j < box-c2) move L(8:1) to wChar           *> lower horizontal line
       when i = box-r2 and j = box-c2                                                 *> lower right corner
                  *> display a shadow a right of the box if requested
                  if box-shadow = "Y" compute k = j + 1 end-compute
                   display X"DB" at line i col k :BCOL: black :FCOL: black end-display
                 end-if
                                                       move L(9:1) to wChar
     end-evaluate

     perform DisplayChar thru DisplayCharEx

   end-perform
 end-perform

else
*> ***********************************************************************************
*> DISPLAY A 3D BOX (frame colors are always black & white)
*> ***********************************************************************************
 perform   varying i from box-r1 by 1 until i > box-r2       *> write rows
   perform varying j from box-c1 by 1 until j > box-c2       *> write cols
     evaluate true
       *> 1st box row
       when i = box-r1 and j = box-c1          move L(1:1) to wChar          *> upper left corner
                               if Box-3D = "R" move black to box-fco end-if
                               if Box-3D = "E" move white to box-fco end-if
       when i = box-r1 and (j > box-c1 and j < box-c2) move L(2:1) to wChar  *> upper horizontal line
                               if Box-3D = "R" move black to box-fco end-if
                               if Box-3D = "E" move white to box-fco end-if
       when i = box-r1 and j = box-c2          move L(3:1) to wChar          *> upper right corner
                               if Box-3D = "R" move black to box-fco end-if
                               if Box-3D = "E" move white to box-fco end-if

       *> intermediate rows
       when (i > box-r1 and i < box-r2) and j = box-c1                  move L(4:1) to wChar *> left vertical line
                               if Box-3D = "R" move black to box-fco end-if
                               if Box-3D = "E" move white to box-fco end-if
       when (i > box-r1 and i < box-r2) and (j > box-c1 and j < box-c2)                   *> box fill character
             if Box-fill = "Y" move L(5:1) to wChar  else exit perform cycle end-if
       when (i > box-r1 and i < box-r2) and j = box-c2                                    *> right vertical line
                                *> display a shadow a right of the box if requested
                                if box-shadow = "Y" compute k = j + 1 end-compute
                                   display X"DB" at line i col k :BCOL: black :FCOL: black end-display
                                end-if
                                                                        move L(6:1) to wChar
                               if Box-3D = "R" move white to box-fco end-if
                               if Box-3D = "E" move black to box-fco end-if

       *> last box row
       when i = box-r2 and j = box-c1                  move L(7:1) to wChar           *> lower left corner
                               if Box-3D = "R" move black to box-fco end-if
                               if Box-3D = "E" move white to box-fco end-if
       when i = box-r2 and (j > box-c1 and j < box-c2) move L(8:1) to wChar            *> lower horizontal line
                               if Box-3D = "R" move white to box-fco end-if
                               if Box-3D = "E" move black to box-fco end-if
       when i = box-r2 and j = box-c2                                               *> lower right corner
                                                                    move L(9:1) to wChar
                               *> display a shadow a right of the box if requested
                               if box-shadow = "Y" compute k = j + 1 end-compute
                                  display X"DB" at line i col k :BCOL: black :FCOL: black end-display
                               end-if
                               if Box-3D = "R" move white to box-fco end-if
                               if Box-3D = "E" move black to box-fco end-if
     end-evaluate

     if box-fco = 7 *> display with highlight only if fore color is white (no highlight if black)
        display wChar at line i col j :BCOL: box-bco :FCOL: box-fco highlight end-display
     else
        display wChar at line i col j :BCOL: box-bco :FCOL: box-fco end-display
     end-if

   end-perform
 end-perform

end-if

*> ***********************************************************************************
*> IF REQUESTED DISPLAY THE SHADOW AT BOTTOM OF THE BOX
*> ***********************************************************************************
if box-shadow = "Y" compute k = box-r2 + 1 end-compute  compute w = box-c1 + 1 end-compute
   perform varying j from w by 1 until j > box-c2 + 1       *> write cols
      display X"DB" at line k col j :BCOL: black :FCOL: black end-display
   end-perform
end-if

*> ***********************************************************************************
*> IF REQUESTED DISPLAY A BOX TITLE
*> ***********************************************************************************
if Box-tit = "Y" go to TitleCount else go to TitleDisplayEx end-if
move 0 to t.

*> loop to count characters of title t= number of title chars to display title centered
TitleCount.
     add 1 to t
     if Box-titDes(t:1) = low-value go TitleCountEx else go to TitleCount end-if.
TitleCountEx.
     compute wTitleCol = Box-c1 + ((Box-c2 - Box-c1) / 2)  - (t / 2)     end-compute.
     move 0 to t.

TitleDisplayLoop.
     add 1 to wTitleCol
     add 1 to t
     if Box-titDes(t:1) = low-value go to TitleDisplayEx end-if.
     perform DisplayCharTitle thru DisplayCharTitleEx
     go TitleDisplayLoop.
TitleDisplayEx.

GOBACK.

*> ***********************************************************************************
*>
*> ***********************************************************************************
DisplayChar.
  evaluate true
     when box-bco > 7 and box-fco >  7
         compute wbox-bco = box-bco - 8
         compute wbox-fco = box-fco - 8
         display wChar at line i col j :BCOL: wbox-bco :FCOL: wbox-fco blink highlight
     when box-bco > 7 and box-fco <=  7
         compute wbox-bco = box-bco - 8
         compute wbox-fco = box-fco
         display wChar at line i col j :BCOL: wbox-bco :FCOL: wbox-fco blink
     when box-bco <= 7 and box-fco >  7
         compute wbox-bco = box-bco
         compute wbox-fco = box-fco - 8
         display wChar at line i col j :BCOL: wbox-bco :FCOL: wbox-fco highlight
     when box-bco <= 7 and box-fco <=  7
         compute wbox-bco = box-bco
         compute wbox-fco = box-fco
         display wChar at line i col j :BCOL: wbox-bco :FCOL: wbox-fco
  end-evaluate
  continue.
DisplayCharEx. exit.

DisplayCharTitle.
  evaluate true
     when box-titbco > 7 and box-titfco >  7
         compute wbox-titbco = box-titbco - 8
         compute wbox-titfco = box-titfco - 8
         display Box-TitDes(t:1) at line Box-r1 col wTitleCol :BCOL: wbox-titbco :FCOL: wbox-titfco blink highlight
     when box-titbco > 7 and box-titfco <=  7
         compute wbox-titbco = box-titbco - 8
         compute wbox-titfco = box-titfco
         display Box-TitDes(t:1) at line Box-r1 col wTitleCol :BCOL: wbox-titbco :FCOL: wbox-titfco blink
     when box-titbco <= 7 and box-titfco >  7
         compute wbox-titbco = box-titbco
         compute wbox-titfco = box-titfco - 8
         display Box-TitDes(t:1) at line Box-r1 col wTitleCol :BCOL: wbox-titbco :FCOL: wbox-titfco highlight
     when box-titbco <= 7 and box-titfco <=  7
         compute wbox-titbco = box-titbco
         compute wbox-titfco = box-titfco
         display Box-TitDes(t:1) at line Box-r1 col wTitleCol :BCOL: wbox-titbco :FCOL: wbox-titfco
  end-evaluate
  continue.
DisplayCharTitleEx. exit.

End Program GC01BOX.
