#!/bin/bash


#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N delly
#PBS -o delly.out.log
#PBS -e delly.err.log

DELLY=$HOME/igp_share/tools/delly


REF="$1"

REF_PATH=$SCRATCH/IGP/data/reference/gatk/"$REF"

INPUT="$2"

echo $INPUT
SEQ=${INPUT##*/}


echo $SEQ

OUTPUT=${SEQ//".bam"/"_SV.bcf"}
OUTPUT_PATH=$SCRATCH/IGP/pipeline_analysis/gatk



REFIF=${REF%.*}

if  [ "$REFIF"=="chr22" ]; then
    Sites=hg19.exc1
     knownSites_INPUT2=$SCRATCH/IGP/data/reference/gatk/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf
   
elif [ "$REFIF"=="hg19" ];then
     knownSites_INPUT1=$SCRATCH/IGP/data/reference/gatk/dbsnp_138.hg19.vcf
     knownSites_INPUT2=$SCRATCH/IGP/data/reference/gatk/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf

elif [ "$REFIF"=="hg38" ];then
     knownSites_INPUT1=$SCRATCH/IGP/data/reference/gatk/dbsnp_138.hg38.vcf
     knownSites_INPUT2=$SCRATCH/IGP/data/reference/gatk/Homo_sapiens_assembly38.known_indels.vcf
        
	
fi

$DELLY call -t DEL -g $REF_PATH -o $OUTPUT_PATH -x hg19.exc1  $INPUT
