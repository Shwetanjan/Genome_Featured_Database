#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N picard-convert-sam
#PBS -o picard-convert-sam.out.log
#PBS -e picard-convert-sam.err.log

cd $PBS_O_WORKDIR
java -jar $PICARD SamFormatConverter I=SRR1033756_subset.sam O=SRR1033756_subset.bam
