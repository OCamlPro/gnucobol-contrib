      *>******************************************************************************
      *>  CobolDraw.cob is free software: you can redistribute it and/or 
      *>  modify it under the terms of the GNU Lesser General Public License as 
      *>  published by the Free Software Foundation, either version 3 of the License,
      *>  or (at your option) any later version.
      *>
      *>  CobolDraw.cob is distributed in the hope that it will be useful, 
      *>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
      *>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
      *>  See the GNU Lesser General Public License for more details.
      *>
      *>  You should have received a copy of the GNU Lesser General Public License 
      *>  along with CobolDraw.cob.
      *>  If not, see <http://www.gnu.org/licenses/>.
      *>******************************************************************************

      *>    ***********************************************************
      *>    ***********       GNUCobol Raylib Paint      **************
      *>    ***********************************************************
      *>    ***********     Author: Giancarlo Canini     **************
      *>    ***********     Date written: 14/10/2022     **************
      *>    ***********************************************************
      *>
      *>                       The RayLib Project...
      *>
      *>    https://www.raylib.com/
      *>
      *>                          ...for Linux
      *>
      *>    https://github.com/raysan5/raylib/wiki/Working-on-GNU-Linux
      *>
      *>    Install RayLib by possibly running a 'cmake' in
      *>    "/src". Recompiling downloaded RayLibs with 'cmake'
      *>    (follow instruction in links above) reconfigure libraries
      *>    "RayLib" graphics for your operating system before
      *>    install them with 'make' and 'make install'.
      *>
      *>    A possible sequence of instructions for a correct
      *>    installing RayLib on Debian Linux:
      *>        git clone https://github.com/raysan5/raylib.git raylib
      *>        raylib cd
      *>        mkdir build && cd build
      *>        cmake -DSHARED=ON -DSTATIC=ON ..
      *>        make make RAYLIB_LIBTYPE=SHARED
      *>        sudo make install RAYLIB_LIBTYPE=SHARED
      *>
      *>    ***********************************************************
      *>    ************   Tectonics (on Debian Linux)   **************
      *>    ***********************************************************
      *>    ************  cobc -c particelle.c -lraylib  **************
      *>    *** cobc -x -free CobolDraw.cob particelle.o -lraylib  ****
      *>    ***********************************************************
      *>    ************         ./CobolDraw             **************
      *>    ***********************************************************

      *>    ***********************************************************
      *>    **************** IDENTIFICAZION DIVISION ******************
      *>    ***********************************************************

       identification division.
       program-id. coboldraw.

      *>    ***********************************************************
      *>    ****************** ENVIRONMENT DIVISION *******************
      *>    ***********************************************************

       environment division.
       configuration section.
       repository.
            function all intrinsic.

      *>    ***********************************************************
      *>    ********************* DATA DIVISION ***********************
      *>    ***********************************************************

       data division.
       working-storage section.
      *>    Used to check keystrokes
       77   gnucobol1           pic 9              value            3.
       77   gnucobol2           pic 9              value            3.
       77   risposta            pic 9              value            1.
       77   frecciagiu          pic 9              value            0.
       77   frecciasu           pic 9              value            0.

      *>    CALL return variable
       77   ritorno             usage binary-short.

      *>    Write Circle
       77   scrivi-cerchio      usage binary-short.

      *>    Change Circle
       77   cambia-cerchio      usage binary-short value            0.

      *>    Esc key
       77   tasto-esc           usage binary-short.

      *>    X Coordinates
       77   x-pos               usage binary-short.

      *>    Y Coordinates
       77   y-pos               usage binary-short.

      *>    Control Switch to Blend Mode (ParticelleBlend)
       77   tipoblend           usage binary-long  value            0.
       77   save-tipoblend      usage binary-long  value            0.

      *>    Pointer used for TextFormat and WriteText functions
       77   formato-testo       usage pointer.   

      *>    Used for write Circle 
       77   disegna-cerchio     usage float-long.

      *>    Radius
       77   raggio              usage float-short  value            4.

      *>    Color
       77   colore              usage binary-long  unsigned.

      *>    End
       77   fine                pic 9              value            0.

      *>    Mouse position
       01   posizione-mouse     usage pointer.

      *>    Circle position
       01   posizione-cerchio   redefines posizione-mouse.
            05   x              usage float-short  value          300.
            05   y              usage float-short  value          200.

      *>    Colors
       01   colori.
            05   bianco.
                 10     br      usage binary-char  unsigned value 255.
                 10     bg      usage binary-char  unsigned value 255.
                 10     bb      usage binary-char  unsigned value 255.
                 10     ba      usage binary-char  unsigned value 255.
            05   nero.
                 10     nr      usage binary-char  unsigned value   0.
                 10     ng      usage binary-char  unsigned value   0.
                 10     nb      usage binary-char  unsigned value   0.
                 10     na      usage binary-char  unsigned value 255.
            05   rosso.
                 10     rr      usage binary-char  unsigned value 230.
                 10     rg      usage binary-char  unsigned value  41.
                 10     rb      usage binary-char  unsigned value  55.
                 10     ra      usage binary-char  unsigned value 255.
            05   verde.
                 10     vr      usage binary-char  unsigned value   0.
                 10     vg      usage binary-char  unsigned value 228.
                 10     vb      usage binary-char  unsigned value  48.
                 10     va      usage binary-char  unsigned value 255.
            05   arancione.
                 10     ar      usage binary-char  unsigned value 255.
                 10     ag      usage binary-char  unsigned value 161.
                 10     ab      usage binary-char  unsigned value   0.
                 10     aa      usage binary-char  unsigned value 255.
            05   blu.
                 10     blr     usage binary-char  unsigned value   0.
                 10     blg     usage binary-char  unsigned value 121.
                 10     blb     usage binary-char  unsigned value 241.
                 10     bla     usage binary-char  unsigned value 255.

      *>    ***********************************************************
      *>    ******************** PROCEDURE DIVISION *******************
      *>    ***********************************************************

       procedure division.
      *>    Initialize a 600x400 pixel Graphic Window
            call "InitWindow" using
                by value 600,
                by value 400,
                by reference "GnuCOBOL Raylib Paint"
                returning ritorno
                on exception
                    display "Error: RayLib Missing!" upon syserr
                    end-display
            end-call

      *>    Set frames per second
            call "SetTargetFPS" using
                by value 60
                returning omitted
            end-call
            
            call "particelle1" using 
                by value risposta
                returning ritorno
            end-call

      *>    Run until Esc key is pressed, or Alt+F4 or until window is closed by clicking X
            perform until tasto-esc = 1
                    call "WindowShouldClose"
                        returning tasto-esc
                    end-call
  
                    perform premi-tasto

                    perform disegna
            end-perform

            call "particelle3"
                    returning ritorno
            end-call

      *>    Close Graphic Window
            call "CloseWindow"
                    returning omitted
            end-call

       stop run
       .

      *>    ***********************************************************

       premi-tasto.
      *>    Left CTRL
            call "IsKeyPressed" using
                 by value 341
                 returning gnucobol1
            end-call

            if  gnucobol1 = 1
                move 1 to risposta
            end-if

      *>    Right CTRL
            call "IsKeyPressed" using
                 by value 345
                 returning gnucobol2
            end-call

            if  gnucobol2 = 1
                move 2 to risposta
            end-if

      *>    Down Arrow Key
            call "IsKeyPressed" using
                 by value 264
                 returning frecciagiu
            end-call

            if  frecciagiu = 1
                move 4 to risposta
            end-if

      *>    Up Arrow Key
            call "IsKeyPressed" using
                 by value 265
                 returning frecciasu
            end-call

            if  frecciasu = 1
                move 5 to risposta
            end-if

      *>    Extrapolate Mouse Coordinates
            call "GetMousePosition"
                returning posizione-mouse
            end-call

      *>    Check if the mouse button is pressed (0)
            call "IsMouseButtonDown" using
                by value 0
                returning scrivi-cerchio
            end-call

            if  scrivi-cerchio = 1
                move rosso to colore
                move 4 to raggio
            end-if

      *>    Check if the other mouse button is pressed (1)
            call "IsMouseButtonDown" using
                by value 1
                returning cambia-cerchio
            end-call

            if  cambia-cerchio = 1
                move nero to colore
                move 20 to raggio
                move 1 to scrivi-cerchio
            end-if
            .

      *>    ***********************************************************

       disegna.
      *>    Open Write Mode
            call static "BeginDrawing"
                returning omitted
            end-call

                if  fine = 0
                    move nero to colore
                    call "ClearBackground" using
                        by value colore
                        returning omitted
                    end-call
                    move 1 to fine
                end-if
                
                move posizione-cerchio to disegna-cerchio
                
                if  risposta = 4 or risposta = 5
                    call "particelle3"
                        returning ritorno
                    end-call
                    call "particelle1" using 
                        by value risposta
                        returning ritorno
                    end-call
                    move 2 to risposta
                end-if

                call "particelleblend"
                    returning tipoblend
                end-call
                
                if  tipoblend is not equal to save-tipoblend
                    move nero to colore

                    call "ClearBackground" using
                       by value colore
                       returning omitted
                    end-call

                    call "particelle3"
                        returning ritorno
                    end-call
                   
                    call "particelle1" using 
                        by value risposta
                        returning ritorno
                    end-call
                    move tipoblend to save-tipoblend
                end-if
 
                if  scrivi-cerchio is not equal to zeroes
      *>            Draw on the screen
                    call "DrawCircleV" using
                        by value disegna-cerchio,
                        by value raggio,
                        by value colore
                    end-call 
                    if  cambia-cerchio is not equal to 1
                        and (risposta = 2 or risposta = 4 or risposta = 5)
                        call "particelle2" using
                            by value tipoblend
                            returning ritorno
                        end-call
                    else
                        call "particelle1" using 
                            by value risposta
                            returning ritorno
                        end-call
                        move 0 to cambia-cerchio
                        move 4 to raggio
                    end-if
                end-if

                move bianco to colore

      *>        Write some text
                call "DrawText" using
                    by reference "Gravity speed in BLENDING mode Activate:F1 F2 F3 F4 - Deactivate:F10",
                    by value 122,
                    by value 315,
                    by value 10,
                    by value colore
                end-call

                call "DrawText" using
                    by reference "Big Brush:  Up Arrow Key --- Small Brush:  Down Arrow Key",
                    by value 150,
                    by value 325,
                    by value 10,
                    by value colore
                end-call

                move blu to colore

                call "DrawText" using
                    by reference "Lx Mouse click to draw in color",
                    by value 150,
                    by value 340,
                    by value 20,
                    by value colore
                end-call

                move arancione to colore

                call "DrawText" using
                    by reference " Rx Mouse click delete",
                    by value 195,
                    by value 360,
                    by value 20,
                    by value colore
                end-call

                move x to x-pos
                move y to y-pos

                move nero to colore

                call "DrawRectangle" using
                    by value 10,
                    by value 10,
                    by value 180,
                    by value 10,
                    by value colore,
                    returning formato-testo
                end-call

                call "TextFormat" using
                    by reference "x_pos: %08d  y_pos: %08d",
                    by value x-pos,
                    by value y-pos,
                    returning formato-testo
                end-call

                move verde to colore
                call "DrawText" using
                    by value formato-testo,
                    by value 10,
                    by value 10,
                    by value 8,
                    by value colore
                end-call
               
                move bianco to colore

                call "DrawText" using
                    by reference "Left CTRL switches to GnuCOBOL_RayLib Paint    Right CTRL switches to GnuCOBOL_C_RayLib BLENDING mode",
                    by value 10,
                    by value 40,
                    by value 8,
                    by value colore
                end-call

                move nero to colore

                if  risposta = 1
                    call "DrawRectangle" using
                        by value 8,
                        by value 40,
                        by value 252,
                        by value 10,
                        by value colore,
                        returning formato-testo
                    end-call
                    call "DrawRectangle" using
                        by value 370,
                        by value 6,
                        by value 210,
                        by value 22,
                        by value colore,
                        returning formato-testo
                    end-call
                    call "DrawRectangle" using
                        by value 100,
                        by value 315,
                        by value 400,
                        by value 20,
                        by value colore,
                        returning formato-testo
                    end-call
                    call "DrawRectangle" using
                        by value 10,
                        by value 380,
                        by value 580,
                        by value 20,
                        by value colore,
                        returning formato-testo
                    end-call
                    move bianco to colore
                    call "DrawText" using
                        by reference "Press the space bar to clear the screen",
                        by value 105,
                        by value 380,
                        by value 20,
                        by value colore
                    end-call
                else
                    call "DrawRectangle" using
                        by value 260,
                        by value 40,
                        by value 320,
                        by value 10,
                        by value colore,
                        returning formato-testo
                    end-call
                end-if

      *>    Close Write Mode
            call static "EndDrawing"
                returning omitted
            end-call
            .

      *>    ***********************************************************
      *>    ************************** FINE ***************************
      *>    ***********************************************************
      