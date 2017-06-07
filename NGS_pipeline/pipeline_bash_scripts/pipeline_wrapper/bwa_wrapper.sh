#!/bin/bash

#Script to index refrence file and align the sample files with bwa mem

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N bwa_wrapper
#PBS -o bwa_wrapper.out.log
#PBS -e bwa_wrapper.err.log

cd $PBS_O_WORKDIR

#Refence file name 
REF="$1"

#get the basename for the refrence file
REF_IF=${REF%.*}

OUTPUT_DICT_REF=${SEQ//".fa"/".dict"}

REF_IF=${REF%.*}

SEQ1="$2"

SEQ2="$3"

#get the last file name from the path
SEQ=${SEQ1##*/}

echo $SEQ1
echo $SEQ
echo $REF_IF

#set reference file path
REF_PATH=$SCRATCH/IGP/data/reference/bwa/"$REF_IF"/"$REF"

echo $REF_PATH


#replace the extension for the output file based on the reference(to make tracking easy)
OUT=${SEQ//"_1.fastq.gz"/"_$REF_IF.sam"}

#set path for output sam file

OUTPUT_SAM=$SCRATCH/IGP/pipeline_analysis/bwa/"$OUT"

echo $OUTPUT_SAM

#file path for picard 
picard_processing=$HOME/Shweta_Stuff/wrapper/picard_wrapper.sh


#generate file name for the indexed file to check the presence of indexed files in the corresponding refrence folder
REF_IF_INDEX="$REF"".bwt"

#get path for the indexed reference file
REF_IF_INDEX_PATH=$SCRATCH/IGP/data/reference/bwa/"$REF_IF"/"$REF_IF_INDEX"


#Check if index file is present if TRUE proceed to alignment directly if FALSE index refrence first

if [ -f "$REF_IF_INDEX_PATH" ];then 
 
bwa mem -M -R '@RG\tID:DRR003394\tSM:P1_tumor\tPL:Illumina\tPU:I1\tLB:Library1' "$REF_PATH" "$SEQ1" "$SEQ2" > "$OUTPUT_SAM"

else
bwa index "$REF_PATH"
bwa mem -M -R '@RG\tID:DRR003394\tSM:P1_tumor\tPL:Illumina\tPU:I1\tLB:Library1' "$REF_PATH" "$SEQ1" "$SEQ2" > "$OUTPUT_SAM"

fi    

#call picard for further processing
$picard_processing $OUTPUT_SAM $REF  


