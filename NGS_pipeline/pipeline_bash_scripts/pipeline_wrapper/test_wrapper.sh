#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N wrapper
#PBS -o wrapper.out.log
#PBS -e wrapper.err.log



cd $PBS_O_WORKDIR

REF="$1"
REF_PATH=$HOME/igp_share/data/test/"$REF"

SEQ1="$2"
SEQ1_PATH=$HOME/igp_share/data/test/"$SEQ1"

#SEQ1_PATH=$HOME/Shweta_Stuff/data/"$SEQ1"

SEQ2="$3"
SEQ2_PATH=$HOME/igp_share/data/test/"$SEQ2"

#SEQ2_PATH=$HOME/Shweta_Stuff/data/"$SEQ2"

#SEQ=${SEQ1//"_subset_read1.fastq.gz"/".sam"}


OUTPUT_SAM=$SCRATCH/pipeline_output/${SEQ1//"_subset_read1.fastq.gz"/".sam"}

OUTPUT_BAM=${OUTPUT_SAM//".sam"/".bam"}

OUTPUT_SORTED_BAM=${OUTPUT_BAM//".bam"/"_sorted.bam"}

OUTPUT_MARKED_DUP_BAM=${OUTPUT_SORTED_BAM//"_sorted.bam"/"_dedup.bam"}


#. init.sh

# index the reference sequence
bwa index "$REF_PATH"

# align the reads
bwa mem -M -R '@RG\tID:DRR003394\tSM:P1_tumor\tPL:Illumina\tPU:I1\tLB:Library1' "$REF_PATH" "$SEQ1_PATH" "$SEQ2_PATH" > "$OUTPUT_SAM"

# convert .sam file to .bam file
java -jar $PICARD SamFormatConverter I="$OUTPUT_SAM" O="$OUTPUT_BAM"

# sort the .bam file
java -jar $PICARD SortSam I="$OUTPUT_BAM"  O="$OUTPUT_SORTED_BAM"  SO=coordinate


# mark duplicate reads
java -jar $PICARD MarkDuplicates I="$OUTPUT_SORTED_BAM" O="$OUTPUT_MARKED_DUP_BAM" METRICS_FILE=metrics.txt

# index the .bam file
java -jar $PICARD BuildBamIndex I="$OUTPUT_MARKED_DUP_BAM"
