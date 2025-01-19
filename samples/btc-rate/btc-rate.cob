*>******************************************************************************
*>  btc-rate.cob is free software: you can redistribute it and/or 
*>  modify it under the terms of the GNU Lesser General Public License as 
*>  published by the Free Software Foundation, either version 3 of the License,
*>  or (at your option) any later version.
*>
*>  btc-rate.cob is distributed in the hope that it will be useful, 
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of 
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*>  See the GNU Lesser General Public License for more details.
*>
*>  You should have received a copy of the GNU Lesser General Public License 
*>  along with btc-rate.cob.
*>  If not, see <http://www.gnu.org/licenses/>.
*>******************************************************************************

*>******************************************************************************
*> Program:      btc-rate.cob
*>
*> Purpose:      Bitcoin rate ticker
*>
*> Author:       Laszlo Erdos - https://www.facebook.com/wortfee
*>
*> Date-Written: 2025-01-02
*>
*> Tectonics:    see the makefile
*>
*>******************************************************************************
*> Date       Name / Change description 
*> ========== ==================================================================
*> 2025-01-02 First version.
*>------------------------------------------------------------------------------
*>
*>******************************************************************************

 IDENTIFICATION DIVISION.
 PROGRAM-ID. btc-rate.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
    FUNCTION ALL INTRINSIC.
 
 DATA DIVISION.
 WORKING-STORAGE SECTION.
 78 C-JSON-MAX-LEN                     VALUE 1000.

*> fields for the system2_cmd() function
 01 WS-CMD-IN                          PIC X(200)
        VALUE z"curl -s https://api.coindesk.com/v1/bpi/currentprice.json".
 01 WS-CMD-OUT-MAX-LEN                 BINARY-LONG VALUE C-JSON-MAX-LEN.
 01 WS-CMD-OUT                         PIC X(C-JSON-MAX-LEN).
 01 WS-CMD-OUT-LEN                     BINARY-LONG VALUE 0.
 01 WS-CMD-RETURN-CODE                 BINARY-LONG.

 01 LNK-PARSE-JSON.
   02 LNK-INPUT.
     03 LNK-JSON-DATA                  PIC X(C-JSON-MAX-LEN).
     03 LNK-JSON-DATA-LEN              BINARY-LONG. 
   02 LNK-OUTPUT.                      
     03 LNK-RESULT-FLAG                PIC 9(2).
        88 V-OK                        VALUE  0.
        88 V-NOT-OK                    VALUE  1.
     03 LNK-UPDATE-TIME-UTC            PIC X(25).
     03 LNK-USD-RATE                   PIC X(20).
     03 LNK-EUR-RATE                   PIC X(20).

*> for test
*> 01 JSON-TEST-DATA                     PIC X(C-JSON-MAX-LEN) VALUE
*>    '{
*>    "time":{"updated":"Jan 17, 2025 17:16:26 UTC",
*>            "updatedISO":"2025-01-17T17:16:26+00:00",
*>            "updateduk":"Jan 17, 2025 at 17:16 GMT"},
*>    "disclaimer":"This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org",
*>    "chartName":"Bitcoin",
*>    "bpi":{"USD":{"code":"USD","symbol":"&#36;","rate":"105,714.711","description":"United States Dollar","rate_float":105714.7113},
*>           "GBP":{"code":"GBP","symbol":"&pound;","rate":"84,315.411","description":"British Pound Sterling","rate_float":84315.4109},
*>           "EUR":{"code":"EUR","symbol":"&euro;","rate":"101,669.432","description":"Euro","rate_float":101669.4322}
*>              }
*>  }'.

 PROCEDURE DIVISION.
 
*>------------------------------------------------------------------------------
 MAIN-BTC-RATE SECTION.
*>------------------------------------------------------------------------------

    PERFORM 20 TIMES
       PERFORM GET-BTC-CURRENT-PRICE

       PERFORM CALL-PARSE-JSON

       IF V-OK OF LNK-RESULT-FLAG
       THEN
          DISPLAY FUNCTION TRIM(LNK-UPDATE-TIME-UTC) "; "
                  FUNCTION TRIM(LNK-USD-RATE) " USD; "
                  FUNCTION TRIM(LNK-EUR-RATE) " EUR; "
       ELSE
          DISPLAY "cJSON parse problem"
          EXIT PERFORM     
       END-IF

*>     wait 30 seconds   
       CALL "C$SLEEP" USING 30
    END-PERFORM

    STOP RUN.

*>------------------------------------------------------------------------------
 GET-BTC-CURRENT-PRICE SECTION.
*>------------------------------------------------------------------------------
  
    CALL "system2_cmd"
         USING BY CONTENT   WS-CMD-IN
               BY VALUE     WS-CMD-OUT-MAX-LEN
               BY REFERENCE WS-CMD-OUT
               BY REFERENCE WS-CMD-OUT-LEN
         RETURNING WS-CMD-RETURN-CODE
    END-CALL     

*>  for test    
*>  DISPLAY "WS-CMD-IN: "          WS-CMD-IN
*>  DISPLAY "WS-CMD-OUT-MAX-LEN: " WS-CMD-OUT-MAX-LEN
*>  DISPLAY "WS-CMD-OUT: "         WS-CMD-OUT(1:WS-CMD-OUT-LEN)
*>  DISPLAY "WS-CMD-OUT-LEN: "     WS-CMD-OUT-LEN
*>  
*>  DISPLAY "WS-CMD-RETURN-CODE: " WS-CMD-RETURN-CODE
*>  DISPLAY " "
*>  DISPLAY " "

    .
    EXIT SECTION .

*>------------------------------------------------------------------------------
 CALL-PARSE-JSON SECTION.
*>------------------------------------------------------------------------------

    INITIALIZE LNK-PARSE-JSON
    MOVE WS-CMD-OUT     TO LNK-JSON-DATA
    MOVE WS-CMD-OUT-LEN TO LNK-JSON-DATA-LEN

    CALL "parse-json" 
         USING LNK-PARSE-JSON 
    END-CALL

    .
    EXIT SECTION .
 
 END PROGRAM btc-rate.
