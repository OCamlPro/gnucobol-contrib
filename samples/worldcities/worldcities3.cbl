       >> SOURCE FORMAT IS FREE
identification division.
program-id. worldcities3.
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

*>=============================================================
*>  modify worldcities2.cbl
*>
*>  1) select cities in a given continent
*>  2) show the top 3 cities by population in each country
*>  3) check for an end of page widow when printing the report 
*>  4) move checkfilestatus and printrunreport to a common
*>     source file
*>
*>     the idea of printing a runfile is that every (batch)
*>     cobol program needs to report run statistics, comments
*>     and possibly error messages in a runfile rather than
*>     to stdlist.
*>
*>     Also, if you're using COBOL screens, you can't display
*>     comments and messages to $STDLIST, so they go in the
*>     runfile
*>
*>     note that runfile is written open extend, so
*>     a batch of run reports will reside in a single file
*>
*>     we define a 'universal' printrunreport subprogram to
*>     create this 'common' runfile usable by any (batch)
*>     cobol program.
*>
*>     we don't do the same for an application report-file,
*>     although its programming has a similar structure,
*>     because its variable headings and lines make it hard to
*>     standardize.
*>
*>  5) See the comment in the procedure division about my COBOL
*>     design error and its correction.
*>=============================================================

environment division.
configuration section.
repository. function all intrinsic.
special-names. C01 is one-page.
input-output section.
file-control.
*> =============================================
*>  download and unzip a cities file from
*>  http://download.geonames.org/export/dump/
*> ============================================
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

     select report-file
        assign to report-file-name
        file status is report-file-status.

     select sort-file.

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
    03  sort-country-code pic x(2).
    03  sort-country-name pic x(64).
    03  sort-city-name pic x(55).
    03  sort-city-population pic 9(9).

working-storage section.
01  command-file-name pic x(128) value 'worldcities3.sh'.
01  techtonics.
    03  pic x(128) value 'rm run-file'.
    03  pic x(128) value 'rm report-file'.
    03  pic x(128) value '# Enter your print queue name here'.
    03  pic x(128) value 'export PRINTQUEUE=Brother-HL-2170W-wireless'.
    03  pic x(128) value 'export FILES=$HOME/worldcityfiles'.
    03  pic x(128) value '# Valid continent entries are'.
    03  pic x(128) value '# Africa'.
    03  pic x(128) value '# Asia'.
    03  pic x(128) value '# Europe'.
    03  pic x(128) value '# NorthAmerica'.
    03  pic x(128) value '# Oceania'.
    03  pic x(128) value '# SouthAmerica'.
    03  pic x(128) value '# Antarctica'.
    03  pic x(128) value
        'cobc -x -W worldcities3.cbl commonroutines.cbl'.
    03  pic x(128) value './worldcities3'
        & ' $FILES/allCountries.txt $FILES/countryInfo.txt'
        & ' ErrorContinent'.
    03  pic x(128) value './worldcities3'
        & ' $FILES/allCountries.txt $FILES/countryInfo.txt Oceania'.
    03  pic x(128) value 'rm worldcities3'.
    03  pic x(128) value 'lpr -P $PRINTQUEUE run-file'.
    03  pic x(128) value 'lpr -P $PRINTQUEUE report-file'.
    03  pic x(128) value 'end'.

01  selected-continent-name pic x(16).
01  cdx pic 9.
01  cdx-lim pic 9 value 7.
01  continents.
    03 filler pic x(16) value 'Africa'.
    03 filler pic x(2) value 'AF'.
    03 filler pic x(16) value 'Asia'.
    03 filler pic x(2) value 'AS'.
    03 filler pic x(16) value 'Europe'.
    03 filler pic x(2) value 'EU'.
    03 filler pic x(16) value 'NorthAmerica'.
    03 filler pic x(2) value 'NA'.
    03 filler pic x(16) value 'Oceania'.
    03 filler pic x(2) value 'OC'.
    03 filler pic x(16) value 'SouthAmerica'.
    03 filler pic x(2) value 'SA'.
    03 filler pic x(16) value 'Antarctica'.
    03 filler pic x(2) value 'AN'.
01  filler redefines continents.
    03  filler occurs 7.
        05  continent-name pic x(16).
        05  continent-code pic xx.

01  end-sort-file pic x.

01  print-run-control.
    03  print-run-function pic x(5) value 'open'.
    03  run-program-name pic x(31) value 'worldcities3'.
    03  run-line.
        05  display-count pic z,zzz,zzzb.
        05  display-elapsed-seconds redefines display-count pic zz,zz9.99b.
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
    03  program-name pic x(19) value 'worldcities3'.
    03  report-title pic x(26) value space.
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

01  report-heading-1.
    03  filler pic x(72) value
        'three largest cities with population data'.

01  report-line.
    03  filler pic x(5).
    03  report-city-population pic z,zzz,zz9b.
    03  report-city-name pic x(55).

01  country-file-name pic x(64).
01  country-file-status pic x(2).

01  country-idx pic 9(3).
01  country-max pic 9(3).
01  country-lim pic 9(3) value 900.
01  city-idx pic 9(3).
01  city-lim pic 9(3) value 3.
01  unknown-country pic x(55) value 'UNKNOWN COUNTRY'.
01  country-table.
    03  country-entry occurs 900.
        05  ISO pic x(2).
        05  ISO3 pic x(3).
        05  ISO-Numeric	pic 9(3).
        05  fips pic x(2).
        05  Country pic x(64).
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
        05  city-max pic 9(3).
        05  city-entries occurs 3.
            07  top-city-name pic x(55).
            07  top-city-population pic 9(9).

01  city-file-name pic x(64).
01  city-file-status pic x(2).

01  input-count pic 9(7) value zero.
01  city-count pic 9(7) value zero.
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
01  current-city-count pic 9(6) value zero.

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

01  tab pic x value x'09'.

procedure division chaining
    city-file-name country-file-name selected-continent-name.
start-worldcities3.
    call 'printrunreport' using print-run-control end-call

    move 'starting worldcities3' to run-line
    move 2 to run-skip-count
    call 'printrunreport' using print-run-control end-call

    if city-file-name = 'techtonics'
        call 'techtonics' using command-file-name techtonics end-call
        move 'close' to print-run-function
        call 'printrunreport' using print-run-control end-call
        stop run
    end-if

*>  validate the continent parameter
    perform varying cdx from 1 by 1
    until cdx > cdx-lim
    or continent-name(cdx) = selected-continent-name
        continue
    end-perform
    if cdx > cdx-lim
        string 'invalid continent name '
            selected-continent-name
            delimited by size into run-line end-string
        move 2 to run-skip-count
        call 'printrunreport' using print-run-control end-call
        stop run
    end-if
    string 'selecting continent ' selected-continent-name
        delimited by size into run-line end-string
    move 2 to run-skip-count
    call 'printrunreport' using print-run-control end-call

*>  load the country lookup table
    string 'reading ' delimited by size
        country-file-name delimited by space
        into run-line end-string
    move 2 to run-skip-count
    call 'printrunreport' using print-run-control end-call

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
                Country(country-max)
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
            move 0 to city-max(country-max)
        end-if
        read country-file end-read
        call 'checkfilestatus' using country-file-name country-file-status end-call
    end-perform
    close country-file
    evaluate true
    when country-max >= country-lim
        string 'ERROR: countries file exceeds '
            country-lim ' records'
            delimited by size into run-line
        end-string
        move 2 to run-skip-count
        call 'printrunreport' using print-run-control end-call
        move 'close' to print-run-function
        call 'printrunreport' using print-run-control end-call
        stop run
    when country-max = 0
        move 'ERROR: no country records loaded' to run-line
        move 2 to run-skip-count
        call 'printrunreport' using print-run-control end-call
        move 'close' to print-run-function
        call 'printrunreport' using print-run-control end-call
        stop run
    end-evaluate

    accept ct-time from time end-accept
    compute start-seconds =
        ct-hour * 60 * 60
        + ct-minute * 60
        + ct-second
        + ct-hundredth / 100
    end-compute

*>==============================================
*>  Here is a classic COBOL design error caused
*>  by what Gerald Weinberg called "the COBOL
*>  sort mentality."

*>  I wanted was to produce a report sorted
*>  by country in ascending order and the top
*>  three cities by population in each country
*>  in descending order.

*>  So I wrote a sort and it tested OK on a
*>  small file (cities15000.txt).

*>  But when I tested it on the big
*>  allCities.txt file, the design error was
*>  apparent; the sort was way too big for
*>  the little problem I was trying to solve.

*>  There are, after all, only 240 or so
*>  countries and I'm only interested in three
*>  cities per country.

*>  So, the first sort-input is a design error
*>  and the second better-scan-input and 
*>  better-sort-input is a better solution.
*>==============================================
  
    perform better-scan-input
    sort sort-file
        ascending key sort-country-code
        descending key sort-city-population
*>      input procedure sort-input
        input procedure better-sort-input
        output procedure sort-output

    accept ct-time from time end-accept
    compute end-seconds =
        ct-hour * 60 * 60
        + ct-minute * 60
        + ct-second
        + ct-hundredth / 100
    end-compute

    move 2 to run-skip-count
    move country-max to display-count
    move 'country codes loaded' to display-message
    call 'printrunreport' using print-run-control end-call

    move 2 to run-skip-count
    move input-count to display-count
    move 'input records' to display-message
    call 'printrunreport' using print-run-control end-call

    compute elapsed-seconds = end-seconds - start-seconds end-compute
    move elapsed-seconds to display-elapsed-seconds
    move 'elapsed seconds' to display-message
    call 'printrunreport' using print-run-control end-call

    compute display-count = input-count / elapsed-seconds
        on size error move 0 to display-count
    end-compute
    move 'records per second' to display-message
    call 'printrunreport' using print-run-control end-call

    move 2 to run-skip-count
    move 'ending worldcities3' to run-line
    call 'printrunreport' using print-run-control end-call

    move 'close' to print-run-function
    call 'printrunreport' end-call
    stop run
    .
sort-input.
*>========================================================
*>  This is a bad design and this paragraph is not entered
*>========================================================
    string 'reading ' delimited by size
        city-file-name delimited by space
        into run-line end-string
    move 2 to run-skip-count
    call 'printrunreport' using print-run-control end-call

    open input city-file
    call 'checkfilestatus' using city-file-name city-file-status end-call

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

        perform varying country-idx from 1 by 1
        until country-idx > country-max
        or ISO(country-idx) = city-country-code
            continue
        end-perform

        if country-idx <= country-max
        and Continent(country-idx) = continent-code(cdx)
        and featureclass = 'P'
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
            move ISO(country-idx) to sort-country-code
            move Country(country-idx) to sort-country-name
*>          we use the function to suppress a compiler warning
            move function trim(city-name,TRAILING) to sort-city-name
            move city-population to sort-city-population
            release sort-record
        end-if

        read city-file end-read
        call 'checkfilestatus' using city-file-name city-file-status end-call
    end-perform

    close city-file
    .
better-scan-input.
*>=========================
*>  This is a better design
*>=========================
    string 'reading ' delimited by size
        city-file-name delimited by space
        into run-line end-string
    move 2 to run-skip-count
    call 'printrunreport' using print-run-control end-call

    string 'selecting featureclass P:  city, village,...'
        ' and non-zero population'
        delimited by size into run-line end-string
    move 2 to run-skip-count
    call 'printrunreport' using print-run-control end-call

    open input city-file
    call 'checkfilestatus' using city-file-name city-file-status end-call

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

        if city-population > 0        
        and featureclass = 'P'
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
            perform varying country-idx from 1 by 1
            until country-idx > country-max
            or ISO(country-idx) = city-country-code
                continue
            end-perform

            if country-idx <= country-max
            and Continent(country-idx) = continent-code(cdx)
                perform varying city-idx from 1 by 1
                until city-idx > city-max(country-idx)
                or city-population >
                top-city-population(country-idx,city-idx)
                   continue
                end-perform
                if city-idx <= city-lim
                    *> we have either a new city or a city with
                    *> larger population
                    *> we use function here to suppress a compiler warning
                    move function trim(city-name,TRAILING)
                        to top-city-name(country-idx, city-idx)
                    move city-population
                        to top-city-population(country-idx,city-idx)
                    if city-idx > city-max(country-idx)
                        *> this is a new city
                        add 1 to city-max(country-idx) end-add
                    end-if
                end-if
            end-if
        end-if

        read city-file end-read
        call 'checkfilestatus' using city-file-name city-file-status end-call
    end-perform

    close city-file
    .
better-sort-input.
    perform varying country-idx from 1 by 1
    until country-idx > country-max
        perform varying city-idx from 1 by 1
        until city-idx > city-max(country-idx)
        or city-max(country-idx) = 0
            move ISO(country-idx) to sort-country-code
            move Country(country-idx) to sort-country-name
            move top-city-name(country-idx, city-idx)
                to sort-city-name
            move top-city-population(country-idx, city-idx)
                to sort-city-population
            release sort-record
         end-perform
    end-perform
    .
sort-output.
    move 'n' to end-sort-file
    return sort-file at end
        move 'ERROR: no cities selected' to run-line
        call 'printrunreport' using print-run-control end-call
        move 'close' to print-run-function
        call 'printrunreport' using print-run-control end-call
        stop run
    end-return

    perform build-report-heading

    perform begin-country
    perform until end-sort-file = 'y'
        if sort-country-code <> current-country-code
            perform end-country
            perform begin-country
        end-if
        if current-city-count < 3
            *> we use compute here to suppress a compiler warning
            compute report-city-population = sort-city-population end-compute
            move sort-city-name to report-city-name
            perform write-report-line
        end-if
        add 1 to current-city-count end-add
        return sort-file at end
            move 'y' to end-sort-file
        end-return
    end-perform
    perform end-country

    move 'end of report' to report-line
    move 2 to report-skip-count
    perform write-report-line
    close report-file
.
begin-country.
    move sort-country-code to current-country-code
    move zero to current-city-count
    move sort-country-name to report-line
*>  check for an end of page widow
    if report-line-count + 6 > report-line-limit
        move report-line-limit to report-line-count
    else
        move 2 to report-skip-count
    end-if
    perform write-report-line
    .
end-country.
    .
build-report-heading.
    string 'Continent' space continent-name(cdx)
        delimited by size into report-title
    end-string
    accept cd-date from date end-accept
    move cd-year to report-year
    move cd-month to report-month
    move cd-day-of-month to report-day-of-month
    accept ct-time from time end-accept
    move ct-hour to report-hour
    move ct-minute to report-minute
    move ct-second to report-second
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
        move 3 to report-line-count
        move 2 to report-skip-count
    end-if
    write report-record from report-line after advancing report-skip-count lines end-write
    add report-skip-count to report-line-count end-add
    move 1 to report-skip-count
    move spaces to report-line
    .
end program worldcities3.

