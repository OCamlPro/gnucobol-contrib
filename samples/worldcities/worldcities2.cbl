       >> SOURCE FORMAT IS FREE
identification division.
program-id. worldcities2.
*> 
*>  Copyright (C) 2014 Steve Williams <stevewilliams38@gmail.com>
*> 
*>  This program is free software; you can redistribute it and/or
*>  modify it under the terms of the GNU General Public License as
*>  published by the Free Software Foundation; either version 2,
*>  or (at your option) any later version.
*>  
*>  This program is distributed in the hope that it will be useful,
*>  but WITHOUT ANY WARRANTY; without even the implied warranty of
*>  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*>  GNU General Public License for more details.
*>  
*>  You should have received a copy of the GNU General Public
*>  License along with this software; see the file COPYING.
*>  If not, write to the Free Software Foundation, Inc.,
*>  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

*> ============================================================
*> modify worldcities1.cbl
*>
*> 1) move the run count displays to a run print file
*> 2) move the country displays to a report print file
*> 3) define the report columns and headings in vertical strips
*> 4) use a common report printing structure
*> ============================================================

environment division.
configuration section.
repository. function all intrinsic.
special-names. C01 is one-page.
input-output section.
file-control.
*> =============================================
*>  download and unzip a cities file from
*>  http://download.geonames.org/export/dump/
*> =============================================
    select city-file
        assign to city-file-name
        file status is city-file-status
        organization is line sequential.

*> =============================================
*>  download countryInfo.txt from
*>  http://download.geonames.org/export/dump/
*> =============================================
     select country-file
        assign to country-file-name
        file status is country-file-status
        organization is line sequential.

     select run-file
        assign to run-file-name
        file status is run-file-status.

     select report-file
        assign to report-file-name
        file status is report-file-status.

data division.
file section.
fd  run-file.
01  run-record pic x(72).

fd  report-file.
01  report-record pic x(72).

fd  country-file.
01  country-record pic x(1000).

fd  city-file.
01  city-record pic x(1000).

working-storage section.
01  command-file-name pic x(128) value 'worldcities2.sh'.
01  techtonics.
    03  pic x(128) value 'rm run-file'.
    03  pic x(128) value 'rm report-file'.
    03  pic x(128) value '# Enter your print queue name here'.
    03  pic x(128) value 'export PRINTQUEUE=Brother-HL-2170W-wireless'.
    03  pic x(128) value 'export FILES=$HOME/worldcityfiles'.
    03  pic x(128) value 'cobc -x -W -free worldcities2.cbl'.
    03  pic x(128) value
        './worldcities2 $FILES/cities15000.txt $FILES/countryInfo.txt'.
    03  pic x(128) value 'rm worldcities2'.
    03  pic x(128) value 'lpr -P $PRINTQUEUE run-file'.
    03  pic x(128) value 'lpr -P $PRINTQUEUE report-file'.
    03  pic x(128) value 'end'.

01  run-file-name pic x(64) value 'run-file'.
01  run-file-status pic x(2).

01  run-page-count pic 999.
01  run-line-count pic 99.
01  run-line-limit pic 99 value 55.
01  run-skip-count pic 9.
01  display-run-line pic x value 'y'.

01  run-heading.
    03  program-name pic x(31) value 'worldcities2'.
    03  filler pic x(14) value 'run report'.
    03  run-date.
        05  run-month pic xx.
        05  filler pic x value '/'.
        05  run-day-of-month pic xx.
        05  filler pic x value '/'.
        05  run-year pic xx.
    03  filler pic x value space. 
    03  run-time.
        05  run-hour pic xx.
        05  filler pic x value ':'.
        05  run-minute pic xx.
        05  filler pic x value "'".
        05  run-second pic xx.
        05  filler pic x value '"'.
   03  filler pic x value space.
   03  filler pic x(5) value 'page'.
   03  run-page pic zz9.

01  run-line.
    03  display-count pic z,zzz,zzzb.
    03  display-elapsed-seconds redefines display-count pic zz,zz9.99b.
    03  display-message pic x(62).

01  report-file-name pic x(64) value 'report-file'.
01  report-file-status pic x(2).

01  report-page-count pic 999.
01  report-line-count pic 99.
01  report-line-limit pic 99 value 55.
01  report-skip-count pic 9.

01  report-heading.
    03  program-name pic x(31) value 'worldcities2'.
    03  filler pic x(14) value 'world cities'.
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
        05  filler pic x value '"'.
   03  filler pic x value space.
   03  filler pic x(5) value 'page'.
   03  report-page pic zz9.

*> note that these report columns and headings
*> are defined in vertical strips

01  report-heading-1.
    03  filler pic x(8) value 'country'.
    03  filler pic x(8) value spaces.
    03  filler pic x(12) value '     cities'.
    03  filler pic x(44) value spaces.

01  report-heading-2.
    03  filler pic x(8) value 'code'.
    03  filler pic x(8) value ' cities'.
    03  filler pic x(12) value ' population'.
    03  filler pic x(44) value 'country'.

01  report-heading-3.
    03  filler pic x(8) value '======='.
    03  filler pic x(8) value '======='.
    03  filler pic x(12) value '==========='.
    03  filler pic x(44) value all '='.

01  report-line.
    03  report-country-code pic x(8).
    03  report-city-count pic zzz,zz9b.
    03  report-population pic zzz,zzz,zz9b.
    03  report-country-name pic x(44).

01  country-file-name pic x(64).
01  country-file-status pic x(2).

01  country-idx pic 9(3).
01  country-max pic 9(3).
01  country-lim pic 9(3) value 900.
01  unknown-country pic x(44) value 'UNKNOWN COUNTRY'.
01  country-table.
    03  country-entry occurs 900.
        05  ISO pic x(2).
        05  ISO3 pic x(3).
        05  ISO-Numeric	pic 9(3).
        05  fips pic x(2).
        05  Country pic x(64).
        05  Country-length pic 9(3).
        05  Capital pic x(64).
        05  AreaInSqKm pic 9(12).
        05  Population pic 9(12).
        05  Continent pic x(2).
        05  tld pic x(3).
        05  CurrencyCode pic x(3).
        05  CurrencyName pic x(16).
        05  Phone pic x(16).
        05  PostalCodeFormat pic x(16).
        05  PostalCodeRegex pic x(16).
        05  Languages pic x(100).
        05  country-geonameid pic 9(9).
        05  neighbours pic x(100).
        05  EquivalentFipsCode pic x(2).

01  city-file-name pic x(64).
01  city-file-status pic x(2).

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
01  current-country-name pic x(44).
01  current-city-count pic 9(6).
01  display-current-city-count pic zzz,zz9.
01  total-city-population pic 9(9).
01  display-total-city-population pic zzz,zzz,zz9.

01  newline pic x value x'0A'.
01  tab pic x value x'09'.

01  ct-time.
    03  ct-hour pic 99.
    03  ct-minute pic 99.
    03  ct-second pic 99.
    03  ct-hundredth pic 99.

01  cd-date.
    03  cd-year pic xx.
    03  cd-month pic xx.
    03  cd-day-of-month pic xx.

01  start-seconds pic 9(7)v99.
01  end-seconds pic 9(7)v99.
01  elapsed-seconds pic 9(5)v99.

procedure division chaining city-file-name country-file-name.
start-worldcities2.
    perform build-run-heading

    move 'starting worldcities2' to run-line
    move 2 to run-skip-count
    perform write-run-line

    if city-file-name = 'techtonics'
        call 'techtonics' using command-file-name techtonics end-call
        close run-file
        stop run
    end-if

*>  load the countries lookup table

    string 'reading ' delimited by size
        country-file-name delimited by space
        into run-line end-string
    move 2 to run-skip-count
    perform write-run-line

    open input country-file
    call 'checkfilestatus' using country-file-name country-file-status end-call

    move 0 to country-max
    read country-file end-read
    call 'checkfilestatus' using country-file-name country-file-status end-call
    perform until country-file-status = '10'
    or country-max >= country-lim
        if country-record(1:1) <> '#'
            add 1 to country-max end-add
            unstring country-record delimited by tab into
                ISO(country-max)
                ISO3(country-max)
                ISO-Numeric(country-max)
                fips(country-max)
                Country(country-max) count in Country-length(country-max)
                Capital(country-max)
                AreaInSqKm(country-max)
                Population(country-max)
                Continent(country-max)
                tld(country-max)
                CurrencyCode(country-max)
                CurrencyName(country-max)
                Phone(country-max)
                PostalCodeFormat(country-max)
                PostalCodeRegex(country-max)
                Languages(country-max)
                country-geonameid(country-max)
                neighbours(country-max)
                EquivalentFipsCode(country-max)
            end-unstring
        end-if
        read country-file end-read
        call 'checkfilestatus' using country-file-name country-file-status end-call
    end-perform
    close country-file
    evaluate true
    when country-max >= country-lim
        display 'ERROR: countries file exceeds ' country-lim ' records' end-display
        stop run
    when country-max = 0
        display 'ERROR: no country records loaded' end-display
        stop run
    end-evaluate

    perform build-report-heading

    string 'reading ' delimited by size
        city-file-name delimited by space
        into run-line end-string
    move 2 to run-skip-count
    perform write-run-line
    move 'selecting featureclass P : city, village,...'
        to run-line
    move 2 to run-skip-count
    perform write-run-line 	

    open input city-file
    call 'checkfilestatus' using city-file-name city-file-status end-call

    accept ct-time from time end-accept
    compute start-seconds =
        ct-hour * 60 * 60
        + ct-minute * 60
        + ct-second
        + ct-hundredth / 100
    end-compute

    read city-file end-read
    call 'checkfilestatus' using city-file-name city-file-status end-call
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
*>          ==========================================================
*>          what's this? see //www.geonames.org/export/codes.html
*>              A : country, state, region,...
*>              H : stream, lake, ...
*>              L : parks,area, ...
*>              P : city, village,...
*>              R : road, railroad 
*>              S : spot, building, farm
*>              T : mountain,hill,rock,... 
*>              U : undersea
*>              V : forest,heath,...
*>          ==========================================================
            if city-country-code <> current-country-code
                perform end-country
                perform begin-country
            end-if

            add 1 to current-city-count end-add
            add city-population to total-city-population end-add
        end-if

        read city-file end-read
        call 'checkfilestatus' using city-file-name city-file-status end-call
    end-perform
    perform end-country

    accept ct-time from time end-accept
    compute end-seconds =
        ct-hour * 60 * 60
        + ct-minute * 60
        + ct-second
        + ct-hundredth / 100
    end-compute

    close city-file

    move 'end of report' to report-line
    move 2 to report-skip-count
    perform write-report-line
    close report-file

    move 2 to run-skip-count
    move country-max to display-count
    move 'country codes loaded' to display-message
    perform write-run-line

    move 2 to run-skip-count
    move country-count to display-count
    move 'countries found' to display-message
    perform write-run-line

    move 2 to run-skip-count
    move input-count to display-count
    move 'input records' to display-message
    perform write-run-line

    compute elapsed-seconds = end-seconds - start-seconds end-compute
    move elapsed-seconds to display-elapsed-seconds
    move 'elapsed seconds' to display-message
    perform write-run-line

    compute display-count = input-count / elapsed-seconds
        on size error move 0 to display-count
    end-compute
    move 'records per second' to display-message
    perform write-run-line
    
    move 2 to run-skip-count
    move 'ending worldcities2' to run-line
    perform write-run-line

    close run-file
    stop run
    .
begin-country.
    move city-country-code to current-country-code
    move zero to current-city-count total-city-population

*>  lookup without the search verb
    perform varying country-idx from 1 by 1
    until country-idx > country-max
    or ISO(country-idx) = current-country-code
        continue
    end-perform

    if country-idx > country-max
        move unknown-country to current-country-name
    else
*>      we use trim here to suppress a compiler warning message
        move function trim(Country(country-idx),TRAILING) to current-country-name
    end-if
    .
end-country.
    if current-country-code <> spaces
        add 1 to country-count end-add
        move current-country-code to report-country-code
        move current-city-count to report-city-count
        move total-city-population to report-population
        move current-country-name to report-country-name
        perform write-report-line
    end-if
    .
build-run-heading.
    accept cd-date from date end-accept
    move cd-year to run-year
    move cd-month to run-month
    move cd-day-of-month to run-day-of-month
    accept ct-time from time end-accept
    move ct-hour to run-hour
    move ct-minute to run-minute
    move ct-second to run-second.
    move 0 to run-page-count
    move run-line-limit to run-line-count
    move 1 to run-skip-count
    .
write-run-line.
    if run-line-count + run-skip-count > run-line-limit
        add 1 to run-page-count end-add
        move run-page-count to run-page
        if run-page-count = 1
            open extend run-file
            if run-file-status = '35'
                open output run-file
                write run-record from run-heading after advancing 0 lines end-write
            else
                write run-record from run-heading after advancing one-page end-write
            end-if
        else
            write run-record from run-heading after advancing one-page end-write
        end-if
        move 1 to run-line-count
        move 2 to run-skip-count
    end-if
    write run-record from run-line after advancing run-skip-count lines end-write
    add run-skip-count to run-line-count end-add
    move 1 to run-skip-count
    if display-run-line = 'y'
        display run-line end-display
    end-if
    move spaces to run-line
    .
build-report-heading.
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
                write report-record from report-heading after advancing 0 lines end-write
            else
                write report-record from report-heading after advancing one-page end-write
            end-if
        else
            write report-record from report-heading after advancing one-page end-write
        end-if
        write report-record from report-heading-1 after advancing 2 lines end-write
        write report-record from report-heading-2 after advancing 1 line end-write
        write report-record from report-heading-3 after advancing 1 line end-write
        move 5 to report-line-count
        move 2 to report-skip-count
    end-if
    write report-record from report-line after advancing report-skip-count lines end-write
    add report-skip-count to report-line-count end-add
    move 1 to report-skip-count
    move spaces to report-line
    .
copy checkfilestatus.

identification division.
program-id. techtonics.
environment division.
input-output section.
file-control.
    select command-file
        assign to command-file-name
        organization is line sequential.
data division.
file section.
fd  command-file.
01  command-record pic x(128).
working-storage section.
01  tcx pic 99.
linkage section.
01  command-file-name pic x(128).
01  techtonics.
    03  techtonics-line pic x(128) occurs 30.
procedure division using command-file-name techtonics.
start-techtonics.
    display 'creating command-file '
        command-file-name end-display
    open output command-file
    perform varying tcx from 1 by 1
    until tcx > 30
    or techtonics-line(tcx) = 'end'
        write command-record
            from techtonics-line(tcx) end-write
    end-perform
    close command-file
    display space end-display
    goback
    .
end program techtonics.

end program worldcities2.

