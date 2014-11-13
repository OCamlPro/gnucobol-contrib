       identification division.
       program-id. worldcities6.
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
      * modify worldcities5
      *
      * 1)  read a postgresql table
      * 2)  create a kml file for google-earth
      * 3)  write a CSV file
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
               assign to kml-file-name
               organization is line sequential.

            select csv-file
               assign to csv-file-name
               file status is csv-file-status
               organization is line sequential.

       data division.
       file section.
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
       01  kml-record pic x(72).

       fd  csv-file.
       01  csv-record.
           03  csv-country-code pic X(2).
           03  filler pic x.
           03  csv-country-name pic X(72).
           03  filler pic x.
           03  csv-city-name pic X(43).
           03  filler pic x.
           03  csv-latitude pic -9(3).9(6) sign leading separate.
           03  filler pic x.
           03  csv-longitude pic -9(3).9(6) sign leading separate.
           03  filler pic x.
           03  csv-population pic 9(9).

       working-storage section.
       01  command-file-name pic x(128) value "worldcities6.sh".
       01  techtonics.
           03  pic x(128) value "rm run-file".
           03  pic x(128) value "rm report-file".
           03  pic x(128) value
               "export PRINTQUEUE=Brother-HL-2170W-wireless".
           03  pic x(128) value "export FILES=$HOME/worldcityfiles".
           03  pic x(128) value
               "cat $FILES/CA.txt $FILES/US.txt > $FILES/CAUS.txt".
           03  pic x(128) value
               "ocesql worldcities6.cbl worldcities6.cob".
           03  pic x(128) value
               "cobc -x -W worldcities6.cob commonroutines.cbl".
           03  pic x(128) value
               "export COB_PRE_LOAD=/usr/local/lib/libocesql.so".
           03  pic x(128) value "rm $FILES/worldcities6.kml".
           03  pic x(128) value "rm $FILES/worldcities6.csv".
           03  pic x(128) value
               "export CITY=$FILES/CAUS.txt".
           03  pic x(128) value
               "export COUNTRY=$FILES/countryInfo.txt".
           03  pic x(128) value
               "export KML=$FILES/worldcities6.kml".
           03  pic x(128) value
               "export CSV=$FILES/worldcities6.csv".
           03  pic x(128) value
               "./worldcities6 $CITY $COUNTRY $KML $CSV".
           03  pic x(128) value "google-earth $KML".
           03  pic x(128) value "rm worldcities6.cob".
           03  pic x(128) value "rm worldcities6".
           03  pic x(128) value "lpr -P PRINTQUEUE run-file".
           03  pic x(128) value "lpr -P PRINTQUEUE report-file".
           03  pic x(128) value "end".

       01  kml-file-name pic x(64).
       01  csv-file-name pic x(64).
       01  csv-file-status pic x(2).
       01  csv-count pic 9(5) value 0.

       01  delta-city-longitude pic s9(3)v9(6).

       01  crossing pic x(4).
       01  node-idx pic 9.
       01  node-max pic 9 value 5.
      *=========================================
      * www.distancesfrom.com will help you here
      *=========================================
       01  polygon.
           03  filler pic x(32) value 'thunder bay'.
           03  filler pic s9(3)v9(6) value 48.380895.
           03  filler pic s9(3)v9(6) value -89.247682.

           03  filler pic x(32) value 'ignace'.
           03  filler pic s9(3)v9(6) value 49.415946.
           03  filler pic s9(3)v9(6) value -91.658744.

           03  filler pic x(32) value 'emo'.
           03  filler pic s9(3)v9(6) value 48.632219.
           03  filler pic s9(3)v9(6) value -93.835025.

           03  filler pic x(32) value 'grand rapids'.
           03  filler pic s9(3)v9(6) value 47.237165.
           03  filler pic s9(3)v9(6) value -93.530214.

           03  filler pic x(32) value 'duluth'.
           03  filler pic s9(3)v9(6) value 46.786671.
           03  filler pic s9(3)v9(6) value -92.100485.

           03  filler pic x(32) value 'thunder bay'.
           03  filler pic s9(3)v9(6) value 48.380895.
           03  filler pic s9(3)v9(6) value -89.247682.

       01  start-edge redefines polygon.
           03  filler occurs 5.
               05  start-city-name pic x(32).
               05  start-latitude pic s9(3)v9(6).
               05  start-longitude pic s9(3)v9(6).
           03  filler.
               05  filler pic x(32).
               05  filler pic s9(3)v9(6).
               05  filler pic s9(3)v9(6).

       01  end-edge redefines polygon.
           03  filler.
               05  filler pic x(32).
               05  filler pic s9(3)v9(6).
               05  filler pic s9(3)v9(6).
           03  filler occurs 5.
               05  end-city pic x(32).
               05  end-latitude pic s9(3)v9(6).
               05  end-longitude pic s9(3)v9(6).

       01  end-sort-file pic x.

       01  print-run-control.
           03  print-run-function pic x(5) value 'open'.
           03  run-program-name pic x(31) value 'worldcities6'.
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
           03  program-name pic x(31) value 'worldcities6'.
           03  report-title pic x(14) value space.
           03  report-date.
               05  report-month pic xx.
               05  filler pic x value "/".
               05  report-day-of-month pic xx.
               05  filler pic x value "/".
               05  report-year pic xx.
           03  filler pic x value space.
           03  report-time.
               05  report-hour pic xx.
               05  filler pic x value ":".
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

       01  country-file-name pic x(64) value 'countryfile'.
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
               05  country-geonameid binary-long.
               05  neighbours pic x(100).
               05  equivalentfipscode pic x(2).

       01  city-file-name pic x(64) value 'cityfile'.
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

       01  current-country-code pic x(2) value space.

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

      * pic X must be upper case
       exec sql begin declare section end-exec.
       01  dbname pic X(30).
       01  username pic X(30).
       01  password pic X(10).
       01  polygon-country-code pic X(2).
       01  polygon-country-name pic X(72).
       01  polygon-city-name pic X(43).
       01  polygon-latitude pic S9(3)V9(6).
       01  polygon-longitude pic S9(3)V9(6).
       01  polygon-population pic S9(9).
       exec sql end declare section end-exec.

       exec sql include sqlca end-exec.

       01  tab pic x value x"09".

       procedure division.
       start-worldcities6.
           call 'printrunreport' using print-run-control end-call

           move 'starting worldcities6' to run-line
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

           accept city-file-name from argument-value end-accept
           if city-file-name = 'techtonics'
               call 'techtonics' using
                   command-file-name techtonics end-call
               move 'close' to print-run-function
               call 'printrunreport' using print-run-control end-call
               stop run
           end-if

           accept country-file-name from argument-value end-accept
           accept kml-file-name from argument-value end-accept
           accept csv-file-name from argument-value end-accept

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
           move csv-count to display-count
           move 'csv records' to display-message
           call 'printrunreport' using print-run-control end-call

           move 2 to run-skip-count
           move input-count to display-count
           move 'input records' to display-message
           call 'printrunreport' using print-run-control end-call

           move city-count to display-count
           move 'cities in the polygon' to display-message
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
           move 'ending worldcities6' to run-line
           call 'printrunreport' using print-run-control end-call

           move 'close' to print-run-function
           call 'printrunreport' using print-run-control end-call
           stop run
           .
       sort-input.
           open input city-file
           call 'checkfilestatus'
               using city-file-name city-file-status end-call

           string 'reading ' city-file-name
               delimited by size into run-line end-string
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

           string 'selecting ' 'p : city, village,...'
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
      *              a : country, state, region,...
      *              h : stream, lake, ...
      *              l : parks,area, ...
      *              p : city, village,...
      *              r : road, railroad
      *              s : spot, building, farm
      *              t : mountain,hill,rock,...
      *              u : undersea
      *              v : forest,heath,...
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
                   move 'even' to crossing
                   perform varying node-idx from 1 by 1
                   until node-idx > node-max
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

      * open the kml file
           open output kml-file

           string 'writing ' kml-file-name delimited by size
               into run-line end-string
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

           write kml-record from
               '<?xml version="1.0" encoding="UTF-8"?>' end-write
           write kml-record from
               '<kml xmlns="http://www.opengis.net/kml/2.2">' end-write
           write kml-record from '<Document>' end-write
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
      * define the polygon style
           write kml-record from '<Style id="polygonStyle">' end-write
           write kml-record from '<IconStyle>' end-write
           write kml-record from '<scale>2</scale>' end-write
           write kml-record from '<Icon>' end-write
           move spaces to kml-record
           string '<href>http://maps.google.com/mapfiles/kml/'
               'paddle/grn-blank.png</href>'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</Icon>' end-write
           write kml-record from '</IconStyle>' end-write
           write kml-record from '<LineStyle>' end-write
           write kml-record from '<color>ff00ff00</color>' end-write
           write kml-record from '<width>15</width>' end-write
           write kml-record from '</LineStyle>' end-write
           write kml-record from '</Style>' end-write

      * show the polygon
           write kml-record from '<Placemark>' end-write
           write kml-record from '<name>Polygon</name>' end-write
           write kml-record from
               '<styleUrl>#polygonStyle</styleUrl>' end-write
           write kml-record from '<Polygon>' end-write
           write kml-record from
               '<altitudeMode>clampToGround</altitudeMode>' end-write
           write kml-record from '<outerBoundaryIs>' end-write
           write kml-record from '<LinearRing>' end-write
           write kml-record from '<coordinates>' end-write

           perform build-report-heading

           move 'cities with latitude and longitude in the polygon'
               to report-heading-1
           perform varying node-idx from 1 by 1
           until node-idx > node-max
               move start-latitude(node-idx) to report-latitude
               move start-longitude(node-idx) to report-longitude
               move start-city-name(node-idx) to report-city-name
               move spaces to kml-record
               string trim(report-longitude)
                   ','
                   trim(report-latitude)
                   ',0'
                   delimited by size into kml-record end-string
               write kml-record end-write
               perform write-report-line
           end-perform

      * Close the polygon
           move start-latitude(1) to report-latitude
           move start-longitude(1) to report-longitude
           move spaces to kml-record
           string trim(report-longitude)
               ','
               trim(report-latitude)
               ',0'
               delimited by size into kml-record end-string
           write kml-record end-write
           write kml-record from '</coordinates>' end-write
           write kml-record from '</LinearRing>' end-write
           write kml-record from '</outerBoundaryIs>' end-write
           write kml-record from '</Polygon>' end-write
           write kml-record from '</Placemark>' end-write

      * Show the polygon nodes
           perform varying node-idx from 1 by 1
           until node-idx > node-max
               move start-latitude(node-idx) to report-latitude
               move start-longitude(node-idx) to report-longitude
               move start-city-name(node-idx) to report-city-name
               write kml-record from '<Placemark>' end-write
               string '<name>'
                   trim(report-city-name)
                   '</name>'
                   delimited by size into kml-record end-string
               write kml-record end-write
               write kml-record from
                   '<styleUrl>#polygonStyle</styleUrl>' end-write
               move spaces to kml-record
               string '<Point><coordinates>'
                   trim(report-longitude)
                   ','
                   trim(report-latitude)
                   '</coordinates></Point>'
                   delimited by size into kml-record end-string
               write kml-record end-write
               write kml-record from'</Placemark>' end-write
           end-perform

      *  open the database connection
           move 'testdb' to dbname
           move 'stevew' to username
           move spaces to password
           exec sql
               connect :username identified BY :password using :dbname
           end-exec
           if sqlstate <> zeros
               move 'error: testdb database connection failed'
                   to run-line
               perform sql-error
           end-if

      *  drop the table
           exec sql
               drop table polygon
           end-exec
           if sqlstate <> zeros
               move 'warning: drop polygon table failed' to run-line
               call 'printrunreport' using print-run-control end-call
               exec sql
                   rollback
               end-exec
           end-if

      *  create the table
           exec sql
               create table polygon(
                   polygoncountrycode char(2)
                  ,polygoncountryname varchar(72)
                  ,polygoncityname varchar(43)
                  ,polygonlatitude double precision
                  ,polygonlongitude double precision
                  ,polygonpopulation integer
               )
           end-exec
           if sqlstate <> zeros
               move 'error: create polygon table failed' to run-line
               perform sql-error
           end-if

      * declare cursor
      *    the SELECT must be in upper case,
      *    otherwise, no code is generated
           exec sql 
               declare pg cursor for
               SELECT polygoncountrycode
                   ,polygoncountryname
                   ,polygoncityname
                   ,polygonlatitude
                   ,polygonlongitude
                   ,polygonpopulation
               from polygon
           end-exec
           if sqlstate <> zeros and spaces
               move 'error: declare cursor failed' to run-line
               perform sql-error
           end-if

           open output csv-file
           call 'checkfilestatus'
               using csv-file-name csv-file-status end-call

           string 'writing ' csv-file-name delimited by size
               into run-line end-string
           move 2 to run-skip-count
           call 'printrunreport' using print-run-control end-call

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
               exec sql
                   INSERT into polygon values(
                        :polygon-country-code
                       ,:polygon-country-name
                       ,:polygon-city-name
                       ,:polygon-latitude
                       ,:polygon-longitude
                       ,:polygon-population
                       )
               end-exec
               if sqlstate <> zeros
                   move 'error: polygon insert failed' to run-line
                   perform sql-error
               end-if
               return sort-file at end
                   move 'y' to end-sort-file
               end-return
           end-perform
           perform end-country

           exec sql commit work end-exec
           if sqlstate <> zeros
               move 'error: polygon commit failed' to run-line
               perform sql-error
           end-if

      * open cursor
           exec sql open pg end-exec
           if sqlstate <> zeros
               move 'error: open polygoncursor failed'
                   to run-line
               perform sql-error
           end-if

      * Read the polygon table
           exec sql 
           fetch pg into
               :polygon-country-code
              ,:polygon-country-name
              ,:polygon-city-name
              ,:polygon-latitude
              ,:polygon-longitude
              ,:polygon-population
           end-exec
           perform until sqlstate <> zeros
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

               move all ';' to csv-record
               move polygon-country-code to csv-country-code
               move polygon-country-name to csv-country-name
               move polygon-city-name to csv-city-name
               move polygon-latitude to csv-latitude
               move polygon-longitude to csv-longitude
               move polygon-population to csv-population
               write csv-record end-write
               call 'checkfilestatus'
                   using csv-file-name csv-file-status end-call
               add 1 to csv-count end-add
         
               exec sql 
               fetch pg into
                   :polygon-country-code
                  ,:polygon-country-name
                  ,:polygon-city-name
                  ,:polygon-latitude
                  ,:polygon-longitude
                  ,:polygon-population
               end-exec
           end-perform
           if sqlstate <> '02000' 
               move 'normal end of polygon cursor not found'
                   to run-line
               perform sql-error
           end-if

      * close the csv file
           close csv-file

      * close the kml file
           write kml-record from '</Document>' end-write
           write kml-record from '</kml>' end-write
           close kml-file

      * Close the cursor
           exec sql close pg end-exec 
           if sqlstate <> zeros and spaces
               move 'error: cursor close failed' to run-line
               perform sql-error
           end-if

           exec sql commit work end-exec
           if sqlstate <> zeros
               move 'error: polygon commit failed' to run-line
               perform sql-error
           end-if

           exec sql disconnect all end-exec
           if sqlstate <> zeros
               move 'error: disconnect failed' to run-line
               perform sql-error
           end-if

           move 'end of report' to report-line
           move 2 to report-skip-count
           perform write-report-line
           close report-file
           .
       sql-error.
           call 'printrunreport' using print-run-control end-call
           string 'sqlstate: ' sqlstate
              delimited by size into run-line end-string
           call 'printrunreport' using print-run-control end-call
           evaluate true
           when sqlstate = '02000'
               move 'record not found' to run-line
           when sqlstate = '08003'
           when sqlstate = '08001'
               move 'connection failed' to run-line
           when sqlstate = spaces
               move 'undefined error' to run-line
           when other
               string 'sqlerrmc: ' sqlerrmc
                   delimited by size into run-line end-string
           end-evaluate
           call 'printrunreport' using print-run-control end-call
           move 'close' to print-run-function
           call 'printrunreport' using print-run-control end-call
           stop run
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
       end program worldcities6.

