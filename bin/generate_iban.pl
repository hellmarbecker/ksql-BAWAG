#!/usr/bin/env perl

use strict;
use warnings;

#---------------------------------------
# makeIBAN
#---------------------------------------
# see https://www.ibantest.com/en/how-is-the-iban-check-digit-calculated
sub makeIBAN {
    my ( $blz, $acct ) = @_;

    # BLZ is 8 digits
    $blz =~ /^\d{8}$/ or die "BLZ has to be 8 digits";
    $acct =~ /^\d{1,10}$/ or die "Account number has to be numeric";

    # 1. Concatenate BLZ and account number into BBAN
    my $bban = sprintf( "%08d%010d", $blz, $acct );

    # 2. Create IBAN without check digit
    my $prefix = "DE00";
    my @prefix = split( //, $prefix );

    # 3. Translate letters into decimal numbers, starting at 10 for 'A'.
    # Append this at the end of BBAN
    my $sum = $bban;
    for (@prefix) {
        if (/[A-Z]/) {
	    $sum .= 10 + ord( $_ ) - ord( 'A' );
        } else {
            $sum .= $_;
        }
    }
 
    # 4. Take result mod 97, subtract from 98
    my $chksum = sprintf( "%02d", 98 - $sum % 97 );
    $prefix =~ s/00/$chksum/;

    return $prefix . $bban;
    
} # makeIBAN


my $iban = makeIBAN( "37040044", "12592600" );
print $iban;

