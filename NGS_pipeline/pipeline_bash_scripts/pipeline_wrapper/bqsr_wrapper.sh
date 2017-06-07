#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N bqsr
#PBS -o bqsr.out.log
#PBS -e bqsr.err.log

#cd $PBS_O_WORKDIR



#Get inputs base names and paths
REF="$1"

REF_PATH=$SCRATCH/IGP/data/reference/gatk/"$REF"

INPUT="$2"

#echo $INPUT
SEQ=${INPUT##*/}

#echo $SEQ

TABLE=${SEQ//".bam"/"_recal_data.table"}
TABLE_PATH=$SCRATCH/IGP/pipeline_analysis/gatk/bqrs/"$TABLE"

#echo $TABLE
#echo $TABLE_PATH

OUTPUT=${SEQ//".bam"/"_recalib.bam"}

REFIF=${REF%.*}



#set the knownsites based in the reference used

if  [ "$REFIF" = "chr22" ]; then
     knownSites_INPUT1=$SCRATCH/IGP/data/reference/gatk/dbsnp_138.chr22.vcf
     knownSites_INPUT2=$SCRATCH/IGP/data/reference/gatk/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf
   
elif [ "$REFIF" = "hg19" ]; then
     knownSites_INPUT1=$SCRATCH/IGP/data/reference/gatk/dbsnp_138.hg19.vcf
     knownSites_INPUT2=$SCRATCH/IGP/data/reference/gatk/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf

elif [ "$REFIF" = "hg38" ]; then
     knownSites_INPUT1=$SCRATCH/IGP/data/reference/gatk/dbsnp_138.hg38.vcf
     knownSites_INPUT2=$SCRATCH/IGP/data/reference/gatk/Homo_sapiens_assembly38.known_indels.vcf
        
	
fi

#set path for the output
OUTPUT_BQSR=$SCRATCH/IGP/pipeline_analysis/gatk/bqrs/"$OUTPUT"



GATK=$HOME/Shweta_Stuff/wrapper/gatk_wrapper.sh

# First use BaseRecalibrator
java -jar $SCINET_GATK_JAR \
   -T BaseRecalibrator \
   -R "$REF_PATH" \
   -I "$INPUT" \
   -knownSites "$knownSites_INPUT1" \
   -knownSites "$knownSites_INPUT2" \
   -o "$TABLE_PATH"


#print the Recalibrated bases
java -jar $SCINET_GATK_JAR \
     -T PrintReads \
     -R "$REF_PATH" \
     -I "$INPUT" \
     -BQSR "$TABLE_PATH" \
     -o  "$OUTPUT_BQSR" \
     -rf BadCigar
  
    
$GATK $REF $OUTPUT_BQSR $TABLE_PATH








