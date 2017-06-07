#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N bwa-index
#PBS -o bwa-index.out.log
#PBS -e bwa-index.err.log

cd $PBS_O_WORKDIR

bwa index $HOME/igp_share/scripts/pipeline/test/chr22.fa
