*>******************************************************************************
*>  cobjapichart.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  cobjapichart.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with cobjapichart.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>   *************************************** Author: Giancarlo Canini **************************************************
*>   *************************************** Date written: 28/04/2023 **************************************************
*>   ******************************************* cobjapichart.cob ******************************************************
*>   ************************************ Draw a Line, Bar, or Pie Chart ***********************************************
*>   *******************************************************************************************************************
*>   This program draws a line, bar, or pie chart by reading the input file called "chardata.dat". 
*>   The "chartdata.dat" file cannot contain more than 12 records formed by two fields: 
*>   1) pic x(12) (title chart)
*>   2) pic 9(8)  (numeric data chart, max 50,000,000)
*>   There is also an initial record (the first) 
*>   in which the description of the pic x(12) graph must be entered in the first field 
*>   (for example "Population") 
*>   and the type of pic 9(8) graph must be entered in the second field 
*>   (for example "00000001 " to draw a line graph, "00000002" to draw a bar graph, or "00000003" to draw a pie graph).
*>   *******************************************************************************************************************
*>   *******************************************************************************************************************
*>   -------------------------------------------------------------------------------------------------------------------
*>   Tectonics:
*>   ...on Windows...
*>   cobc -x -free -lws2_32 -o cobjapichart.exe cobjapichart.cob cobjapi.o japilib.o imageio.o fileselect.o
*>   ...on Linux...
*>   cobc -x -free -o cobjapichart cobjapichart.cob cobjapi.o japilib.o imageio.o fileselect.o
*>   -------------------------------------------------------------------------------------------------------------------
*>   *******************************************************************************************************************
 
 identification division.
 program-id. cobjapichart.
 
 environment division.
 configuration section.
 repository.
     function all intrinsic
     copy "CobjapiFunctions.cpy".

 input-output section.
 file-control.
     select chartdata    
         assign to disk  "chartdata.dat"
         organization is line sequential.

 data division.
 file section.
 fd  chartdata.
 01  chartrecord.
     02  chartx              pic x(12).
     02  charty              pic 9(8).
         
 working-storage section.
 copy "CobjapiConstants.cpy".
 77  fine                    pic x       value "n".
 77  xstep                   pic 9(4).
 77  numbery                 pic z(8).       
 77  alert                   pic 9       value 0.
 77  etichetta               pic x(30).
 77  totalpie                pic 9(10)   value 0.

 01  fileinfo.
     02  filesizeinbytes     pic 9(18)   comp.
     02  yyyymmdd            pic 9(8)    comp. 
     02  hhmmss00            pic 9(8)    comp.

 01  wschartrecord           occurs 14   times.
     02  wschartx            pic x(12).
     02  wscharty            pic 9(8)    value 1. 

 01  nullo                   binary-long.
 01  telaio                  binary-long.
 01  tela                    binary-long.
 01  azione                  binary-long.
 01  immagine                binary-long.
 01  larghezza               binary-long.
 01  altezza                 binary-long.
 01  x1                      binary-long value 0.
 01  y1                      binary-long value 0.
 01  y1save                  binary-long.
 01  x2                      binary-long.
 01  x2save                  binary-long.
 01  y2                      binary-long.
 01  y2save                  binary-long.
 01  arcx1                   binary-long value 480.
 01  arcy1                   binary-long value 340.
 01  arcx2                   binary-long value 220.
 01  arcy2                   binary-long value 180.
 01  arco1                   binary-long value 0.
 01  arco2                   binary-long value 0.
 01  pulsante                binary-long.
 01  filelength              binary-long value 1.
 01  savefilelength          binary-long.
 01  fontsize                binary-long.
 01  millisecondi            binary-long value 10000.

 procedure division.
 main section.
     call "CBL_CHECK_FILE_EXIST"   
         using       "chartdata.dat", fileinfo
         returning   return-code 
     end-call

     if  return-code = 0
         open input chartdata
         perform until fine is equal to "y"
             read chartdata at end move "y" to fine
             end-read
             if  fine is not equal to "y"
                 move chartrecord to wschartrecord(filelength)
                 compute totalpie = totalpie + charty
                 add 1 to filelength
                 if  charty > 50000000
                     move 1 to alert
                 end-if
             end-if
             if  filelength > 14
                 move "y" to fine
                 move 2 to alert
             end-if
         end-perform
         close chartdata
     else 
         display "The 'chartdata.dat' file does not exist. Create the file with two fields: " & x"0a" &
                 "1) the first field must contain a string pic x(12); " & x"0a" &
                 "2) the second field must contain a pic 9(8) number not exceeding 50,000,000. " & x"0a" &
                 "The 'chartdata.dat' file cannot contain more than 12 data records. " & x"0a" &
                 "The description x(12) must be entered in the first field of the first record of the file, " & x"0a" &
                 "00000001 can be entered in the second field of the first record to draw a line chart, " & x"0a" &
                 "00000002 can be entered in the second field of the first record to draw a bar chart, " & x"0a" &
                 "00000003 can be entered in the second field of the first record to draw a pie chart."
         move 3 to alert
     end-if

     if  wscharty(1) is not equal to 1 and wscharty(1) is not equal to 2
         and wscharty(1) is not equal to 3
         move 4 to alert
     end-if

     move j-start() to nullo
     move j-loadimage("struttura.jpg") to immagine
     move j-getwidth(immagine) to larghezza
     move j-getheight(immagine) to altezza
     move j-frame(wschartx(1)) to telaio
     move j-canvas(telaio, larghezza, altezza) to tela
     move j-drawimage(tela, immagine, x1, y1) to nullo
     move j-button(telaio, "Draw Chart") to pulsante
     move j-setnamedcolor(tela, j-yellow) to nullo
     move 20 to x1
     move 40 to y1
     move "Click above" to etichetta
     move j-drawstring(tela, x1, y1, etichetta) to nullo

     move j-pack(telaio) to nullo
     move j-show(telaio) to nullo
     
     move filelength to savefilelength
     
     compute xstep = 300 / (filelength - 2)
     
     move 50 to fontsize    
     move j-setfontsize(tela, fontsize) to nullo
     move j-setnamedcolor(tela, j-black) to nullo
     move 120 to x1
     move 50  to y1

     evaluate wscharty(1)
         when 1
             move concatenate(wschartx(1) " Line Chart") to etichetta
             subtract 1 from totalpie
         when 2
             move concatenate(wschartx(1) " Bar Chart") to etichetta
             subtract 2 from totalpie
         when 3
             move concatenate(wschartx(1) " Pie Chart") to etichetta
             subtract 3 from totalpie              
     end-evaluate

     move j-drawstring(tela, x1, y1, etichetta) to nullo

     if  wscharty(1) = 3
         move 14 to fontsize    
         move j-setfontsize(tela, fontsize) to nullo
     else
         move 8 to fontsize    
         move j-setfontsize(tela, fontsize) to nullo
     end-if

     perform forever
         move j-nextaction() to azione
         if  azione = telaio 
             exit perform
         end-if
         move 100 to x2
         
         if  azione = pulsante
             move 100 to y2save
             if  filelength is not equal to 1 and filelength is less than 15 and 
                 alert is not equal to 1 and alert is not equal to 2 
                 and alert is not equal to 3 and alert is not equal to 4
                 perform varying filelength from 2 by 1 until filelength = savefilelength
                     move j-setnamedcolor(tela, filelength) to nullo
                     move 660 to y1
                     move 720 to y2
                     compute y1 = y1 - (wscharty(filelength) / 80000)
                     compute y1 = y1 + 20
                     move wscharty(filelength) to numbery
                     if  wscharty(1) <> 3
                         move j-drawstring(tela, x2, y1, numbery) to nullo
                         move j-drawstring(tela, x2, y2, wschartx(filelength)) to nullo
                     else 
                         move 100 to x2
                         move y2save to y1save
                         move j-drawstring(tela, x2, y1save, numbery) to nullo
                         subtract 20 from y1save                              
                         move j-drawstring(tela, x2, y1save, wschartx(filelength)) to nullo
                         add 100 to x2
                         move 20 to larghezza 
                         move 10 to altezza
                         move j-fillrect(tela ,x2, y1save, larghezza, altezza) to nullo
                         subtract 100 from x2
                         compute y2save = y1save + 72
                     end-if
                     compute y1 = y1 + 20
                     compute y2 = y2 - 20
                     evaluate wscharty(1)
                         when 1
                             if  filelength = 2
                                 move y1 to y1save
                                 move x2 to x2save
                             else    
                                 move j-drawline(tela, x2save, y1save, x2, y1) to nullo
                                 move y1 to y1save
                                 move x2 to x2save      
                             end-if
                             add 30 to x2
                         when 2 
                             perform 30 times 
                                 move j-drawline(tela, x2, y1, x2, y2) to nullo
                                 add 1 to x2
                             end-perform
                         when 3
                             compute arco1 = arco2 + 1 + wscharty(filelength) * 360 / totalpie
                             move j-fillarc(tela, arcx1, arcy1, arcx2, arcy2, arco1, arco2) to nullo
                             compute arco2 = arco1
                             add 30 to x2                                 
                     end-evaluate
                     add xstep to x2
                end-perform
             else if alert = 1
                 move j-messagebox(telaio,   "Attention!!!",
                                             "'chartdata.dat' cannot contain numeric fields > 50,000,000." & x"0a" &
                                             "Edit the file and try again." & x"0a" &
                                             "The program will be terminated in a few seconds!") 
                                             to nullo
                 move j-sleep(millisecondi)  to nullo
                 exit perform
             else if alert = 2
                 move j-messagebox(telaio,   "Attention!!!",
                                             "'chartdata.dat' cannot contain more than 12 records. " & x"0a" &
                                             "Modify the file and try again. " & x"0a" &
                                             "The program will be terminated in a few seconds!") 
                                             to nullo
                 move j-sleep(millisecondi)  to nullo
                 exit perform
             else if alert = 3
                 move j-messagebox(telaio,   "Attention!!!",
                                             "'chartdata.dat' does not exist!" & x"0a" &
                                             "Create the file according to the specifications described in the 'readme.txt' and try again." & x"0a" &
                                             "The program will be terminated in a few seconds!") 
                                             to nullo
                 move j-sleep(millisecondi)  to nullo
                 exit perform
             else if alert = 4
                 add 2000 to millisecondi
                 move j-messagebox(telaio,   "Attention!!!",
                                             "The second numeric field of the first record of 'chartdata.dat' must be" & x"0a" &
                                             "equal to 00000001 to draw a line chart, or" & x"0a" &
                                             "equal to 00000002 to draw a bar chart, or" & x"0a" &
                                             "equal to 00000003 to draw a pie chart." & x"0a" &
                                             "Modify the file and try again." & x"0a" & 
                                             "The program will be terminated in a few seconds!") 
                                             to nullo
                 move j-sleep(millisecondi)  to nullo
                 exit perform
             end-if           
         end-if    
     end-perform

     move j-quit() to nullo
 stop run.
         