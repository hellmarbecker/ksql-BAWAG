#!/usr/bin/perl -w

use strict;
use warnings;

use Text::CSV;
use DateTime::Format::Strptime qw(strptime);

my $csv_in = Text::CSV->new({ sep_char => ';', binary => 1 });
my $csv_out = Text::CSV->new({ sep_char => ',' });

my $strp = DateTime::Format::Strptime->new(
    pattern   => '%F %T',
    locale    => 'de_AT',
    time_zone => 'Europe/Amsterdam',
);

# read input file
my @input = <>;

for my $line (@input) {

    if (my $status = $csv_in->parse($line)) {

        my @f = $csv_in->fields();

        my $datestr = $f[25];
        my $date = $strp->parse_datetime($datestr);
        print("$datestr $date\n"); 
        #$csv_out->print(\*STDOUT, \@f);
        print "\n";

    } else {

        print "status: $status\n";
        my $bad_argument = $csv_in->error_input();
        print "bad_argument: $bad_argument\n";
   }

}
    
