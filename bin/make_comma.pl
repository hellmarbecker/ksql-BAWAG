#!/usr/bin/perl -w

use strict;
use warnings;

use Text::CSV;
my $csv_in = Text::CSV->new({ sep_char => ';', binary => 1 });
my $csv_out = Text::CSV->new({ sep_char => ',' });

# read input file
while (my $line = <>) {

    if (my $status = $csv_in->parse($line)) {

        my @f = $csv_in->fields();
        $csv_out->print(\*STDOUT, \@f);
        print "\n";

    } else {

        print "status: $status\n";
        my $bad_argument = $csv_in->error_input();
        print "bad_argument: $bad_argument\n";
   }

}
    
