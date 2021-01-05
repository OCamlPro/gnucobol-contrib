*>******************************************************************************
*>  10functionsfloat.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  10functionsfloat.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with 10functionsfloat.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>  *************************************** Author: Giancarlo Canini **************************************************
*>  ***************************************** 10functionsfloat.cob ****************************************************
*>  ******************************************* Disegna una retta *****************************************************
*>  *******************************************************************************************************************
*>  La funzione della retta (y = mx + q). Il programma chiede in input (m) e (q).
*>  Bisogna confermare ogni input col tasto INVIO. Si puo' passare tra un campo e l'altro con il tasto TAB.
*>  Il pulsante per disegnare la funzione si trova in alto a destra.
*>  *******************************************************************************************************************
*>  -------------------------------------------------------------------------------------------------------------------
*>  Tectonics:
*>  cobc -x -free -lws2_32 -o bin\10functionsfloat.exe 10functionsfloat.cob cobjapi.o japilib.o imageio.o fileselect.o
*>  ...on Linux...
*>  cobc -x -free -o bin/10functionsfloat 10functionsfloat.cob cobjapi.o japilib.o imageio.o fileselect.o
*>  -------------------------------------------------------------------------------------------------------------------

 identification division.
 program-id. 10functionsfloat.

 environment division.
 configuration section.
 repository.
     function all intrinsic
     copy "CobjapiFunctions.cpy".

 data division.
 working-storage section.
 copy "CobjapiConstants.cpy".

 01 nullo                       binary-long.
 01 telaio                      binary-long.
 01 tela                        binary-long.
 01 azione                      binary-long.
 01 immagine                    binary-long.
 01 larghezza                   binary-long.
 01 altezza                     binary-long.

 01 x1                          binary-long.
 01 y1                          binary-long.
 01 x2                          binary-long.
 01 y2                          binary-long.

 01 pulsante                    binary-long.

 01 campo1                      binary-long.
 01 campo2                      binary-long.
 01 campo3                      binary-long.
 01 campo4                      binary-long.

 01 caselle                     binary-long.
 01 millisecondi                binary-long.

 01 dati-campo1                 pic x(256).
 01 dati-campo2                 pic x(256).
 01 dati-campo3                 pic x(256).
 01 dati-campo4                 pic x(256).

 01 a                           pic s9(2)   value 0.
 01 b                           pic s9(2)   value 0.
 01 c                           pic s9(2)   value 1.
 01 d                           pic s9(2)   value 1.

 01 fx1                         pic s9(4).
 01 fy1                         pic s9(4).
 01 fx2                         pic s9(4).
 01 fy2                         pic s9(4).

 01 m                           pic s9(2)v9(2).
 01 q                           pic s9(2)v9(2).

 01 a-etichetta                 pic -9(1).
 01 b-etichetta                 pic -9(1).
 01 c-etichetta                 pic -9(1).
 01 d-etichetta                 pic -9(1).

 01 maschera                    pic x(30).
 01 input-prompt                pic x(1).

 01 alert                       pic 9(1)    value 0.

 01 etichetta                   pic x(30).

 01 save-position               pic 9(4)    value 60.
 01 switch-colonna              pic 9(1)    value 0.
 01 spazio-pieno                pic 9(1)    value 0.

 procedure division.
    move j-start() to nullo
    move j-loadimage("assi-cartesiani.jpg") to immagine
    move j-getwidth(immagine) to larghezza
    move j-getheight(immagine) to altezza
    move j-frame("Disegna la retta (y = mx + q). Scritto in GnuCOBOL ver. 3.2.1 (JAPI) da Giancarlo Canini") to telaio
    move j-canvas(telaio, larghezza, altezza) to tela
    move j-drawimage(tela, immagine, x1, y1) to nullo
    move j-button(telaio, "Disegna y = mx + q") to pulsante

    compute larghezza = larghezza / 2
    compute altezza = altezza / 2

    move j-setnamedcolor(tela, j-red) to nullo

    move 140 to x2
    move 20 to y2
    move j-drawstring(tela, x2, y2, "Premi INVIO su ogni campo per confermare l'INPUT") to nullo

    move j-setnamedcolor(tela, j-orange) to nullo

    move 140 to x2
    move 35 to y2
    move j-drawstring(tela, x2, y2, "Premi TAB o SHIFT+TAB per spostarti ") to nullo

    move 140 to x2
    move 50 to y2
    move j-drawstring(tela, x2, y2, "tra i campi e per disegnare la retta.") to nullo

    move j-setnamedcolor(tela, j-blue) to nullo

    move 415 to x2
    move 35 to y2
    move j-drawstring(tela, x2, y2, "Premi qui per disegnare --->") to nullo

    move 600 to x1
    move 20 to y1
    move j-setpos(pulsante, x1, y1) to nullo

    move j-setnamedcolor(tela, j-magenta) to nullo

    move 20 to x2
    move 40 to y2
    move j-drawstring(tela, x2, y2, "y = ") to nullo

    move "**" to maschera
    move "_" to input-prompt
    move 2 to caselle
    move j-formattedtextfield(telaio, maschera, input-prompt, caselle) to campo1
    move 48 to x1
    move 20 to y1
    move j-setpos(campo1, x1, y1) to nullo

    move "**" to maschera
    move "_" to input-prompt
    move 2 to caselle
    move j-formattedtextfield(telaio, maschera, input-prompt, caselle) to campo2
    move 110 to x1
    move 20 to y1
    move j-setpos(campo2, x1, y1) to nullo

    move "**" to maschera
    move "_" to input-prompt
    move 2 to caselle
    move j-formattedtextfield(telaio, maschera, input-prompt, caselle) to campo3
    move 48 to x1
    move 40 to y1
    move j-setpos(campo3, x1, y1) to nullo

    move "**" to maschera
    move "_" to input-prompt
    move 2 to caselle

    move j-formattedtextfield(telaio, maschera, input-prompt, caselle) to campo4
    move 110 to x1
    move 40 to y1
    move j-setpos(campo4, x1, y1) to nullo

    move 75 to x2
    move 40 to y2
    move j-drawstring(tela, x2, y2, "x") to nullo

    move 90 to x2
    move 40 to y2
    move j-drawstring(tela, x2, y2, "+") to nullo

    move j-pack(telaio) to nullo
    move j-show(telaio) to nullo

    perform forever
        move j-nextaction() to azione

        move 0 to alert

        if azione = telaio or spazio-pieno = 1
           exit perform
        end-if

        if azione = campo1
            move j-gettext(campo1, dati-campo1) to nullo
            inspect dati-campo1 tallying alert  for all "à", "è", "ì", "ò", "ù", "°", "é", "^", "ç", "§"
            if alert >= 1
                move j-messagebox(telaio, "Attenzione !!!!!", "Non sono ammessi caratteri alfanumerici in questa funzione. "
                                & x"0a" & "Riprovate inserendo un numero. Il programma verra' chiuso!") to nullo
                move 8000 to millisecondi
                move j-sleep(millisecondi) to nullo
                exit perform
            end-if
            move trim(dati-campo1) to a
        end-if

        if azione = campo2
            move j-gettext(campo2, dati-campo2) to nullo
            inspect dati-campo2 tallying alert  for all "à", "è", "ì", "ò", "ù", "°", "é", "^", "ç", "§"
            if alert >= 1
                move j-messagebox(telaio, "Attenzione !!!!!", "Non sono ammessi caratteri alfanumerici in questa funzione. "
                                & x"0a" & "Riprovate inserendo un numero. Il programma verra' chiuso!") to nullo
                move 8000 to millisecondi
                move j-sleep(millisecondi) to nullo
                exit perform
            end-if
            move trim(dati-campo2) to b
        end-if

        if azione = campo3
            move j-gettext(campo3, dati-campo3) to nullo
            inspect dati-campo3 tallying alert  for all "à", "è", "ì", "ò", "ù", "°", "é", "^", "ç", "§"
            if alert >= 1
                move j-messagebox(telaio, "Attenzione !!!!!", "Non sono ammessi caratteri alfanumerici in questa funzione. "
                                & x"0a" & "Riprovate inserendo un numero. Il programma verra' chiuso!") to nullo
                move 8000 to millisecondi
                move j-sleep(millisecondi) to nullo
                exit perform
            end-if
            move trim(dati-campo3) to c
        end-if

        if azione = campo4
            move j-gettext(campo4, dati-campo4) to nullo
            inspect dati-campo4 tallying alert  for all "à", "è", "ì", "ò", "ù", "°", "é", "^", "ç", "§"
            if alert >= 1
                move j-messagebox(telaio, "Attenzione !!!!!", "Non sono ammessi caratteri alfanumerici in questa funzione. "
                                & x"0a" & "Riprovate inserendo un numero. Il programma verra' chiuso!") to nullo
                move 8000 to millisecondi
                move j-sleep(millisecondi) to nullo
                exit perform
            end-if
            move trim(dati-campo4) to d
        end-if

        if azione = pulsante
            if (a > 9 or a < -9) or (c > 9 or c < -9)
                move 1 to alert
                move j-alertbox(telaio, "Attenzione al coefficiente angolare!",
                                        "Puoi inserire solo un numero compreso tra -9 e +9. "
                              & x"0A" & "Cancella e riscrivi confermando con INVIO.", "Ok") to nullo
            end-if
            if (b > 9 or b < -9) or (d > 9 or d < -9)
                move 1 to alert
                move j-alertbox(telaio, "Attenzione alla quota all'origine!",
                                        "Puoi inserire solo un numero compreso tra -9 e +9. "
                              & x"0A" & "Cancella e riscrivi confermando con INVIO.", "Ok") to nullo
            end-if
            if alert <> 1
                perform disegna-funzione
            end-if
        end-if
    end-perform

    move j-quit() to nullo

    stop run
    .

    disegna-funzione.
        if switch-colonna = 1
            move 720 to x2
        else
            move 20 to x2
        end-if

        compute y2 = save-position + 20

        if y2 = 400
            add 40 to y2
        end-if

        if y2 > 780
            add 620 to x2
            move 80 to y2
            move 1 to switch-colonna
        end-if

        if y2 = 780 and switch-colonna = 1
            move j-alertbox(telaio, "Spiacente...", "Spazio pieno. Sta per essere disegnata la funzione n.68! "
                          & x"0A" & "Il programma verra' chiuso", "Ok") to nullo
            move j-settext(pulsante, "Termina programma") to nullo
            move 1 to spazio-pieno
        end-if

        if switch-colonna = 1
            move 640 to x2
        end-if

        move a to a-etichetta
        move b to b-etichetta
        move c to c-etichetta
        move d to d-etichetta

        if a <> 0 and b <> 0 and c <> 0 and d <> 0
            compute m = a / c
            compute q = b / d
        else
            move 0 to m
            move 0 to q
            move j-alertbox(telaio, "Attenzione...", "Errore nell'input dei dati. Devi pulire i campi di inserimento con CANC o con  "
            & x"0A" & "BACKSPACE e i numeri devono essere allineati sulla sinistra del campo. Cancellare e riprovare", "Ok") to nullo
        end-if

        move j-setnamedcolor(tela, j-blue) to nullo
        move concatenate("y = (", a-etichetta, "/", c-etichetta, ") x  +  (", b-etichetta, "/", d-etichetta, ")") to etichetta
        move j-drawstring(tela, x2, y2, etichetta) to nullo

        evaluate q
            when >= 0
                move j-setnamedcolor(tela, j-red) to nullo
            when <= 1
                move j-setnamedcolor(tela, j-green) to nullo
        end-evaluate

        move y2 to save-position

        *>  y = mx + q ...dove x1 = -8 (-80) e x2 = 8 (80).

        compute q = q * 10

        if m = 0 and q = 0
            move 0 to fx1
            move 0 to fy1
            move 0 to fx2
            move 0 to fy2
        else
            compute fx1 = larghezza + (-80 * 2.5)
            compute fy1 = altezza - (m * (fx1 - larghezza) + (q * 2.5))
            compute fx2 = larghezza + (80 * 2.5)
            compute fy2 = altezza - (m * (fx2 - larghezza) + (q * 2.5))
        end-if

        move fx1 to x1
        move fy1 to y1
        move fx2 to x2
        move fy2 to y2

        move j-drawline(tela, x1, y1, x2, y2) to nullo
    .
