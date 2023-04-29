The records of the 'chartdata.dat' file must be structured as follows pic x(12), pic 9(8):
...................
Population  00000001 	Description chart and "00000001" to draw a line chart, 
                                           or "00000002" to draw a bar chart, 
                                           or "00000003" to draw a pie chart
Istambul    16079000 	First record
San Paulo   22495000 	Second record
Milano      05488000
Mosca       17332000
Tokyo       39105000
New York    23582649
Dusseldorf  06237000
Londra      11262000
Shangai     41354149 	(max 50,000,000)
Mexico City 21804515
Madrid      06211000
Berlino     04012000 	Last record (max 12 records)
...................

The file can contain no more than 12 records. 
The first record must contain the description of the graph on the first field pic x(12),
and "00000001" can be entered in the second field of the first record to draw a line chart,
or  "00000002" to draw a bar chart
or  "00000003" to draw a piechart.
Followed by the others (maximum) 12 data records.