       identification division.
       program-id. worldcities8.
      *
      * Copyright (C) 2014 Steve Williams <stevewilliams38@gmail.com>
      *
      * This program is free software; you can redistribute it and/or
      * modify it under the terms of the GNU General Public License as
      * published by the Free Software Foundation; either version 2,
      * or (at your option) any later version.
      * 
      * This program is distributed in the hope that it will be useful,
      * but WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      * GNU General Public License for more details.
      * 
      * You should have received a copy of the GNU General Public
      * License along with this software; see the file COPYING.
      * If not, write to the Free Software Foundation, Inc.,
      * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

      *==================================================
      * modify worldcities7
      *
      * 1)  use a screen to select polygon files,
      *     worldcity files, and feature-classes
      * 2)  show all feature-classes
      *==================================================
      * How to create and save a google-earth polygon
      * (it's not obvious):
      *
      * 1. open google-earth and use search in the
      *      sidebar to go to a location
      *
      *      you can open google-earth by typing google
      *      in the Polygon File field
      * 
      * 2. click on the polygon icon in the toolbar
      *      (the third icon in the toolbar - it looks
      *       like a bent benzene ring)
      * 3. in the polygon sidebar give the polygon
      *      a name and a style
      * 4. using discrete clicks (don't drag the mouse)
      *      define the polygon nodes in the display
      * 5. save the polygon (the save/OK button is at
      *      the bottom of the polygon sidebar and may
      *      not be completely visible)
      * 6. the saved polygon name will appear at the
      *      bottom of the sidebar on the left 
      * 7. right-click on the saved polygon name
      *      and select 'save place as. . .'
      * 8. save the polygon as a kml (not kmz) file
      *      in the same directory as the worldcityfiles 
      *==================================================

       environment division.
       configuration section.
       repository. function all intrinsic.
       special-names. c01 is one-page.
       input-output section.
       file-control.
           select city-file
               assign to city-file-name
               file status is city-file-status
               organization is line sequential.

            select country-file
               assign to country-file-name
               file status is country-file-status
               organization is line sequential.

            select report-file
               assign to report-file-name
               file status is report-file-status.

            select sort-file.

            select kml-file
               assign to kml-file-name
               organization is line sequential.

            select polygon-file
               assign to polygon-file-name
               file status is polygon-file-status
               organization is line sequential.

            select system-file
               assign to 'temp'
               file status is system-file-status
               organization is line sequential.

       data division.
       file section.
       fd  system-file.
       01  system-record pic x(70).

       fd  polygon-file.
       01  polygon-record pic x(32000).

       fd  report-file.
       01  report-record pic x(72).

       fd  country-file.
       01  country-record pic x(1000).

       fd  city-file.
       01  city-record pic x(1000).

       sd  sort-file.
       01  sort-record.
           03  sort-city-country-code pic x(2).
           03  sort-feature pic x.
           03  sort-city-population pic 9(9).
           03  sort-city-name pic x(43).
           03  sort-city-latitude pic s9(3)v9(6).
           03  sort-city-longitude pic s9(3)v9(6).

       fd  kml-file.
       01  kml-record pic x(32000).

       working-storage section.
       01  command-file-name pic x(128) value 'worldcities8.sh'.
       01  techtonics.
           03  pic x(128) value 'rm run-file'.
           03  pic x(128) value 'rm report-file'.
           03  pic x(128) value
               'export PRINTQUEUE=Brother-HL-2170W-wireless'.
           03  pic x(128) value 'export BROWSER=firefox'.
           03  pic x(128) value 'export MAPS=google-earth'.
           03  pic x(128) value 'export SOURCE='
               & 'http://download.geonames.org/export/dump/'.
           03  pic x(128) value 'export FILES=$HOME/worldcityfiles'.
           03  pic x(128) value
               'cobc -x -W worldcities8.cbl commonroutines.cbl'.
           03  pic x(128) value 'rm $FILES/worldcities8.kml'.
           03  pic x(128) value 'rm temp'.
           03  pic x(128) value './worldcities8'
               & ' $FILES/countryInfo.txt'
               & ' $FILES/worldcities8.kml'.
           03  pic x(128) value 'rm worldcities8'.
           03  pic x(128) value 'rm temp'.
           03  pic x(128) value 'lpr -P $PRINTQUEUE run-file'.
           03  pic x(128) value 'lpr -P $PRINTQUEUE report-file'.
           03  pic x(128) value 'end'.
      *==================================================


      * google-earth polygon fields

       01  polygon-file-status pic x(2).
       01  polygon-country-code pic X(3).
       01  polygon-country-name pic X(72).
       01  polygon-latitude pic S9(3)V9(6).
       01  polygon-longitude pic S9(3)V9(6).
       
       01  crossing-longitude pic s9(3)v9(6).
       01  crossings pic x(4).
       01  node-idx pic 9(3).
       01  node-max pic 9(3).
       01  node-lim pic 9(3) value 100.
       01  processing-coordinates pic x.
       01  polygon-pointer pic 9(5).
       01  max-longitude pic s9(3)v9(13).
       01  min-longitude pic s9(3)v9(13).
       01  max-latitude pic s9(3)v9(13).
       01  min-latitude pic s9(3)v9(13).
       01  delta-latitude pic s9(3)v9(13).
       01  delta-longitude pic s9(3)v9(13).
       01  kml-polygon.
           03  filler occurs 100.
               05  kml-longitude pic s9(3)v9(13).
               05  kml-latitude pic s9(3)v9(13).
               05  kml-altitude pic s9(5).
               05  kml-slope-type pic x.
               05  kml-slope pic s9(2)v9(6).
       01  start-edge redefines kml-polygon.
           03  filler occurs 99.
               05  start-longitude pic s9(3)v9(13).
               05  start-latitude pic s9(3)v9(13).
               05  start-altitude pic s9(5).
               05  start-slope-type pic x.
               05  start-slope pic s9(2)v9(6).
           03  filler.
               05  filler pic s9(3)v9(13).
               05  filler pic s9(3)v9(13).
               05  filler pic s9(5).
               05  filler pic x.
               05  filler pic s9(2)v9(6).
       01  end-edge redefines kml-polygon.
           03  filler.
               05  filler pic s9(3)v9(13).
               05  filler pic s9(3)v9(13).
               05  filler pic s9(5).
               05  filler pic x.
               05  filler pic s9(2)v9(6).
           03  filler occurs 99.
               05  end-longitude pic s9(3)v9(13).
               05  end-latitude pic s9(3)v9(13).
               05  end-altitude pic s9(5).
               05  end-slope-type pic x.
               05  end-slope pic s9(2)v9(6).

       01  end-sort-file pic x.

       01  print-run-control.
           03  print-run-function pic x(5) value 'open'.
           03  run-program-name pic x(31) value 'worldcities8'.
           03  run-line.
               05  display-count pic z,zzz,zzzb.
               05  display-elapsed-seconds redefines display-count
                   pic z(5)9.99b.
               05  display-message pic x(62).
           03  run-page-count pic 999.
           03  run-line-count pic 99.
           03  run-line-limit pic 99 value 55.
           03  run-skip-count pic 9.
           03  display-run-line pic x value 'n'.

       01  report-file-name pic x(64) value 'report-file'.
       01  report-file-status pic x(2).

       01  report-page-count pic 999.
       01  report-line-count pic 99.
       01  report-line-limit pic 99 value 55.
       01  report-skip-count pic 9.

       01  report-heading.
           03  program-name pic x(13) value 'worldcities8'.
           03  report-title pic x(32) value space.
           03  report-date.
               05  report-month pic xx.
               05  filler pic x value '/'.
               05  report-day-of-month pic xx.
               05  filler pic x value '/'.
               05  report-year pic xx.
           03  filler pic x value space.
           03  report-time.
               05  report-hour pic xx.
               05  filler pic x value ':'.
               05  report-minute pic xx.
               05  filler pic x value "'".
               05  report-second pic xx.
               05  filler pic x value quote.
          03  filler pic x value space.
          03  filler pic x(5) value 'page'.
          03  report-page pic zz9.

       01  report-heading-1 pic x(72).

       01  report-line.
           03  report-country-name pic x(72).

       01  report-line-1 redefines report-line.
           03  filler pic x(5).
           03  report-latitude pic ---9.999999b.
           03  report-longitude pic ---9.999999b.
           03  report-city-population pic z(8)9b.
           03  report-city-name pic x(43).

       01  report-line-2 redefines report-line.
           03  filler pic x(5).
           03  filler pic x(12).
           03  filler pic x(12).
           03  report-slope-type pic x.
           03  filler pic x.
           03  report-slope pic -9(2).9(6).

       01  country-file-name pic x(64).
       01  country-file-status pic x(2).

       01  country-idx pic 9(3).
       01  country-max pic 9(3).
       01  country-lim pic 9(3) value 900.
       01  unknown-country pic x(15) value 'unknown country'.
       01  country-table.
           03  country-entry occurs 900.
               05  iso pic x(2).
               05  iso3 pic x(3).
               05  iso-numeric	pic 9(3).
               05  fips pic x(2).
               05  country pic x(64).
               05  capital pic x(64).
               05  areainsqkm pic 9(12).
               05  population pic 9(12).
               05  continent pic x(2).
               05  tld pic x(3).
               05  currencycode pic x(3).
               05  currencyname pic x(16).
               05  phone pic x(16).
               05  postalcodeformat pic x(16).
               05  postalcoderegex pic x(16).
               05  languages pic x(100).
               05  country-geonameid pic 9(9).
               05  neighbours pic x(100).
               05  equivalentfipscode pic x(2).

       01  kml-file-name pic x(64).

       01  city-file-status pic x(2).

       01  city-count pic 9(7) value zero.
       01  input-count pic 9(7) value zero.
       01  country-count pic 9(7) value zero.

       01  city-columns.
           03  city-geonameid pic 9(9).
           03  city-name pic x(200).
           03  asciiname pic x(200).
           03  alternatenames pic x(5000).
           03  latitude pic s9(3)v9(6).
           03  longitude pic s9(3)v9(6).
           03  featureclass pic x.
           03  featurecode pic x(10).
           03  city-country-code pic x(2).
           03  cc2 pic x(60).
           03  admin1code pic x(60).
           03  admin2code pic x(80).
           03  admin3code pic x(20).
           03  admin4code pic x(20).
           03  city-population pic 9(9).
           03  elevation pic 9(5).
           03  dem pic 9(5).
           03  timezone pic x(40).
           03  modificationdate pic x(10).

       01  city-lengths.
           03  city-name-length pic 9(3).
           03  asciiname-length pic 9(3).
           03  alternatenames-length pic 9(4).
           03  cc2-length pic 9(2).
           03  admin1code-length pic 9(2).
           03  admin2code-length pic 9(2).
           03  admin3code-length pic 9(2).
           03  admin4code-length pic 9(2).
           03  timezone-length pic 9(2).

       01  current-country-code pic x(3) value space.

       01  fcx pic 99.
       01  fcx-max pic 99 value 9.
       01  featureclasses.
           03  filler pic x(30) value
               'A : country, state, region,...'.
           03  filler pic x(30) value
               'H : stream, lake, ...'.
           03  filler pic x(30) value
               'L : parks,area, ...'.
           03  filler pic x(30) value
               'P : city, village,...'.
           03  filler pic x(30) value
               'R : road, railroad'.
           03  filler pic x(30) value
               'S : spot, building, farm'.
           03  filler pic x(30) value
               'T : mountain,hill,rock,...'.
           03  filler pic x(30) value
               'U : undersea'.
           03  filler pic x(30) value
               'V : forest,heath,...'.
       01  filler redefines featureclasses.
           03  featureclass-line occurs 9.
               05  featureclasscode pic x.
               05  featureclassvalue pic x(29).

       01  ct-time.
           03  ct-hour pic 99.
           03  ct-minute pic 99.
           03  ct-second pic 99.
           03  ct-hundredth pic 99.

       01  cd-date.
           03  cd-year pic xx.
           03  cd-month pic xx.
           03  cd-day-of-month pic xx.

       01  start-seconds pic 9(5)v99.
       01  end-seconds pic 9(5)v99.
       01  elapsed-seconds pic 9(5)v99.

      * external variables

        01  file-path pic x(70).
        01  file-path-length pic 9(2).
        01  browser-name pic x(70).
        01  source-name pic x(70).
        01  maps-name pic x(70).

      * parameter screen definitions

        78  black value 0.
        78  blue value 1.
        78  green value 2.
        78  cyan value 3.
        78  red value 4.
        78  magenta value 5.
        78  yellow value 6.
        78  white value 7.

        77  polygon-file-ok pic x value 'n'.
        77  city-file-ok pic x value 'n'.
        77  features-ok pic x value 'n'.
        01  polygon-file-only pic x(40).
        01  polygon-file-name pic x(128).
        01  city-file-only pic x(40).
        01  city-file-name pic x(128).
        01  features pic x(10).
        01  features-idx pic 9(2).
        01  features-max pic 9(2) value 10.
        01  message-idx pic 9(2).
        01  message-max pic 9(2) value 10.
        01  error-message pic x(75).
        01  message-lines.
            03  message-line pic x(75).
            03  message-line1 pic x(70).
            03  message-line2 pic x(70).
            03  message-line3 pic x(70).
            03  message-line4 pic x(70).
            03  message-line5 pic x(70).
            03  message-line6 pic x(70).
            03  message-line7 pic x(70).
            03  message-line8 pic x(70).
            03  message-line9 pic x(70).
            03  message-line10 pic x(70).
        01  system-file-status pic x(2).
        01  system-command pic x(70).
        01  progress-count pic 9(6) value 100000.
        01  progress-integer pic 9(3).
        01  progress-remainder pic 9(9).

        screen section.
        01  parameter-screen.
            03  background-color white highlight.
                05 blank screen.
            03  background-color white
                foreground-color black highlight.
                05 blank screen.
                05 line 2 column 2 value 'worldcities8 parameters'.
                05 line 4 column 12 value 'Polygon File:'.
                05 screen-polygon-file-only line 4 column 26 pic x(40)
                   using polygon-file-only.
                05 line 5 column 15 value 'City File:'.
                05 screen-city-file-only line 5 column 26  pic x(40)  
                   using city-file-only.
                05 line 6 column 9 value 'Feature Classes:'.
                05 screen-features line 6 column 26 pic x(10)  
                   using features.
                05 screen-error-message line 7 column 26 pic x(75)
                   from error-message.
                05 screen-message line 8 column 2 pic x(75)  
                   from message-line.
                05 screen-message1 line 9 column 5 pic x(70)  
                   from message-line1.
                05 screen-message2 line 10 column 5 pic x(70)  
                   from message-line2.
                05 screen-message3 line 11 column 5 pic x(70)  
                   from message-line3.
                05 screen-message4 line 12 column 5 pic x(70)  
                   from message-line4.
                05 screen-message5 line 13 column 5 pic x(70)  
                   from message-line5.
                05 screen-message6 line 14 column 5 pic x(70)  
                   from message-line6.
                05 screen-message7 line 15 column 5 pic x(70)  
                   from message-line7.
                05 screen-message8 line 16 column 5 pic x(70)  
                   from message-line8.
                05 screen-message9 line 17 column 5 pic x(70)  
                   from message-line9.
                05 screen-message10 line 18 column 5 pic x(70)  
                   from message-line10.
                05 line 20 column 2 value
                   'enter abort in the open field to terminate'.
                05 line 21 column 2 value
                   'enter define in Polygon File to define a polygon'.
                05 line 22 column 2 value
                   'enter download in City File to download a file'.

       01  tab pic x value x'09'.

       procedure division chaining country-file-name kml-file-name.
       start-worldcities8.
           call 'printrunreport' using print-run-control end-call

           move 'y' to display-run-line
           move 'starting worldcities8' to run-line
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

           if country-file-name = 'techtonics'
               call 'techtonics' using
                   command-file-name techtonics end-call
               move 'close' to print-run-function
               call 'printrunreport' using print-run-control end-call
               stop run
           end-if
           move 'n' to display-run-line

      ***  get the external variables
           move 'echo $FILES > temp' to system-command
           perform get-external-variable
           move 2 to file-path-length
           move system-record to file-path
           inspect file-path tallying file-path-length
               for characters before initial space

           move 'echo $BROWSER > temp' to system-command
           perform get-external-variable
           move system-record to browser-name

           move 'echo $SOURCE > temp' to system-command
           perform get-external-variable
           move system-record to source-name

           move 'echo $MAPS > temp' to system-command
           perform get-external-variable
           move system-record to maps-name

      ***   get the run parameters
           move spaces to polygon-file-name
           move spaces to city-file-name
           move spaces to features
           move spaces to message-lines
           move spaces to system-file-status
           display parameter-screen end-display
           perform until polygon-file-ok = 'y'
           and city-file-ok = 'y'
           and features-ok = 'y'
               evaluate true
               when polygon-file-ok = 'n'
                   move spaces to message-lines
                   move 'ls $FILES/*.kml > temp' to system-command
                   perform get-file-list
                   accept screen-polygon-file-only end-accept
                   evaluate true
                   when polygon-file-only = 'abort'
                       perform abort-run
                   when polygon-file-only = 'define'
                       close system-file
                       move spaces to system-file-status
                       move trim(maps-name) to system-command
                       call 'SYSTEM' using system-command end-call
                   when polygon-file-only <> spaces
                       move spaces to polygon-file-name
      ***======================================================                  
      ***              if polygon-file-only starts with space
      ***              and you unstring
      ***                  polygon-file-only delimited by space
      ***              rather than
      ***                  polygon-file-only delimited by size
      ***              the subsequent open will return '00'
      ***
      ***              I don't know why and I can't create a
      ***              test case to debug it
      ***======================================================                  
                       string file-path delimited by space
                           '/' delimited by size
                           polygon-file-only delimited by size
                           into polygon-file-name end-string
                       open input polygon-file
                       if polygon-file-status <> '00'
                           move 'invalid polygon file name'
                               to error-message
                       else
                           move 'y' to polygon-file-ok
                           close system-file
                           move spaces to system-file-status
                               error-message
                       end-if
                       display screen-error-message end-display
                   end-evaluate
               when city-file-ok = 'n'
                   move spaces to message-lines
                   move 'ls $FILES/*.txt > temp' to system-command
                   perform get-file-list
                   accept screen-city-file-only end-accept
                   evaluate true
                   when city-file-only = 'abort'
                       perform abort-run
                   when city-file-only = 'download'
                       close system-file
                       move spaces to system-file-status
                       move spaces to system-command
                       string browser-name delimited by space
                           space delimited by size
                           source-name delimited by space
                           into system-command
                       end-string
                       call 'SYSTEM' using system-command end-call
                   when city-file-only <> spaces
                       move spaces to city-file-name
                       string file-path delimited by space
                           '/' delimited by size
                           city-file-only delimited by size
                           into city-file-name end-string
                       open input city-file
                       if city-file-status <> '00'
                           move 'invalid city file name'
                               to error-message
                       else
                           move 'y' to city-file-ok
                           close system-file
                           move spaces to system-file-status
                               error-message
                       end-if
                       display screen-error-message end-display
                   end-evaluate
               when features-ok = 'n'
      ***          ====================================================
      ***          see //www.geonames.org/export/codes.html
      ***              A : country, state, region,...
      ***              H : stream, lake, ...
      ***              L : parks,area, ...
      ***              P : city, village,...
      ***              R : road, railroad
      ***              S : spot, building, farm
      ***              T : mountain,hill,rock,...
      ***              U : undersea
      ***              V : forest,heath,...
      ***          ====================================================
                   move spaces to message-lines
                   move 'valid features are' to message-line
                   move featureclass-line(1)
                       to message-line1
                   move featureclass-line(2)
                       to message-line2
                   move featureclass-line(3)
                       to message-line3
                   move featureclass-line(4)
                       to message-line4
                   move featureclass-line(5)
                       to message-line5
                   move featureclass-line(6)
                       to message-line6
                   move featureclass-line(7)
                       to message-line7
                   move featureclass-line(8)
                       to message-line8
                   move featureclass-line(9)
                       to message-line9
                   perform display-message-lines
                   accept screen-features end-accept
                   evaluate true
                   when features = 'abort'
                       perform abort-run
                   when features <> spaces
                       move 'y' to features-ok
                       move spaces to error-message
                       perform varying features-idx from 1 by 1
                       until features-idx > features-max
                       or features-ok = 'n'
                           perform varying fcx from 1 by 1
                           until fcx > fcx-max
                           or features(features-idx:1)
                           = featureclasscode(fcx)
                               continue
                           end-perform
                           if fcx > fcx-max
                           and features(features-idx:1) <> space
                               string features(features-idx:1)
                                   space 'is not a valid feature'
                                   delimited by size into error-message
                               end-string
                               move 'n' to features-ok
                           end-if
                       end-perform
                       display screen-error-message end-display
                   end-evaluate
               end-evaluate
            end-perform
            move spaces to message-lines
            move 'processing. . .' to message-line
            perform display-message-lines

      ***  process the parameters
           accept ct-time from time end-accept
           compute start-seconds =
               ct-hour * 60 * 60
               + ct-minute * 60
               + ct-second
               + ct-hundredth / 100
           end-compute

           sort sort-file
               ascending key sort-city-country-code
                   sort-city-name
               input procedure sort-input
               output procedure sort-output

           accept ct-time from time end-accept
           compute end-seconds =
               ct-hour * 60 * 60
               + ct-minute * 60
               + ct-second
               + ct-hundredth / 100
           end-compute
                 
           move 2 to run-skip-count
           move input-count to display-count
           string 'input records from ' delimited by size
               city-file-only delimited by space
               into display-message end-string
           call 'printrunreport' using print-run-control end-call

           move city-count to display-count
           string 'file entries in polygon ' delimited by size
               polygon-file-only delimited by space
               into display-message end-string
           call 'printrunreport' using print-run-control end-call

           compute elapsed-seconds =
               end-seconds - start-seconds end-compute
           move elapsed-seconds to display-elapsed-seconds
           move 'elapsed seconds' to display-message
           call 'printrunreport' using print-run-control end-call

           compute display-count = input-count / elapsed-seconds
               on size error move 0 to display-count
           end-compute
           move 'records per second' to display-message
           call 'printrunreport' using print-run-control end-call

           move 2 to run-skip-count
           move 'ending worldcities8' to run-line
           call 'printrunreport' using print-run-control end-call

           move 'close' to print-run-function
           call 'printrunreport' using print-run-control end-call

      ***  hand off the kml file to google-earth
           move spaces to system-command
           string maps-name delimited by '  '
               space delimited by size
               kml-file-name delimited by space
               into system-command end-string
           call 'SYSTEM' using system-command end-call

           stop run
           .
       get-external-variable.
           move spaces to system-record
           call 'SYSTEM' using system-command end-call
           if return-code = 0
               open input system-file
               read system-file end-read
               close system-file
           end-if
           if system-record = spaces
               string system-command delimited by '  '
                   ' failed' delimited by size
                   into run-line end-string
               call 'printrunreport' using print-run-control end-call
               move 'run aborted' to run-line
               call 'printrunreport' using print-run-control end-call
               move 'close' to print-run-function
               call 'printrunreport' using print-run-control end-call
               stop run
           end-if
           .
       abort-run.
           move 'run aborted by operator' to run-line
           call 'printrunreport' using print-run-control end-call
           move 'close' to print-run-function
           call 'printrunreport' using print-run-control end-call
           stop run
           .
       get-file-list.
           move spaces to message-lines
           move 0 to message-idx
           evaluate true
           when system-file-status = spaces
      ***       first screen full
               call 'SYSTEM' using system-command end-call
               if return-code <> 0
                   move 'no files found' to message-line
                   move '10' to system-file-status
               else
                   move 'available files:' to message-line
                   open input system-file
                   read system-file end-read
               end-if
           when system-file-status = '00'
      ***       continuing screen full
               move 'more available files:' to message-line
               read system-file end-read
           when system-file-status = '10'
      ***       no more files so start over
               move 'available files:' to message-line
               close system-file
               open input system-file
               read system-file end-read
           end-evaluate

           perform until system-file-status <> '00'
           or message-idx >= message-max
               add 1 to message-idx end-add
               evaluate true
               when message-idx = 1
                   move system-record(file-path-length:)
                       to message-line1
               when message-idx = 2
                   move system-record(file-path-length:)
                       to message-line2
               when message-idx = 3
                   move system-record(file-path-length:)
                       to message-line3
               when message-idx = 4
                   move system-record(file-path-length:)
                       to message-line4
               when message-idx = 5
                   move system-record(file-path-length:)
                       to message-line5
               when message-idx = 6
                   move system-record(file-path-length:)
                       to message-line6
               when message-idx = 7
                   move system-record(file-path-length:)
                       to message-line7
               when message-idx = 8
                   move system-record(file-path-length:)
                       to message-line8
               when message-idx = 9
                   move system-record(file-path-length:)
                       to message-line9
               when message-idx = 10
                   move system-record(file-path-length:)
                       to message-line10
               end-evaluate
               read system-file end-read
           end-perform
           perform display-message-lines
           .
       display-message-lines.
           display screen-message end-display
           display screen-message1 end-display
           display screen-message2 end-display
           display screen-message3 end-display
           display screen-message4 end-display
           display screen-message5 end-display
           display screen-message6 end-display
           display screen-message7 end-display
           display screen-message8 end-display
           display screen-message9 end-display
           display screen-message10 end-display
           .
       sort-input.
           open output kml-file
           move 0 to node-max
           move 'n' to processing-coordinates
           move 370 to min-longitude min-latitude
           move -370 to max-longitude max-latitude
      ***  polygon-file is already open
           call 'checkfilestatus'
               using polygon-file-name polygon-file-status end-call
           read polygon-file end-read
           call 'checkfilestatus'
               using polygon-file-name polygon-file-status end-call
           perform until polygon-file-status = '10'
               inspect polygon-record replacing all tab by space
               move trim(polygon-record) to polygon-record

               if polygon-record <> '</Document>' and '</kml>'
                   write kml-record from polygon-record end-write
               end-if

               evaluate true
               when polygon-record = '</coordinates>'
                   move 'n' to processing-coordinates 
               when polygon-record = '<coordinates>'
                   move 'y' to processing-coordinates
               when processing-coordinates = 'y'
                   perform until polygon-record = spaces
      ***               extract the left-most coordinate triple
      ***               from the polygon-record
                       move 1 to polygon-pointer
                       inspect polygon-record
                           tallying polygon-pointer
                           for characters
                           before initial space
                       add 1 to node-max end-add
                       unstring polygon-record(1:polygon-pointer)
                           delimited by ',' or ' ' into
                           kml-longitude(node-max)
                           kml-latitude(node-max)
                           kml-altitude(node-max)
                       end-unstring
      ***               remove the left-most coordinate triple
      ***               from the polygon-record
                       move spaces to polygon-record(1:polygon-pointer)
                       move trim(polygon-record) to polygon-record

      ***               update the polygon min/max rectangle
                       if kml-longitude(node-max) > max-longitude
                           move kml-longitude(node-max) to max-longitude
                       end-if
                       if kml-longitude(node-max) < min-longitude
                           move kml-longitude(node-max) to min-longitude
                       end-if
                       if kml-latitude(node-max) > max-latitude
                           move kml-latitude(node-max) to max-latitude
                       end-if
                       if kml-latitude(node-max) < min-latitude
                           move kml-latitude(node-max) to min-latitude
                       end-if

                   end-perform
               end-evaluate
               read polygon-file end-read
               call 'checkfilestatus'
                   using polygon-file-name polygon-file-status end-call
           end-perform
           close polygon-file

      ***   calculate the polygon edge slope types and slope values
           perform varying node-idx from 1 by 1
           until node-idx > node-max
               compute delta-latitude = 
                   end-latitude(node-idx) - start-latitude(node-idx)
               end-compute
               compute delta-longitude = 
                   end-longitude(node-idx) - start-longitude(node-idx)
               end-compute
               evaluate true
               when abs(delta-latitude) > 100 * abs(delta-longitude)
      ***           declare the edge vertical
                   move 'v' to start-slope-type(node-idx)
               when abs(delta-latitude) < .01 * abs(delta-longitude)
      ***           declare the edge horizontal
                   move 'h' to start-slope-type(node-idx)
               when other
                   move 's' to start-slope-type(node-idx)
                   compute start-slope(node-idx) =
                       delta-latitude / delta-longitude
                   end-compute
               end-evaluate
           end-perform

           read city-file end-read
           call 'checkfilestatus'
               using city-file-name city-file-status end-call
           perform until city-file-status = '10'
               add 1 to input-count end-add

      ***       show progress every progress-count records
               divide progress-count into input-count
                   giving progress-integer
                   remainder progress-remainder
               end-divide
               if progress-remainder = 0
                   move input-count to display-count
                   move display-count to message-line1
                   display screen-message1 end-display
               end-if

               unstring city-record delimited by tab into
                   city-geonameid
                   city-name count in city-name-length
                   asciiname count in asciiname-length
                   alternatenames count in alternatenames-length
                   latitude
                   longitude
                   featureclass
                   featurecode
                   city-country-code
                   cc2 count in cc2-length
                   admin1code count in admin1code-length
                   admin2code count in admin2code-length
                   admin3code count in admin3code-length
                   admin4code count in admin4code-length
                   city-population
                   elevation
                   dem
                   timezone count in timezone-length
                   modificationdate
               end-unstring

               perform varying features-idx from 1 by 1
               until features-idx > features-max
               or features(features-idx:1) = featureclass
                   continue
               end-perform

               evaluate true
               when features-idx > features-max
               when latitude <= min-latitude
               when latitude >= max-latitude
               when longitude <= min-longitude
               when longitude >= max-longitude
      ***           skip this record
                   continue
               when other
      ***        we're inside the polygon min/max rectangle  
      ***        =======================================================
      ***        this common polygon inclusion algorithm traces a ray
      ***        (in this case a horizontal ray) from the point in
      ***        question to infinity (in this case positive infinity)
      ***        if the ray doesn't cross any polygon edges or if it
      ***        crosses an even number of polygon edges, the point is
      ***        not in the polygon
      ***        if the ray crosses an odd number of polygon edges the
      ***        point is in the polygon
      ***        =======================================================
      ***        solve
      ***            slope = (point y - end y) / (end x - intercept x)
      ***        for intercept x and compare to point x where
      ***        x = longitude and y = latitude
      ***        =======================================================
                   move 'even' to crossings
                   perform varying node-idx from 1 by 1
                   until node-idx > node-max
                       evaluate true
                       when latitude >=
                       start-latitude(node-idx)
                       and end-latitude(node-idx)
                           continue
                       when latitude <=
                       start-latitude(node-idx)
                       and end-latitude(node-idx)
                           continue
                       when start-slope-type(node-idx) = 'h'
                           continue
                       when start-slope-type(node-idx) = 'v'
                       and longitude >=
                       start-longitude(node-idx)
                       and end-longitude(node-idx)
                           continue
                       when start-slope-type(node-idx) = 'v'
                            if crossings = 'even'
                                move 'odd' to crossings
                            else
                                move 'even' to crossings
                            end-if
                       when other
                           compute crossing-longitude =
                               end-longitude(node-idx)
                               + (latitude - end-latitude(node-idx))
                                 / start-slope(node-idx)
                           end-compute
                           if crossing-longitude > longitude
                               if crossings = 'even'
                                   move 'odd' to crossings
                               else
                                   move 'even' to crossings
                               end-if
                           end-if
                       end-evaluate
                   end-perform
                   if crossings = 'odd'
                       move city-country-code to sort-city-country-code
                       move featureclass to sort-feature
                       move city-population to sort-city-population
                       move trim(city-name) to sort-city-name
                       move latitude to sort-city-latitude
                       move longitude to sort-city-longitude
                       release sort-record
                   end-if
               end-evaluate
 
               read city-file end-read
               call 'checkfilestatus'
                   using city-file-name city-file-status end-call
           end-perform

           close city-file
           .
       sort-output.

           move 'n' to end-sort-file
           return sort-file at end
               move 'error: no cities selected' to run-line
               call 'printrunreport' using print-run-control end-call
               move 'close' to print-run-function
               call 'printrunreport' using print-run-control end-call
               stop run
           end-return

      *  load the country lookup table
           open input country-file
           call 'checkfilestatus'
               using country-file-name country-file-status end-call
           move 0 to country-max
           read country-file end-read
           call 'checkfilestatus'
               using country-file-name country-file-status end-call
           perform until country-file-status = '10'
           or country-max >= country-lim
               if country-record(1:1) <> '#'
                   add 1 to country-max end-add
                   unstring country-record delimited by tab into
                       iso(country-max)
                       iso3(country-max)
                       iso-numeric(country-max)
                       fips(country-max)
                       country(country-max)
                       capital(country-max)
                       areainsqkm(country-max)
                       population(country-max)
                       continent(country-max)
                       tld(country-max)
                       currencycode(country-max)
                       currencyname(country-max)
                       phone(country-max)
                       postalcodeformat(country-max)
                       postalcoderegex(country-max)
                       languages(country-max)
                       country-geonameid(country-max)
                       neighbours(country-max)
                       equivalentfipscode(country-max)
                   end-unstring
               end-if
               read country-file end-read
               call 'checkfilestatus'
                   using country-file-name country-file-status end-call
           end-perform
           close country-file
           evaluate true
           when country-max >= country-lim
               string 'error: countries file exceeds ' country-lim
                   ' records'
                   delimited by size into run-line end-string
               call 'printrunreport' using print-run-control end-call
               move 'close' to print-run-function
               call 'printrunreport' using print-run-control end-call
               stop run
           when country-max = 0
               string 'error: no country records loaded'
                   delimited by size into run-line end-string
               call 'printrunreport' using print-run-control end-call
               move 'close' to print-run-function
               call 'printrunreport' using print-run-control end-call
               stop run
           end-evaluate

      * define the color, size and icon of the featureclasses

      * define the A country style
           write kml-record from '<Style id="AStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff0000ff</color>' end-write
           write kml-record from '<scale>2</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/flag.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the H stream style
           write kml-record from '<Style id="HStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ffff0000</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/water.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the L park style
           write kml-record from '<Style id="LStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff00ff00</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/play.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the P city style
           write kml-record from '<Style id="PStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff0010ff</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'pal4/icon49.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the R road style
           write kml-record from '<Style id="RStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff008080</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/highway.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the S spot style
           write kml-record from '<Style id="SStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff808080</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/placemark_circle.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the T rock style
           write kml-record from '<Style id="TStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff707070</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/terrain.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the U undersea style
           write kml-record from '<Style id="UStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff800000</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/fishing.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * define the V forest style
           write kml-record from '<Style id="VStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff00ff00</color>' end-write
           write kml-record from '<scale>1</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'shapes/park.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '</Style>' end-write

      * process the data
           perform build-report-heading

           move 'features selected' to report-heading-1
           move 2 to report-skip-count
           perform varying fcx from 1 by 1
           until fcx > fcx-max
                perform varying features-idx from 1 by 1
                until features-idx > features-max
                or features(features-idx:1) = featureclasscode(fcx)
                    continue
                end-perform
                if features-idx <= features-max
                    move featureclass-line(fcx) to report-line(5:)
                    perform write-report-line
                end-if
           end-perform

           string
               'features with latitude and longitude in polygon '
                   delimited by size
               polygon-file-only delimited by space
               into report-line end-string
           move 2 to report-skip-count
           perform write-report-line
           move 2 to report-skip-count
           perform varying node-idx from 1 by 1
           until node-idx > node-max
      ***       we're suppressing compiler warning messages here
               compute report-latitude =
                   1 * start-latitude(node-idx) end-compute
               compute report-longitude =
                   1 * start-longitude(node-idx) end-compute
               move start-slope-type(node-idx) to report-slope-type
               move start-slope(node-idx) to report-slope
               perform write-report-line
           end-perform

           move 0 to city-count
           perform begin-country
           perform until end-sort-file = 'y'
               if sort-city-country-code <> current-country-code
                   perform end-country
                   perform begin-country
               end-if
               add 1 to city-count end-add

               move sort-city-population to report-city-population
               move sort-city-name to report-city-name
               move sort-city-latitude to report-latitude
               move sort-city-longitude to report-longitude

               write kml-record from '<Placemark>' end-write
               write kml-record from '<name></name>' end-write
               move spaces to kml-record
               string '<styleUrl>#'
                   sort-feature
                   'Style</styleUrl>'
                   delimited by size into kml-record end-string
               write kml-record end-write
      ***       the google-earth parser doesn't like & in the data
               inspect sort-city-name replacing all '&' by '+'
               move spaces to kml-record
               string '<description>'
                   trim(sort-city-name)
                   '</description>'
                   delimited by size into kml-record end-string
               write kml-record end-write
               move spaces to kml-record
               string '<Point><coordinates>'
                   trim(report-longitude)
                   ','
                   trim(report-latitude)
                   '</coordinates></Point>'
                   delimited by size into kml-record end-string
               write kml-record end-write
               write kml-record from'</Placemark>' end-write

               perform write-report-line

               return sort-file at end
                   move 'y' to end-sort-file
               end-return
           end-perform
           perform end-country

      ***   write the closing kml records
           write kml-record from '</Document>' end-write
           write kml-record from '</kml>' end-write

           close kml-file

           close report-file
           .
       begin-country.
           move sort-city-country-code to current-country-code
           perform varying country-idx from 1 by 1
           until country-idx > country-max
           or iso(country-idx) = current-country-code
               continue
           end-perform
           if country-idx > country-max
               move unknown-country to report-country-name
           else
               move country(country-idx) to report-country-name
           end-if
           move current-country-code to polygon-country-code
           move report-country-name to polygon-country-name
           move spaces to report-heading-1
           string report-country-name delimited by '  '
               ' (continued)' delimited by size
               into report-heading-1
           end-string
           move 2 to report-skip-count
           perform write-report-line
           .
       end-country.
           .
       build-report-heading.
           move trim(polygon-file-only) to report-title
           accept cd-date from date end-accept
           move cd-year to report-year
           move cd-month to report-month
           move cd-day-of-month to report-day-of-month
           accept ct-time from time end-accept
           move ct-hour to report-hour
           move ct-minute to report-minute
           move ct-second to report-second.
           move 0 to report-page-count
           move report-line-limit to report-line-count
           move 1 to report-skip-count
           .
       write-report-line.
           if report-line-count + report-skip-count > report-line-limit
               add 1 to report-page-count end-add
               move report-page-count to report-page
               if report-page-count = 1
                   open extend report-file
                   if report-file-status = '35'
                       open output report-file
                       write report-record from report-heading
                           after advancing 0 lines end-write
                   else
                       write report-record from report-heading
                           after advancing one-page end-write
                   end-if
               else
                   write report-record from report-heading
                       after advancing one-page end-write
               end-if
               write report-record from report-heading-1
                   after advancing 2 lines end-write
               move 3 to report-line-count
               move 2 to report-skip-count
           end-if
           write report-record from report-line
               after advancing report-skip-count lines end-write
           add report-skip-count to report-line-count end-add
           move 1 to report-skip-count
           move spaces to report-line
           .
       end program worldcities8.

