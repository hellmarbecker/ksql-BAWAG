#!/usr/bin/env perl

use strict;
use warnings;

sub makeIBAN {
    my ( $blz, $acct ) = @_;

    # BLZ is 8 digits
    $blz =~ /^\d{8}$/ or die "BLZ has to be 8 digits";
    $acct =~ /^\d{1,10}$/ or die "Account number has to be numeric";

    my $result1 = sprintf( "DE00%08d%010d", $blz, $acct );

    $result1;
} # makeIBAN


my $iban = makeIBAN( "37040044", "12592600" );
print $iban;

