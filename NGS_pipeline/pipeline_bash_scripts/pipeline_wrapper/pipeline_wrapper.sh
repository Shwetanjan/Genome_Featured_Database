#!/bin/bash

#load modules for the pipeine

module load bwakit/0.7.13

module load java/8.0

module load picard-tools/2.1.1

module load samtools/0.1.19

module load GATK/3.5


#qsub instructions
#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N pipeline_wrapper
#PBS -o pipeline_wrapper.out.log
#PBS -e pipeline_wrapper.err.log

#change to the working directory
cd $PBS_O_WORKDIR

#Comandline arguments

REF="$1"

INPUT1="$2"

INPUT2="$3"

#set file paths for the input samples 

SEQ1_PATH=$SCRATCH/IGP/data/sample/raw_fastq/"$INPUT1"

SEQ2_PATH=$SCRATCH/IGP/data/sample/raw_fastq/"$INPUT2"

#path to bwa
bwa=$HOME/Shweta_Stuff/wrapper/bwa_wrapper.sh

#call bwa with input arguments
$bwa $REF $SEQ1_PATH $SEQ2_PATH
