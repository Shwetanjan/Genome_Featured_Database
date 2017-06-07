#!/bin/bash

#Script to produce a bam for sam,
# sort the bam file
# mark duplicates  in the sorted bam file
# index the sorted marked duplicates bam file 
# depends on environment variable GATK set in .bashrc
# First prepare our FASTA index files...
# GATK needs reference fasta index and dictionary
#the order of the bam file needs to be the same as that of the reference file this s done by thr ordersam function og GATK 
#java -jar $PICARD CreateSequenceDictionary R=chr22.fa O=chr22.dict # generate .dict
#samtools faidx chr22.fa                                            # generate .fai
#tabix -p bed bed_chr_22.bed.gz


#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N picard_wrapper
#PBS -o picard_wrapper.out.log
#PBS -e picard_wrapper.err.log


#get inputs from previous script/comandline
INPUT="$1"

REF="$2"

#set path for reference sequence
REF_PATH=$SCRATCH/IGP/data/reference/gatk/"$REF"

#to get the file name form the file path
SEQ=${INPUT##*/}

#generate file extension from .sam for the .bam output
OUT=${SEQ//".sam"/".bam"}

#set path for the output bam file
OUTPUT_BAM=$SCRATCH/IGP/pipeline_analysis/picard/"$OUT"

#generate file extensions for the output files
  
OUTPUT_SORTED_BAM=${OUTPUT_BAM//".bam"/"_sorted.bam"}

OUTPUT_MARKED_DUP_BAM=${OUTPUT_SORTED_BAM//"_sorted.bam"/"_sort_dedup.bam"}

OUTPUT_MARKED_DUP_REORDERED_BAM=${OUTPUT_SORTED_BAM//"_sorted.bam"/"_sort_dedup_reord.bam"}

METRICS=${OUT//".bam"/"_metrics.txt"}

REF_DICT=${REF_PATH//".fa"/".dict"}

#path to the base-recalibartion script
BQSR=$HOME/Shweta_Stuff/wrapper/bqsr_wrapper.sh


# GATK needs reference fasta index and dictionary

# generate .dict

if [ ! -f $REF_DICT  ]; then
    java -jar $PICARD CreateSequenceDictionary R=$REF_PATH O=$REF_DICT
else
   echo $REF_DICT "file exits"
fi

# generate .fai
samtools faidx $REF_PATH
                                           
#tabix -p bed bed_chr_22.bed.gz

# convert .sam file to .bam file
java -jar $PICARD SamFormatConverter I="$INPUT" O="$OUTPUT_BAM"
    
# sort the .bam file
java -jar $PICARD SortSam I="$OUTPUT_BAM"  O="$OUTPUT_SORTED_BAM"  SO=coordinate

# mark duplicate reads
java -jar $PICARD MarkDuplicates I="$OUTPUT_SORTED_BAM" O="$OUTPUT_MARKED_DUP_BAM" METRICS_FILE=$SCRATCH/IGP/data/sample/picard_metrics/$METRICS

# index the .bam file to generate .bai file
java -jar $PICARD BuildBamIndex I="$OUTPUT_MARKED_DUP_BAM"

# order the bam file based on the contig order of the reference file 
java -jar $PICARD ReorderSam \
    I="$OUTPUT_MARKED_DUP_BAM" \
    O="$OUTPUT_MARKED_DUP_REORDERED_BAM" \
    R="$REF_PATH" \
    CREATE_INDEX=TRUE

#call the base recalibrator scripts
$BQSR $REF $OUTPUT_MARKED_DUP_REORDERED_BAM 


