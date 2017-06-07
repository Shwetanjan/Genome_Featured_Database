#!/bin/bash

#Script to call variants using the GATK haplotypeCaller

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N picard_wrapper
#PBS -o picard_wrapper.out.log
#PBS -e picard_wrapper.err.log

cd $PBS_O_WORKDIR

#Refence file name 
REF="$1"

#get the basename for the refrence file
REFIF=${REF%.*}

#set path to the refrence file
REF_PATH=$SCRATCH/IGP/data/reference/gatk/"$REF"

INPUT="$2"

TABLE_PATH="$3"

echo $INPUT
SEQ=${INPUT##*/}


echo $SEQ


##replace the extension from .bam to .vcf to get the output file base name
OUTPUT=${SEQ//".bam"/"_raw_vars.vcf"}

#file path for output variant file (vcf) 
OUTPUT_HAPLOCALLER=$SCRATCH/IGP/pipeline_analysis/gatk/"$OUTPUT"

echo $TABLE
echo $TABLE_PATH

#command to call variants using GATK haplotypecaller
java -jar $SCINET_GATK_JAR \
     -T HaplotypeCaller \
     -I "$INPUT" \
     -R "$REF_PATH" \
     --genotyping_mode DISCOVERY \
     -o "$OUTPUT_HAPLOCALLER"

#file path to the variant filtering script
VARIANT_FILTER=$HOME/Shweta_Stuff/wrapper/variant_filter_wrapper.sh

#call GATK variant filter to filter false variants
$VARIANT_FILTER $REF $OUTPUT_HAPLOCALLER

