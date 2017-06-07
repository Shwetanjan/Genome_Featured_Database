#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N picard-index-bam
#PBS -o picard-index-bam.out.log
#PBS -e picard-index-bam.err.log

cd $PBS_O_WORKDIR
java -jar $PICARD BuildBamIndex I=SRR1033756_subset_sorted.bam
