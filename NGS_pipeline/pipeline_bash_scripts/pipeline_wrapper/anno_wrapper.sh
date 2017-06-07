#!/bin/bash


#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N anno_ wrapper
#PBS -o anno_wrapper.out.log
#PBS -e anno_wrapper.err.log

cd $PBS_O_WORKDIR

#This script uses Annoavr to annoate the filtered variants
#gene and intergenic regions annoated based on the refSeq reference database
#rsID annoted based on the dbSNP database


#path to the annovar database folder
NDB=$SCRATCH/IGP/databases/Annovardb/

#path to the annoavr --> table_annoavr script
#This program takes an input variant file (such as a VCF file) and generate a tab-delimited output file with many columns, each representing one set of annotations. Additionally, if the input is a VCF file, the program also generates a new output VCF file with the INFO field filled with annotation information.

ANNO_TABLE=$HOME/igp_share/tools/annovar/table_annovar.pl

#path to the annovar-> annotate_variation.pl program
#program is the core program in ANNOVAR.
#it is used for annotating the variations using the gene-based, region-based and filter-based annotations. 
 
ANNO_VAR=$HOME/igp_share/tools/annovar/annotate_variation.pl
                                                              
#path to the annovar -->convert2annovar.pl program
#The convert2annovar.pl script can convert other "genotype calling" format into ANNOVAR format (.avinput)
ANNO_CONVERT=$HOME/igp_share/tools/annovar/convert2annovar.pl

#refence genome file name
REF="$1"

echo $REF

#build of the refrerence genome
BUILD=${REF%.*}

echo $BUILD

#input file path
INPUT="$2"

#exctract the base input file name from the input file path 
SEQ=${INPUT##*/}              


echo $SEQ

#remove the extension from input file name 
OUTPUT_VCF=${SEQ//".vcf"/" "}

#set output file name  for the table_annovar.pl program 
#annoate the gene regions based on refSeq database and variants based on dbSNP
OUTPUT_VCF1=${SEQ//".vcf"/"_variant_refgene"}

#set output file name for the table_annovar.pl program 
#annoate the population frequency of variants based on 1000genome database for all population  and variants based on dbSNP
OUTPUT_VCF2=${SEQ//".vcf"/"_variant_esp"}

#set output file name for the convert2annoavr program (the file converted to annoavr input file form)
#The annotate_variation.pl program requires a simple text-based format, which we refer to as ANNOVAR input format. In this file, each line corresponds to one variant. On each line, the first five space- or tab- delimited columns represent chromosome, start position, end position, the reference nucleotides and the observed nucleotides. Additional columns can be supplied and will be printed out in identical form. For convenience, users can use "0" to fill in the reference nucleotides, if this information is not readily available. Insertions, deletions or block substitutions can be readily represented by this simple file format, by using "-" to represent a null nucleotide.

OUTPUT_AVI=${SEQ//".vcf"/".avinput"}

echo $OUTPUT_VCF
echo  $OUTPUT_VCF1
echo  $OUTPUT_VCF2

#set pats for all the out put files
OUTPUT_AVI_PATH=$SCRATCH/IGP/pipeline_analysis/annovar/"$OUTPUT_AVI"
OUTPUT_VCF_PATH=$SCRATCH/IGP/pipeline_analysis/annovar/"$OUTPUT_VCF"
OUTPUT_VCF1_PATH=$SCRATCH/IGP/pipeline_analysis/annovar/"$OUTPUT_VCF1"
OUTPUT_VCF2_PATH=$SCRATCH/IGP/pipeline_analysis/annovar/"$OUTPUT_VCF2"

echo $OUTPUT_VCF_PATH
echo $OUTPUT_VCF1_PATH
echo $OUTPUT_VCF2_PATH


#annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/


#check whcih build was used (hg19 or hg38) and use the appropriate database
if [ "$BUILD"="hg19" ];
  then
    
     NDB="$NDB""humandb_hg19"
     
   else
     NDB="$NDB"."humandb_hg38"
    
fi


#convert2annovar.pl used to convert the input file to the annovar file format

"$ANNO_CONVERT" -allsample -withfreq -format vcf4 "$INPUT" > "$OUTPUT_AVI_PATH"

#TABLE.PL for a annotation of variant file using refGene for refSeq based annoation and avsnp147 for dbSNP based annoation

"$ANNO_TABLE" -buildver "$BUILD" -out "$OUTPUT_VCF1_PATH" -remove -protocol refGene,avsnp147 -operation g,f -nastring . "$OUTPUT_AVI_PATH" "$NDB" 


#TABLE.PL for a annotation of variant file using 1000g(form general population) for population frequency based annoation and avsnp147 for dbSNP based annoation

"$ANNO_TABLE" -buildver "$BUILD" -out "$OUTPUT_VCF2_PATH" -remove -protocol avsnp147,1000g2015aug_all -operation f,f -nastring . "$OUTPUT_AVI_PATH" "$NDB"  



#DGVMERGED OF THE OUTPUT_AVI 

#"$ANNO_VAR" -regionanno -build "$BUILD" -out "$OUTPUT_VCF_PATH" -dbtype dgvMerged "$OUTPUT_AVI" "$NDB" -minqueryfrac 0.5
             
#Transcription factor binding site
 
#OUTPUT_NONCDS="$OUTPUT""_NONCDS"
#"$ANNO_TABLE" "$OUTPUT_AVI" "$NDB" -buildver "$BUILD" -out "$OUTPUT_NONCDS" -remove -protocol tfbsConsSites,wgRna,targetScanS -operation r,r,r -nastring .

echo "DONE...."
 
#path to the perl script to filter out population frequencies more that 1%
ANNO_SUBTRACT=$HOME/igp_share/tools/annovar/annovar_subtract_avcf.pl

#set names and file extensions to the output files for the two annoated vcf files
FINAL_OUTPUT1=${SEQ//".vcf"/"_variant_refgene_subtracted.txt"}
FINAL_OUTPUT2=${SEQ//".vcf"/"_variant_esp_subtracted.txt"}


#set output file path
FINAL_OUTPUT1_PATH=$SCRATCH/IGP/pipeline_analysis/final_vcf_files/"$FINAL_OUTPUT1"
FINAL_OUTPUT2_PATH=$SCRATCH/IGP/pipeline_analysis/final_vcf_files/"$FINAL_OUTPUT2"

#update input file path and namev(annoar adds and extension to the output files)
INPUT_SUB1="$OUTPUT_VCF1_PATH"."hg19_multianno.txt"
INPUT_SUB2="$OUTPUT_VCF2_PATH"."hg19_multianno.txt"

#excute the filter annoation based on frequency script
$ANNO_SUBTRACT "$INPUT_SUB1" "$INPUT_SUB2" "$FINAL_OUTPUT1_PATH" "$FINAL_OUTPUT2_PATH"
       
