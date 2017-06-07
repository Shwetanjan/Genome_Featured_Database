#!/bin/bash

#Script to remove variants that have not passed the GATK variant filter

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N passedsnps.vcf
#PBS -o passedsnps.out.log
#PBS -e passedsnps.err.log

#cd $PBS_O_WORKDIR

#file paths to the input, refrence and the output files
INPUT="$1"
REF="$2"
OUTPUT="$3"


#command to select the variants that have passed the GATK vaiant filters and print them in a new output file
grep "^[#]" "$INPUT" > "$OUTPUT"
awk '$7 == "PASS" { print }' "$INPUT" >> "$OUTPUT"

#call annoavr for annotating the final list of filtered variants
ANNOVAR=$HOME/Shweta_Stuff/wrapper/anno_wrapper.sh

$ANNOVAR $REF $OUTPUT
