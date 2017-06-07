#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N picard-dedupe
#PBS -o picard-dedupe.out.log
#PBS -e picard-dedupe.err.log

cd $PBS_O_WORKDIR
java -jar $PICARD MarkDuplicates I=SRR1033756_subset_sorted.sam
O=SRR1033756_subset_dedup.bam METRICS_FILE=metrics.txt
