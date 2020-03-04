#!/usr/bin/perl -w

use strict;
use warnings;

use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ';' });

# read input file
while (my $line = <>) {
    # print $line;
    if (my $status = $csv->parse($line)) {
        my @f = $csv->fields();
    } else {
        print "status: $status\n";
        my $bad_argument = $csv->error_input ();
        print "bad_argument: $bad_argument\n";
    }
    #my @fields = split /;/, $line;
    #my $tstamp = $fields[0];
    #print "$tstamp\n";
 
}
    
