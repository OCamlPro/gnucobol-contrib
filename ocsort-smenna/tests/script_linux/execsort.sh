#!/bin/bash
#:: exec sort
#::@echo off
export rtc=0
../bin/ocsort TAKE $1  1>../log/$2.log 2>../log/$2.err
export rtc=$?
if [ $rtc -eq 16 ] ; then     
	echo "$1 .... (FAILED)"
fi
if [ $rtc -eq 16 ] ; then     
	echo "$1 .... (FAILED)"  >>../log/test_failed.log
fi
if [ $rtc -eq 0 ] ; then      
	echo "$1 .... (OK)"
fi
