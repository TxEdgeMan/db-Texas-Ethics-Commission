#!/usr/bin/env perl
# Remove rows where filerIdent field (column 2) contains an email address
# These rows have invalid data (email in integer field) and cannot be loaded
# Uses proper CSV parsing to preserve quoted fields with commas
# Usage: clear_email_filerident.pl file.csv

use local::lib;
use strict;
use warnings;
use Text::CSV;

my $file = shift or die "Usage: $0 file.csv\n";

my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

open my $in, "<:encoding(UTF-8)", $file or die "Cannot open $file: $!";
my @rows;
my $removed = 0;

while (my $row = $csv->getline($in)) {
    # filerIdent is column index 1 (second column)
    if (defined $row->[1] && $row->[1] =~ /@/) {
        warn "REMOVING ROW: filerIdent contains email address [$row->[1]]\n";
        $removed++;
        next;  # Skip this row entirely
    }
    push @rows, $row;
}
close $in;

open my $out, ">:encoding(UTF-8)", $file or die "Cannot write $file: $!";
$csv->say($out, $_) for @rows;
close $out;

warn "$file: removed $removed rows with email addresses in filerIdent\n" if $removed;
