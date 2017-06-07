use warnings;
use strict;
use Scalar::Util qw(looks_like_number);

my (@vcfSampleFile , @disGeNetFile,@rsIdVcfSmple,@rsIdDisgeNet, $line, $i,$refgeneOutFile,$popSnpOutfile, $tempData1,@tempData2, @tempArray,@rsId1000g);
#$espAnnovar = $ARGV[0];
#$disgenet file = $ARGV[1];
#$outputfile = $ARGV[2];
open(IN, "< $ARGV[0]") || die("Error: Could not open INPUT file... '$ARGV[0]'  $!\n");
open(FD, "< $ARGV[1]") || die("Error: Could not open INPUT file... '$ARGV[1]'  $!\n");
open(INCLEAN, "> $ARGV[2]") || die("Error: Could not open INPUT file... '$ARGV[2]'  $!\n");
print INCLEAN "";
close INCLEAN;

#open(FDCLEAN, "> $ARGV[3]") || die("Error: Could not open INPUT file... '$ARGV[1]'  $!\n");
#print FDCLEAN "";
#close FDCLEAN;
print "finished opening file\n";

open(OUT, ">> $ARGV[2]") || die("Error: Could not open OUTPUT file... '$ARGV[2]' $!\n");
#open(OUT, ">> $ARGV[3]") || die("Error: Could not open OUTPUT file... '$ARGV[3]!\n");


@vcfSampleFile = <IN>;  # slurping entire raw file into individual array elements

close (IN);

@disGeNetFile = <FD>;  # slurping entire raw file into individual array elements

close (FD);

#my $regex= /rs[0-9]*?/;
$i = 0;
#/populate the has table/
foreach $line(@vcfSampleFile) {
    if ($line =~ /(rs([0-9]*)?)/){
      #print "matched portion:",$1,"\n";
            push(@rsIdVcfSmple, $1);
     }          
     $i++;
}

print "finished array push for sample\n";
$line=0;
$i=0;

#print OUT @[0];   #print the coloumn names

#print the lines with valid rsID and with population frequency less than 1%
 foreach $line(@disGeNetFile) {
     if ($line =~ /(rs([0-9]*)?)/){
         my $tempRs = $1;
        #print "matched portion in disgenet:",$1,"\n";
                  push(@rsIdDisgeNet, $tempRs);
      }
      $i++;
  }

  #print "@rsIdVcfSmple\n\n";
  #print "@rsIdDisgeNet\n";
  my %hash;
  $hash{$_} = undef foreach (@rsIdDisgeNet);

  # grep only leaves what evaluates to true.
  # if an element of array1 is not in array2, it is
  # left in place
  @rsIdVcfSmple= grep { exists $hash{$_} } @rsIdVcfSmple;

  print "\n";
  print "@rsIdVcfSmple\n";

  $i=$line=0;
  my ($var1,$var2,$k, @temp,@temp2);
  my $j=0;
  $k=0;
  print OUT $vcfSampleFile[0];
  foreach $var1(@vcfSampleFile){
      foreach $var2(@rsIdVcfSmple){
          if (index($var1, $var2) != -1) {
              #print $var1, "contains", $var2,"\n";
               foreach $line(@disGeNetFile){
                if ((index($line, $var2) != -1)){
                    @temp = split("\t",$line);
                    @temp2 = split("\t",$var1); 
                                      
                }
                
                    
          $k++;
               }
               
               print OUT "$var1  $temp[4]  $temp[5]\n";
          }
          
          $j++;
       }
       $i++;
}

