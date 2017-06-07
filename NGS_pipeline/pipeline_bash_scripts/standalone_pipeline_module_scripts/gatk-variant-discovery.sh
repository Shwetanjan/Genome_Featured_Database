#!/bin/bash

# HaplotypeCaller
# Calls genotypes

java -jar $GATK \
     -T HaplotypeCaller \
     -I SRR1033756_subset_recalib.bam \
     -R chr22.fa \
     -L chr22 --genotyping_mode DISCOVERY \
     -o SRR1033756.vcf
