        >> SOURCE FORMAT IS FREE
identification division.
program-id. worldcities1.

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

*> ================================================
*> modify worldcities0.cbl

*> 1) add a country lookup table
*> 2) move checkfilestatus to a copylib
*> ================================================

environment division.
configuration section.
repository. function all intrinsic.
input-output section.
file-control.
*> =============================================
*>  download and unzip a cities file from
*>  http://download.geonames.org/export/dump/
*>  into the $FILES directory
*> =============================================
    select city-file
        assign to city-file-name
        file status is city-file-status
        organization is line sequential.

*> =============================================
*>  download countryInfo.txt from
*>  http://download.geonames.org/export/dump/
*>  into the $FILES directory
*> =============================================
     select country-file
        assign to country-file-name
        file status is country-file-status
        organization is line sequential.

data division.
file section.
fd  country-file.
01  country-record pic x(1000).

fd  city-file.
01  city-record pic x(1000).

working-storage section.
01  command-file-name pic x(128) value 'worldcities1.sh'.
01 techtonics.
   03  pic x(128) value 'export FILES=$HOME/worldcityfiles'.
   03  pic x(128) value 'cobc -x -W worldcities1.cbl'.
   03  pic x(128) value
       './worldcities1 $FILES/CA.txt $FILES/countryInfo.txt'. 
   03  pic x(128) value 'rm worldcities1'.
   03  pic x(128) value 'end'.

01  country-file-name pic x(64).
01  country-file-status pic x(2).

01  country-idx pic 9(3).
01  country-max pic 9(3).
01  country-lim pic 9(3) value 900.
01  unknown-country pic x(15) value 'UNKNOWN COUNTRY'.
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
01  current-country-name pic x(64).
01  current-city-count pic 9(7).
01  display-current-city-count pic z,zzz,zz9.
01  total-city-population pic 9(9).
01  display-total-city-population pic zzz,zzz,zz9.

01  current-time.
    03  ct-hour pic 99.
    03  ct-minute pic 99.
    03  ct-second pic 99.
    03  ct-hundredth pic 99.

01  start-seconds pic 9(5)v99.
01  end-seconds pic 9(7)v99.
01  elapsed-seconds pic 9(5)v99.
01  display-elapsed-seconds pic zz,zz9.99.
01  display-count pic z,zzz,zz9.

01  newline pic x value x'0A'.
01  tab pic x value x'09'.

procedure division chaining  city-file-name country-file-name.
start-worldcities1.
    display newline 'starting worldcities1' newline end-display

    if city-file-name = 'techtonics'
        call 'techtonics' using command-file-name techtonics end-call
        stop run
    end-if

    display 'reading ' country-file-name newline end-display

*>  load the countries lookup table
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

    display 'reading ' city-file-name newline end-display
    display 'selecting featureclass P : city, village,...' end-display

    open input city-file
    call 'checkfilestatus' using city-file-name city-file-status end-call

    accept current-time from time end-accept
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

            add 1 to city-count end-add
            add 1 to current-city-count end-add
            add city-population to total-city-population end-add
        end-if

        read city-file end-read
        call 'checkfilestatus' using city-file-name city-file-status end-call
    end-perform
    perform end-country

    accept current-time from time end-accept
    compute end-seconds =
        ct-hour * 60 * 60
        + ct-minute * 60
        + ct-second
        + ct-hundredth / 100
    end-compute

    close city-file

    move country-max to display-count
    display display-count ' country codes loaded' end-display

    if country-count > 1
        move country-count to display-count
        display display-count ' countries found' end-display
    end-if

    move city-count to display-count
    display display-count ' cities found' end-display

    move input-count to display-count
    display display-count ' records read' end-display

    display ' ' end-display
    compute elapsed-seconds = end-seconds - start-seconds end-compute
    move elapsed-seconds to display-elapsed-seconds
    display display-elapsed-seconds ' elapsed seconds' end-display

    compute display-count = input-count / elapsed-seconds
        on size error move 0 to display-count
    end-compute
    display display-count ' records per second' end-display

    display newline 'ending worldcities1' newline end-display
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
        move Country(country-idx) to current-country-name
    end-if
    .
end-country.
    if current-country-code <> spaces
        add 1 to country-count end-add
        move current-city-count to display-current-city-count
        move total-city-population to display-total-city-population
        display 'country code ' current-country-code end-display
        display 'city count ' display-current-city-count end-display
        display 'city population ' display-total-city-population end-display
        display 'country name ' current-country-name end-display
        display ' ' end-display
    end-if
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

end program worldcities1.

