#!/home/account/software/bin/perl

use strict;
use warnings;

my $file = "Labs_With_Tests_Only.txt";
open(IN, $file) || die("Error opening file: $file... Message: $!\n");
my $ofile = "finaltest.txt";

open(OUT, "> $ofile") ||
   warn("Error opening file: $ofile... (must be a permission issue) $!\n");
my @lines = <IN>;


foreach my $row (@lines) {
   $row =~ /Laboratory\sName:\s(.*?#)/; 
   my $labname = $1;
   $row =~ /City\sName:\s(.*?#)/; 
   my $cityname = $1;
   $row =~ /State\sName:\s(.*?#)/; 
   my $statename = $1;
   $row =~ /PostCode\sDigit:\s(.*?#)/; 
   my $postcode = $1;
   $row =~ /Country\sName:\s(.*?#)/; 
   my $countryname = $1;
   $row =~ /(Test Name: .*)$_/s;
   my $testname = $1;
   print OUT "#$labname$cityname$statename$postcode$countryname     $testname";   
}   

close(OUT) || die "Could not close output file '$ofile' properly... $!";
close(IN)  || die "Could not close input  file '$file' properly... $!";