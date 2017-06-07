#!/bin/bash

table_annovar.pl SRR1033756_SNPs_filtered.vcf /scratch/d/danfldhs/mchan/src/annovar/annovar/humandb/ -buildver hg19 -out SRR1033756_SNPs_filtered_annotated.vcf -protocol refGene -operation g -vcfinput
