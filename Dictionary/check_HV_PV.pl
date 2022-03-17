#!/usr/bin/perl
## Feed me a dictionary file and I'll check all PVs

my $CAGET="caget";

my @PVs;
while(<>) {
  next if(/^\s*#/);
  next if(/^\s*$/);

  my @f=split;
  
  push(@PVs, $f[0]);
}


my $n=30;
my $st=0;
my $end=$st+$n-1;

my $output="";
while( $st < $#PVs ) {
  ## Build and quote the PV strings for caget
  my $PV_list = "'";
  $PV_list .= join("' '", @PVs[$st .. $end]);
  $PV_list .= "' ";

  #$output .= sprintf("======= %d : %d\n", $st, $end);
  #$output .= "$PV_list\n";
  #$output .= sprintf("------- %d : %d\n", $st, $end);

  $output .= `$CAGET $PV_list`;
  $st+=$n;
  $end+=$n;
  $end = ($end<=$#PVs?$end:$#PVs);
}

print "\033[2J";   #clear the screen
print "\033[0;0H"; #jump to 0,0

print $output;
