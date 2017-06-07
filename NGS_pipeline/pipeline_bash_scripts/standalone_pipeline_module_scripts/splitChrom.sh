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

cd $PBS_O_WORKDIR

