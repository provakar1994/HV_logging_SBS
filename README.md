**HV_logger_SBS** repository contains the tools needed for the EPICS logging of HV information for all the detector sub-systems used in Jefferson Lab Hall A Super BigBite Collaboration (SBS) experiments. 

## Contents
1. How-to
2. List of sub-systems
3. Example execution
4. List of scripts
5. Contact

## 1. How-to:
1. Every time when there is a change in HV mapping for any sub-system, do:
   > ./get_dictionary_and_siglist.sh **<name_of_sub-system>**

2. Check the Dictionary and Siglist directories to make sure the updated `.dictionary` and `.siglist` files are in place for all the sub-systems.

3. Then to get the `.results` files for EPICS logging, do:
   > ./HV_logging.sh **<name_of_sub-system>** 

## 2. List of sub-systems:
1. **BB_HV** : This includes HV channel info for BB Spectrometer (i.e. BBCal, BBHodo, BBGEM, GRINCH).
2. **SBS_HV** : This includes HV channel info for SBS Spectrometer (i.e. HCal, et cetera).
3. **LHRS_HV** : This includes HV channel info for LHRS.

## 3. Example execution: 
To log HVs for BigBite spectrometer (BB_HV), one needs to do the following:
> ./get_dictionary_and_siglist.sh **BB_HV** <br> 

Check to make sure updated `BB_HV.dictionary` & `BB_HV.siglist` files exist. Then do, 
> ./HV_logging.sh **BB_HV**

Now, a `BB_HV.results` file should be generated inside **Results** directory.

## 4. List of scripts:
1. `setup.sh` : Sets proper environment to parse most up-to-date files.
2. `Dictionary/make_HV_dict.pl` : Creats a `.dictionary` file using `.hvc` file for all sub-systems.
3. `Siglist/hv_dict_parse.pl` : Generates `.siglist` file with epics variables using `.dictionary` file for all sub-systems.
4. `get_dictionary_ana_siglist.sh` : Executes the scripts mentioned above in proper order.
5. `HV_logging.sh` : Generates .results files with caget information using `.siglist` and `.dictionary` files for EPICS logging for all sub-systems.

## 5. Contact:
In case of any questions or concerns please contact the authors,
>Authors: Provakar Datta (UConn) <br> 
>Contact: <provakar.datta@uconn.edu>
