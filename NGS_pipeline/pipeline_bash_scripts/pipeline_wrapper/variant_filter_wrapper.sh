#!/bin/bash

#script to filter variants that are not true calls, i.e have bad quality
#the false calls are tagged based on which fiter they have not passed

#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N variant_filter_wrapper
#PBS -o variant_filter_wrapper.out.log
#PBS -e variant_filter_wrapper.err.log


#Refence file name
REF="$1"

#get the basename for the refrence file
REFIF=${REF%.*}

#set reference file path
REF_PATH=$SCRATCH/IGP/data/reference/gatk/"$REF"

#input file path
INPUT="$2"

echo $INPUT

#get the base file name from the path
SEQ=${INPUT##*/}

echo $SEQ

#replace the extension for the output file with only SNP's
OUTPUT_SNP=${SEQ//"_raw_vars.vcf"/"_raw_snps.vcf"}

echo $OUTPUT_SNP

#set path for fle with only SNPs
OUTPUT_SNP_PATH=$SCRATCH/IGP/pipeline_analysis/gatk/var_filter/"$OUTPUT_SNP"

echo $OUTPUT_SNP_PATH

#set file extension for  output file with filtered SNPs
OUTPUT_SNP_FILTERED=${OUTPUT_SNP//"_raw_snps.vcf"/"_filtrd_snps.vcf"}

echo $OUTPUT_SNP_FILTERED

#set path for the filtered output SNP file
OUTPUT_SNP_FILTERED_PATH=$SCRATCH/IGP/pipeline_analysis/gatk/var_filter/"$OUTPUT_SNP_FILTERED"

echo $OUTPUT_SNP_FILTERED_PATH

#set file  extension for the output file with only INDEL's

OUTPUT_INDEL=${SEQ//"_raw_vars.vcf"/"_raw_indels.vcf"}

echo $OUTPUT_INDEL

#set path for the output INDEL file
OUTPUT_INDEL_PATH=$SCRATCH/IGP/pipeline_analysis/gatk/var_filter/"$OUTPUT_INDEL"

#set file  extension for the output file with filtered INDEL's
OUTPUT_INDEL_FILTERED=${OUTPUT_INDEL//"_raw_indels.vcf"/"_filtrd_indels.vcf"}

#set path for the filtered output INDEL file
OUTPUT_INDEL_FILTERED_PATH=$SCRATCH/IGP/pipeline_analysis/gatk/var_filter/"$OUTPUT_INDEL_FILTERED"
i
#set the file extension for merged SNP and INDEL file
OUTPUT_INDEL_SNP=${SEQ//"_raw_vars.vcf"/"_filtrd_indels_snp.vcf"}

#set the file path for merged SNP and INDEL file
OUTPUT_INDEL_SNP_FILTERED_PATH=$SCRATCH/IGP/pipeline_analysis/gatk/var_filter/"$OUTPUT_INDEL_SNP"

#set file extension for output files for the variant pass filter script
OUTPUT_INDEL_SNP_PASS=${SEQ//"_raw_vars.vcf"/"_filtrd_indels_snp_passed.vcf"}

#set path extension for output files for the variant pass filter script
OUTPUT_INDEL_SNP_Pass_FILTERED_PATH=$SCRATCH/IGP/pipeline_analysis/gatk/var_filter/"$OUTPUT_INDEL_SNP_PASS"

#select only SNP's fron the variant call file
java -jar $SCINET_GATK_JAR \
     -T SelectVariants \
     -R "$REF_PATH" \
     -V "$INPUT" \
     -selectType SNP
     -o "$OUTPUT_SNP_PATH"


#filter the SNP's based on filter parameters 
java -jar $SCINET_GATK_JAR -T VariantFiltration \
                           -R "$REF_PATH" \
                           -V "$OUTPUT_SNP_PATH" \
                           --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "LowQualitySnp" \
                           --filterExpression "DP < 10" --filterName "LowDepthSnp" \
                           -o "$OUTPUT_SNP_FILTERED_PATH"


#select only INDEL from the variant call file
java -jar $SCINET_GATK_JAR \
     -T SelectVariants \
     -R "$REF_PATH" \
     -V "$INPUT" \
     -selectType INDEL \
     -o "$OUTPUT_INDEL_PATH"

#filter the INDEL's based on filter parameters
java -jar $SCINET_GATK_JAR \
     -T VariantFiltration \
     -R "$REF_PATH" \
     -V "$OUTPUT_INDEL_PATH" \
     --filterExpression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" \
     --filterName "lowQualityIndel" \
     -o "$OUTPUT_INDEL_FILTERED_PATH"

#combine the filtered variants in one file
java -jar $SCINET_GATK_JAR \
     -T CombineVariants \
     -R "$REF_PATH" \
     -V "$OUTPUT_SNP_FILTERED_PATH" -V "$OUTPUT_INDEL_FILTERED_PATH" \
     -o "$OUTPUT_INDEL_SNP_FILTERED_PATH" \
     -genotypeMergeOptions UNIQUIFY

#path to the pass filter script
PASS=$HOME/Shweta_Stuff/wrapper/passedsnps.sh

#ANNOVAR=$HOME/Shweta_Stuff/wrapper/anno_wrapper.sh

#call the passedsnp script
$PASS $OUTPUT_INDEL_SNP_FILTERED_PATH $REF $OUTPUT_INDEL_SNP_Pass_FILTERED_PATH 

#$ANNOVAR $REF $OUTPUT_INDEL_SNP_FILTERED_PATH


