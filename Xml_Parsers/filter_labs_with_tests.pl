#!/home/account/software/bin/perl

use strict;
use warnings;

 
my $file = "Cleanedup_Lab_Addresses_Tests.txt";
open(IN, $file) || die("Error opening file: $file... Message: $!\n");
my $ofile = "Labs_With_Tests_Only.txt"; 

open(OUT, "> $ofile") ||
   warn("Error opening file: $ofile... (must be a permission issue) $!\n");
my @lines = <IN>;

foreach my $row (@lines) {
   my $string = "Test Name";
   if ($row =~ $string) {
      print OUT $row;
	}    
}   

close(OUT) || die "Could not close output file '$ofile' properly... $!";
close(IN)  || die "Could not close input  file '$file' properly... $!";
