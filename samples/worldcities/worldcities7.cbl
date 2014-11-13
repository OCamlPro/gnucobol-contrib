       identification division.
       program-id. worldcities7.
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
      * modify worldcities6
      *
      * 1)  read a google-earth polygon.kml file
      *
      * this version removes the ocesql/postgresql code
      *
      *==================================================
      * How to create and save a google-earth polygon
      * (it's not obvious):
      *
      * 1. open google-earth and use search in the
      *    sidebar to go to a location
      * 2. click on the polygon icon in the toolbar
      *    (the third icon in the toolbar - it looks
      *     like a bent benzene ring)
      * 3. in the polygon sidebar give the polygon
      *    a name and style
      * 4. using discrete clicks (don't drag the mouse)
      *    define the polygon nodes in the display
      * 5. save the polygon (the save button is at the
      *    bottom of the polygon sidebar and may not be
      *    visible)
      * 6. the saved polygon name will appear at the
      *    bottom of the sidebar 
      * 7. right-click on the saved polygon name
      *    and select 'save place as. . .'
      * 8. save the polygon in the worldcities7 directory
      *    as a kml (not kmz) file.
      *==================================================
       environment division.
       configuration section.
       repository. function all intrinsic.
       special-names. c01 is one-page.
       input-output section.
       file-control.
      * =============================================
      *  download and unzip a cities file from
      *  http://download.geonames.org/export/dump/
      * =============================================
           select city-file
               assign to city-file-name
               file status is city-file-status
               organization is line sequential.

      * =============================================
      *  download countryinfo.txt from
      *  http://download.geonames.org/export/dump/
      * =============================================
            select country-file
               assign to country-file-name
               file status is country-file-status
               organization is line sequential.

            select report-file
               assign to report-file-name
               file status is report-file-status.

            select sort-file.

            select kml-file
               assign to 'kmlfile'
               organization is line sequential.

            select polygon-file
               assign to polygon-file-name
               file status is polygon-file-status
               organization is line sequential.

       data division.
       file section.
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
           03  sort-city-population pic 9(9).
           03  sort-city-name pic x(43).
           03  sort-city-latitude pic s9(3)v9(6).
           03  sort-city-longitude pic s9(3)v9(6).

       fd  kml-file.
       01  kml-record pic x(32000).

       working-storage section.
       01  command-file-name pic x(128) value 'worldcities7.sh'.
       01  techtonics.
           03  pic x(128) value 'rm run-file'.
           03  pic x(128) value 'rm report-file'.
           03  pic x(128) value '# Enter your print queue name here'.
           03  pic x(128) value
               'export PRINTQUEUE=Brother-HL-2170W-wireless'.
           03  pic x(128) value 'export FILES=$HOME/worldcityfiles'.
           03  pic x(128) value
               'cobc -x -W worldcities7.cbl commonroutines.cbl'.
           03  pic x(128) value
               'export kmlfile=$FILES/worldcities7.kml'.
           03  pic x(128) value 'rm $kmlfile'.
           03  pic x(128) value './worldcities7'
               & ' $FILES/allCountries.txt $FILES/countryInfo.txt'
               & ' $FILES/Vienna.kml'.
           03  pic x(128) value 'google-earth $kmlfile'.
           03  pic x(128) value 'rm worldcities7'.
           03  pic x(128) value 'lpr -P PRINTQUEUE run-file'.
           03  pic x(128) value 'lpr -P PRINTQUEUE report-file'.
           03  pic x(128) value 'end'.

       01  polygon-file-name pic x(64).
       01  polygon-file-only pic x(64).
       01  pcx pic 99.
       01  pcx-slash pic 99.
       01  polygon-file-status pic x(2).
       01  polygon-country-code pic X(3).
       01  polygon-country-name pic X(72).
       01  polygon-city-name pic X(43).
       01  polygon-latitude pic S9(3)V9(6).
       01  polygon-longitude pic S9(3)V9(6).
       01  polygon-population pic S9(9).
       
       01  delta-city-longitude pic s9(3)v9(6).
       01  crossing pic x(4).
       01  node-idx pic 9(3).
       01  node-max pic 9(3).
       01  node-lim pic 9(3) value 100.
       01  processing-coordinates pic x.
       01  polygon-pointer pic 9(5).
       01  max-longitude pic s9(3)v9(13).
       01  min-longitude pic s9(3)v9(13).
       01  max-latitude pic s9(3)v9(13).
       01  min-latitude pic s9(3)v9(13).
       01  kml-polygon.
           03  filler occurs 100.
               05  kml-longitude pic s9(3)v9(13).
               05  kml-latitude pic s9(3)v9(13).
               05  kml-altitude pic s9(5).
       01  start-edge redefines kml-polygon.
           03  filler occurs 99.
               05  start-longitude pic s9(3)v9(13).
               05  start-latitude pic s9(3)v9(13).
               05  start-altitude pic s9(5).
           03  filler.
               05  filler pic s9(3)v9(13).
               05  filler pic s9(3)v9(13).
               05  filler pic s9(5).
       01  end-edge redefines kml-polygon.
           03  filler.
               05  filler pic s9(3)v9(13).
               05  filler pic s9(3)v9(13).
               05  filler pic s9(5).
           03  filler occurs 99.
               05  end-longitude pic s9(3)v9(13).
               05  end-latitude pic s9(3)v9(13).
               05  end-altitude pic s9(5).

       01  end-sort-file pic x.

       01  print-run-control.
           03  print-run-function pic x(5) value 'open'.
           03  run-program-name pic x(31) value 'worldcities7'.
           03  run-line.
               05  display-count pic z,zzz,zzzb.
               05  display-elapsed-seconds redefines display-count
                   pic z(5)9.99b.
               05  display-message pic x(62).
           03  run-page-count pic 999.
           03  run-line-count pic 99.
           03  run-line-limit pic 99 value 55.
           03  run-skip-count pic 9.
           03  display-run-line pic x value 'y'.

       01  report-file-name pic x(64) value 'report-file'.
       01  report-file-status pic x(2).

       01  report-page-count pic 999.
       01  report-line-count pic 99.
       01  report-line-limit pic 99 value 55.
       01  report-skip-count pic 9.

       01  report-heading.
           03  program-name pic x(31) value 'worldcities7'.
           03  report-title pic x(14) value space.
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

       01  city-file-name pic x(64).
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

       01  tab pic x value x'09'.

       procedure division chaining
           city-file-name country-file-name polygon-file-name.
       start-worldcities7.

           call 'printrunreport' using print-run-control end-call

           move 'starting worldcities7' to run-line
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

           if city-file-name = 'techtonics'
               call 'techtonics' using
                   command-file-name techtonics end-call
               move 'close' to print-run-function
               call 'printrunreport' using print-run-control end-call
               stop run
           end-if

           move 0 to pcx-slash
           perform varying pcx from 1 by 1
           until polygon-file-name(pcx:) = spaces
               if polygon-file-name(pcx:1) = '/' or '\'
                   move pcx to pcx-slash
               end-if
           end-perform
           if pcx-slash = 0
               move polygon-file-name to polygon-file-only
           else
               add 1 to pcx-slash end-add
               move polygon-file-name(pcx-slash:) to polygon-file-only
           end-if

           accept ct-time from time end-accept
           compute start-seconds =
               ct-hour * 60 * 60
               + ct-minute * 60
               + ct-second
               + ct-hundredth / 100
           end-compute

           sort sort-file
               ascending key sort-city-country-code
                   sort-city-latitude
                   sort-city-longitude
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
           move 'input records' to display-message
           call 'printrunreport' using print-run-control end-call

           move city-count to display-count
           string 'cities in polygon ' delimited by size
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
           move 'ending worldcities7' to run-line
           call 'printrunreport' using print-run-control end-call

           move 'close' to print-run-function
           call 'printrunreport' using print-run-control end-call
           stop run
           .
       sort-input.
      * open the kml file
           open output kml-file
           
           move 0 to node-max
           move 'n' to processing-coordinates
           move 370 to min-longitude min-latitude
           move -370 to max-longitude max-latitude
           open input polygon-file

           string 'reading ' polygon-file-name
               delimited by size into run-line end-string
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

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
      *            don't laugh
                   perform until polygon-record = spaces
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
                       move spaces to polygon-record(1:polygon-pointer)
                       move trim(polygon-record) to polygon-record
                   end-perform
               end-evaluate
               read polygon-file end-read
               call 'checkfilestatus'
                   using polygon-file-name polygon-file-status end-call
           end-perform
           close polygon-file

           open input city-file
           call 'checkfilestatus'
               using city-file-name city-file-status end-call

           string 'reading ' city-file-name
               delimited by size into run-line end-string
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

           read city-file end-read
           call 'checkfilestatus'
               using city-file-name city-file-status end-call
           perform until city-file-status = '10'
               add 1 to input-count end-add

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

               if featureclass = 'P'
      *          =======================================================
      *          what's this? see //www.geonames.org/export/codes.html
      *              A : country, state, region,...
      *              H : stream, lake, ...
      *              L : parks,area, ...
      *              P : city, village,...
      *              R : road, railroad
      *              S : spot, building, farm
      *              T : mountain,hill,rock,...
      *              U : undersea
      *              V : forest,heath,...
      *          =======================================================
      *          this standard polygon inclusion algorithm traces a ray
      *          (in this case a horizontal ray) from the point in
      *          question to infinity (in this case positive infinity)
      *          if the ray doesn't cross any polygon edges or if it
      *          crosses an even number of polygon edges, the point is
      *          not in the polygon
      *          if the ray crosses an odd number of polygon edges the
      *          point is in the polygon
      *          =======================================================
      *          if the point is outside the min/max box don't check
      *          for inclusion in the polygon
      *          =======================================================

                   move 'even' to crossing
                   perform varying node-idx from 1 by 1
                   until node-idx > node-max
                   or latitude < min-latitude or > max-latitude
                   or longitude < min-longitude or > max-longitude
                       if (end-latitude(node-idx) < latitude
                           and start-latitude(node-idx) >= latitude)
                       or (start-latitude(node-idx) < latitude
                           and end-latitude(node-idx) >= latitude)
                           compute delta-city-longitude =
                               end-longitude(node-idx)
                               + (latitude
                                  - end-latitude(node-idx))
                                    /(start-latitude(node-idx)
                                      - end-latitude(node-idx))
                               * (start-longitude(node-idx)
                                  - end-longitude(node-idx))
                           end-compute
                           if delta-city-longitude < longitude
                               if crossing = 'even'
                                   move 'odd' to crossing
                               else
                                   move 'even' to crossing
                               end-if
                           end-if
                       end-if
                   end-perform

                   if crossing = 'odd'
                       move city-country-code to sort-city-country-code
                       move city-population to sort-city-population
                       move function trim(city-name,TRAILING)
                           to sort-city-name
                       move latitude to sort-city-latitude
                       move longitude to sort-city-longitude
                       release sort-record
                   end-if
               end-if

               read city-file end-read
               call 'checkfilestatus'
                   using city-file-name city-file-status end-call
           end-perform

           close city-file
           .
       sort-output.
      *open the sort-file
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

           string 'reading ' country-file-name
               delimited by size into run-line end-string
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

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

      * define the city style
           write kml-record from '<Style id="cityStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<color>ff0000ff</color>' end-write
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

      * process the data
           perform build-report-heading

           string 'cities with latitude and longitude in the polygon '
               delimited by size
               polygon-file-only delimited by space
               into report-heading-1 end-string
           perform varying node-idx from 1 by 1
           until node-idx > node-max
               compute report-latitude =
                   start-latitude(node-idx) end-compute
               compute report-longitude =
                   start-longitude(node-idx) end-compute
               move spaces to report-city-name
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
               perform write-report-line

               move sort-city-population to polygon-population
               move sort-city-name to polygon-city-name
               move sort-city-latitude to polygon-latitude
               move sort-city-longitude to polygon-longitude
               move polygon-latitude to report-latitude
               move polygon-longitude to report-longitude

               write kml-record from '<Placemark>' end-write
               write kml-record from '<name></name>' end-write
               write kml-record from
                   '<styleUrl>#cityStyle</styleUrl>' end-write
               move spaces to kml-record
               string '<description>'
                   trim(polygon-city-name)
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
               return sort-file at end
                   move 'y' to end-sort-file
               end-return
           end-perform
           perform end-country

      * close the kml file
           write kml-record from '</Document>' end-write
           write kml-record from '</kml>' end-write
           close kml-file

           move 'end of report' to report-line
           move 2 to report-skip-count
           perform write-report-line

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
           move 'polygon' to report-title
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
       end program worldcities7.

