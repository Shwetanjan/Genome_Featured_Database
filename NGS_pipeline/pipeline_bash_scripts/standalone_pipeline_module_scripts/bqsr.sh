#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N bqsr
#PBS -o bqsr.out.log
#PBS -e bqsr.err.log

#cd $PBS_O_WORKDIR
# depends on environment variable GATK set in .bashrc
# First prepare our FASTA index files...
# GATK needs reference fasta index and dictionary
#java -jar $PICARD CreateSequenceDictionary R=chr22.fa O=chr22.dict # generate .dict
#samtools faidx chr22.fa                                            # generate .fai
#tabix -p bed bed_chr_22.bed.gz

# First use BaseRecalibrator
java -jar $GATK \
   -T BaseRecalibrator \
   -R chr22.fa \
   -I SRR1033756_subset_dedup.bam \
   -knownSites dbsnp_138.chr22.vcf  \
   -o recal_data.table

java -jar $GATK \
     -T PrintReads \
     -R chr22.fa \
     -I SRR1033756_subset_dedup.bam \
     -BQSR recal_data.table \
     -o SRR1033756_subset_recalib.bam
