#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N picard-sort-bam
#PBS -o picard-sort-bam.out.log
#PBS -e picard-sort-bam.err.log

cd $PBS_O_WORKDIR
java -jar $PICARD SortSam I=SRR1033756_subset.bam O=SRR1033756_subset_sorted.bam SO=coordinate
