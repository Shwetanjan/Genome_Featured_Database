#!/bin/bash

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N wrapper
#PBS -o wrapper.out.log
#PBS -e wrapper.err.log

## required modules are loaded at login from $HOME/scripts/scinet/scinet-init (called by .bashrc)

#cd $PBS_O_WORKDIR
source bwa-index.sh           # index the reference sequence
# fastqc on all reads off sequencer 
source bwa-aln-mem.sh         # align the reads
source picard-convert-sam.sh  # convert .sam file to .bam file
source picard-sort-bam.sh     # sort the .bam by coordinate (sorts by chromosome - makes downstream processing easier)
source picard-dedupe.sh       # mark duplicate reads (overwrites .bam)
source picard-index-bam.sh    # index the .bam (to speed downstream processing) # index here because otherwise have to re-index the bam 
                              # if done earlier 
source bqsr.sh
gatk-variant-discovery.sh
hard-filter.sh
annovar.sh
