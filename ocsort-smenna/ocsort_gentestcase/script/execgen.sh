
## :: Generator for
## ::     File output
## ::     Program Cobol for check data generated
## ::     File Take params or OCSort
## ::     Program Cobol for check data sorted by OCSort
## ::
if [ "$1" == "" ] ; then 	
      echo "Parameter filename config not specified"
else
	find $1
	if [ $? == 0 ] ; then 	
		../bin/ocsort_gentestcase $1
	else
		echo "File config not found"
	fi
fi

