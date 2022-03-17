#!/usr/bin/perl -w
#
# Brad Sawatzky <brads@jlab.org>  06 Feb 2017  
#

sub usage() {
  my $output="";
  $output.="Usage: $0 <epics.dictionary> <epics_XX.results>\n";
  $output.="\tThis script will append the comments from <epics.dictionary> to\n";
  $output.="\tthe output in <epics_XX.results>, line by line.\n";
  return "$output\n";
}

if($#ARGV != 1) {
  print usage;
  exit 1;
}
my $DICTF=$ARGV[0];
my $RESF=$ARGV[1];

## Load dictionary
my %dict;
open IF, "<$DICTF" or die("Can't open '$DICTF': $!\n");
while(<IF>) {
  chomp;
  next if(/^\s*#/);
  next if(/^\s*$/);
  my @f=split(/\s+/,$_,5);
  if( exists($f[4]) ) {
    $dict{$f[0]}=$f[4];
  } else {
    $dict{$f[0]}="";
  }
}
close IF;

## Load results
my %results;
open IF, "<$RESF" or die("Can't open '$RESF' for reading: $!\n");
my $timestamp=<IF>;  # record datestamp
while(<IF>) {
  chomp;
  my @f=split(/\s+/,$_,2);
  $results{$f[0]}=$f[1];
}
close IF;

## Re-write results file with added comments
open OF, ">$RESF" or die("Can't open '$RESF' for re-writing: $!\n");
print OF $timestamp;
foreach my $k ( sort keys(%results) ) {
  printf(OF  "%-30s  %-30s  # %s\n", $k, $results{$k}, $dict{$k});
}
close OF;

exit 0;
