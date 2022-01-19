#!/bin/bash

## Edits
# 01 Oct 2021 (pdbforce) Created for Hall A HV_logging (SBS)

## Usage
# This script will generate a .dictionary file and consecutively a .siglist 
# Hence, this needs to get executed everytime there is a change in HV mapping.
# file for each sub-system.
# Takes one argument that is the name of the sub-system.
# Following three options are available:
# 1. BB_HV : This includes HV channel info for BB Spectrometer (i.e. BBCal, BBHodo, BBGEM, GRINCH)
# 2. SBS_HV : This includes HV channel info for SBS Spectrometer (i.e. HCal etc.)
# 3. LHRS_HV : This includes HV channel info for LHRS 
# Example execution for BB_HV sub-system : ./get_dictionary_and_siglist.sh BB_HV

source ./setup.sh
if [ -z "$HV_LOGGER_DIR" ]; then
  echo "-!-> Error: HV_LOGGER_DIR environment variable not set."
  echo "Make sure setup.sh file is present."
  exit 1;
fi

subSys=$1 # Should be any of the above mentioned three options

echo "Generating $subSys.dictionary file.." 
cd $HV_LOGGER_DIR/Dictionary 
./make_HV_dict.pl "$subSys"
sleep 3
echo "Check inside /Dictionary directory to ensure proper execution."

echo "Generating $subSys.siglist file.." 
cd $HV_LOGGER_DIR/Siglist 
./hv_dict_parse.pl "$subSys"
sleep 1
echo "Check inside /Siglist directory to ensure proper execution."
echo "Next step would be to execute HV_logger.sh to get .results files for EPICS logging."

#set +e # don't want to automatically die on failure anymore

exit 0
