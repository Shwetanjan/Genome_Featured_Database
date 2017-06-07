#!/bin/bash

java -jar $SCINET_GATK_JAR -T SelectVariants \
                           -R chr22.fa \
                           -V SRR1033756.vcf \
                           -selectType SNP \
                           -o SRR1033756_SNPs.vcf

java -jar $SCINET_GATK_JAR -T VariantFiltration \
                           -R chr22.fa \
                           -V SRR1033756_SNPs.vcf \
                           --filterExpression "QUAL < 100" --filterName "LowQuality" \
                           --filterExpression "DP < 10" --filterName "LowDepth" \
                           -o SRR1033756_SNPs_filtered.vcf
