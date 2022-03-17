#!/usr/bin/perl
## Edits
# 14-Nov-2001 (pmk) Modifed for gzero from the Hall C version.
# 12-Mar-2002 (aamer) Moved from ../scripts-pking/from-cdaqs2
# 08-Feb-2018 (brads) Update now in git
# 01 Oct 2021 (pdbforce) Modified for Hall A HV logging (SBS)

sub usage() {
  my $output="";
  $output.="Usage: $0 <name_of_sub-system>\n";
  $output.="\tThis parse a *.dictionary file created with the Hall A HV GUI and\n";
  $output.="\toutputs an '*.siglist' format file for the EPICS logging tool to accept.\n";
  $output.="\tTakes one argument which is the name of the sub-system.\n";
  $output.="\tFollowing three options are available:\n";
  $output.="\t1. BB_HV : This includes HV channel info for BB Spectrometer (i.e. BBCal, BBHodo, BBGem, GRINCH)\n";
  $output.="\t2. SBS_HV : This includes HV channel info for SBS Spectrometer (i.e. HCal etc.)\n";
  $output.="\t3. LHRS_HV : This includes HV channel info for LHRS\n"; 
  $output.="\tExample execution for BB_HV sub-system : ./hv_dict_parse.pl BB_HV\n";
  return "$output\n";
}

#$dictfile = "epics.dictionary";   ## Default for backwards compatibility
if($#ARGV != 0) {
  print usage();
  exit 1;
}

$subSys=$ARGV[0];

my $dictfile=$subSys.'.dictionary';
my $path_plus_dictfile=$ENV{HV_LOGGER_DIR}.'/Dictionary/'.${dictfile};

$alltype = "allm";		# Name of runtype field that means all run types
$allbuttype = "all";		# Name of runtype filed that means all but moller
$butwhat = "moller";		# Name of moller run type

open(DICT,"<$path_plus_dictfile") or die "Can't open '$dictfile': $!\n";

%period_files = {};

$fh = "fh00";

open(PERIODLIST, ">>epics_period.list");

while(<DICT>) {
    chomp;
    $line = $_;
    if(not /^\w*(\#|$)/) {
	($signal,$runtypes,$periods,$person,$comment) = split(/\s+/,$_,5);
	@runtype_list = split(",",$runtypes);
	@period_list = split(",",$periods);
#	print "$periods\n";
#
# Only record this variable if it is requested for this runtype
#
	if($runtypes=~/(^|,)$alltype($|,)/i or 
	   ($runtypes=~/(^|,)$allbuttype($|,)/i and $runtype ne "moller") or
	   $runtypes=~/(^|,)$runtype($|,)/i) {
	    
	    foreach $period (reverse sort @period_list) {
		# Open new files as needed
		if(not $period_files{$period}) {
		    $fh++;
		    $fname = "${subSys}.siglist";
		    $period_files{$period} = $fh;
		    open($fh,">$fname");
		    print PERIODLIST "$period $fname $dictfile\n";
		}
		$f = $period_files{$period};
		print {$f} "$signal ";
	    }
	}
    }
}


