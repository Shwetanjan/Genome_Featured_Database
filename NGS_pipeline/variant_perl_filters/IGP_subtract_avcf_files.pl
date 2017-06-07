use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
my ($firstInFile, $secInFile, $outFile, @fileData1, @fileData2, $line, $i,$refgeneOutFile,$popSnpOutfile, $tempData1,@tempData2, @tempArray, @rsIdSmple,@rsId1000g);
$firstInFile = $ARGV[0];             #Refgene annotated vcf
$secInFile = $ARGV[1];		     #1000g annoated vcf
$refgeneOutFile = $ARGV[2];          #substart refgene vcf output
$popSnpOutfile = $ARGV[3];           #subtrated 1000g vcf output

open(IN, "< $firstInFile") || die("Error: Could not open INPUT file... '$ARGV[0]'  $!\n");
open(FD, "< $secInFile") || die("Error: Could not open INPUT file... '$ARGV[1]'  $!\n");
open(OUTER, ">> $refgeneOutFile") || die("Error: Could not open OUTPUT file... '$refgeneOutFile' $!\n");
open(OUT, ">> $popSnpOutfile") || die("Error: Could not open OUTPUT file... '$popSnpOutfile' $!\n");


@fileData1 = <IN>;  # slurping entire raw file into individual array elements of refgene annoated vcf

close (IN);

@fileData2 = <FD>;  # slurping entire raw file into individual array elements

close (FD);

#my $regex= /rs[0-9]*?/;
$i = 0;
#/populate the has table/
foreach $line(@fileData1) {
   if ($line =~ /(rs([0-9]*)?)/){
    #print "matched portion:",$1,"\n";
     push(@rsIdSmple, $1);
} 
 
 $i++;
}
$line=0;
$i=0;
print OUT $fileData2[0];
foreach $line(@fileData2) {
 if ($line =~ /(rs([0-9]*)?)/){
   my $tempRs = $1;
   @tempArray=split(" ",$line);
   if (($tempArray[-1]+0) < 0.1 || $tempArray[-1] eq ""){
    #print "matched portion:",$1,"\n";
     push(@rsId1000g, $tempRs);
     print OUT $line;
   }
 }  
 $i++;
}

print "@rsIdSmple\n";

print "@rsId1000g\n";

my %hash;
$hash{$_} = undef foreach (@rsId1000g);

# grep only leaves what evaluates to true.
# if an element of array1 is not in array2, it is
# left in place
 @rsIdSmple= grep { exists $hash{$_} } @rsIdSmple;

print "\n";
print "@rsIdSmple\n";

$i=$line=0;
my ($var1,$var2);
my $j=0;
print OUTER $fileData1[0];
foreach $var1(@fileData1){
    foreach $var2(@rsIdSmple){
        if (index($var1, $var2) != -1) {
         #print $var1, "contains", $var2,"\n";
         print OUTER $var1;
        }
        $j++;
    }
        $i++;
    }



