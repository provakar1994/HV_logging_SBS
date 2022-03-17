#!/bin/bash

## Edits
# 14-Nov-2001 (pmk) Modified for gzero from the Hall C version.
# 12-Mar-2002 (aamer) Modified after moving from ../scripts-pking/from-cdaqs2
# 06-Jul-2012 (buddhini) Modified for Qweak. Changed to caget from kaget.
#                        Changed location of bash to /bin/bash
# 04 Oct 2011  (jhlee) replaced inconsistent caget command by caget (R3.14.8.2)
#                      added 0.1 timeout.
# 03 Feb 2017  (brads) now managed under git -- use 'git log'
# 01 Oct 2021 (pdbforce) Modified for Hall A HV logging (SBS)

## Usage
# This script will generate a .results file for each sub-system.
# It reads in from a .dictionary file and a .siglist file.
# Takes one argument that is the name of the sub-system.
# Following three options are available:
# 1. BB_HV : This includes HV channel info for BB Spectrometer (i.e. BBCal, BBHodo, BBGEM, GRINCH)
# 2. SBS_HV : This includes HV channel info for SBS Spectrometer (i.e. HCal etc.)
# 3. LHRS_HV : This includes HV channel info for LHRS
# Example execution for BB_HV sub-system : ./HV_logger.sh BB_HV

source ./setup.sh
if [ -z "$HV_LOGGER_DIR" ]; then
  echo "-!-> Error: HV_LOGGER_DIR environment variable not set."
  echo "Make sure setup.sh file is present."
  exit 1;
fi

#time=$1
subSys=$1
#evtag=$3

time="HV"
DICT="$HV_LOGGER_DIR/Dictionary/${subSys}.dictionary"

set -e  # exit on failure

export EPICS_CA_ADDR_LIST="129.57.191.255 129.57.164.255 129.57.192.255"

## NOTE: RUNPARMDIRECTORY, EPICS_LOGGER_DIR exported in startEpicsLogger 
#FILETOEVENT="${EPICS_LOGGER_DIR}/fileToEvent"

echo $$ > .epics_logger_${time}_pid

siglist="`cat $HV_LOGGER_DIR/Siglist/${subSys}.siglist`"
epicsfile="$HV_LOGGER_DIR/Results/${subSys}.results"

set +e # don't want to automatically die on failure anymore

#export EPICS_CA_ADDR_LIST="$EPICS_CA_ADDR_LIST 129.57.171.255"
function get_epics() {
  date >| $epicsfile
  caget -w 0.5 $siglist >> $epicsfile
  if [ -r "$DICT" ]; then
    if [ -x "$HV_LOGGER_DIR/Results/merge_results.pl" ]; then
       $HV_LOGGER_DIR/Results/merge_results.pl "$DICT" "$epicsfile"
    fi
  fi
}

## Generate epics variable log files and push to CODA file using
## ET system.
## - loop exits if '$FILETOEVENT ...' fails (ie. when coda has stopped
##   running), or when this process is killed at end-of-run by killEpicsLogger
get_epics
#cp $epicsfile "first_${epicsfile}"  # make a copy for the halog entry
#if [ $time == "HV" ]; then
#  exit 0
#fi

## start looping with specified period
#echo "EPICS Logging started at $time second interval..."
#while $FILETOEVENT $epicsfile $evtag ; do
  #echo "($time) Logging counter: $((loopcounter++))"
#  sleep $time
#  get_epics
#done

exit 0
