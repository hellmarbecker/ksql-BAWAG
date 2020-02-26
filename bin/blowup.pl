#!/usr/bin/perl -w

use strict;
use warnings;

use Text::CSV;
my $csv = Text::CSV->new({ sep_char => ';' });

# read input file
while (my $line = <>) {
    chomp $line;

    my @fields = split /;/, $line;
    my $tstamp = $fields[0];
    print "$tstamp\n";
 
}
    
