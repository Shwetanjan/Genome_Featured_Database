#This script is to select the variants with less tha 5% population frequency from the annovar annotated variant files for
#population frequency for every variant (annoated against the 1000g database) and the gene information (annotated against the refseq database)



use warnings;
use strict;
use Scalar::Util qw(looks_like_number);

my ($refSeqFile, $popGenFile, $outFile, @refGeneFile, @popGenFile, $line, $i,$refgeneOutFile,$popSnpOutfile, $tempData1,@tempData2, @tempArray, @rsIdSmple,@rsId1000g);
#$refSeqFile = $ARGV[0];
#$1000gFile = $ARGV[1];
#$refgeneOutFile = $ARGV[2];
#$popSnpOutfile = $ARGV[3];
print " ARGV[0]=$ARGV[0]\n ";
print " ARGV[1]=$ARGV[1]\n ";
print " ARGV[2]=$ARGV[2]\n ";
print " ARGV[3]=$ARGV[3]\n ";

#Open the input files for reading
open(IN, "< $ARGV[0]") || die("Error: Could not open INPUT file... '$ARGV[0]'  $!\n");
open(FD, "< $ARGV[1]") || die("Error: Could not open INPUT file... '$ARGV[1]'  $!\n");

#open the output file and clean the files as to start from the begining of the file
open(INCLEAN, "> $ARGV[2]") || die("Error: Could not open INPUT file... '$ARGV[2]'  $!\n");
print INCLEAN "";
close INCLEAN;
print "ABCDDDDDDDD\n ";
open(FDCLEAN, "> $ARGV[3]") || die("Error: Could not open INPUT file... '$ARGV[3]'  $!\n");
print FDCLEAN "";
close FDCLEAN;

#Open output files for read and write
open(OUTER, ">> $ARGV[2]") || die("Error: Could not open OUTPUT file... '$ARGV[2]' $!\n");
open(OUT, ">> $ARGV[3]") || die("Error: Could not open OUTPUT file... '$ARGV[3]' $!\n");


@refGeneFile = <IN>;  # slurping entire raw file into individual array elements

close (IN);

@popGenFile = <FD>;  # slurping entire raw file into individual array elements

close (FD);

#my $regex= /rs[0-9]*?/;
$i = 0;
#/populate the array to hold valid rsID of the reFGene file
foreach $line(@refGeneFile) {
    if ($line =~ /(rs([0-9]*)?)/){
      #print "matched portion:",$1,"\n";
            push(@rsIdSmple, $1);
     }          
     $i++;
}

$line=0;
$i=0;

print OUT $popGenFile[0];   #print the coloumn names

#print the lines with valid rsID and with population frequency less than 5% from the popGen file
 foreach $line(@popGenFile) {
     if ($line =~ /(rs([0-9]*)?)/){
         my $tempRs = $1;
         @tempArray=split(" ",$line);
              if ((looks_like_number($tempArray[-1]) && $tempArray[-1] < 0.05) || $tempArray[-1] eq "."){
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
  print OUTER $refGeneFile[0];
  foreach $var1(@refGeneFile){
      foreach $var2(@rsIdSmple){
          if (index($var1, $var2) != -1) {
              #print $var1, "contains", $var2,"\n";
               print OUTER $var1;
          }
          $j++;
       }
       $i++;
}

