#!/bin/bash

HUMANDB_HG19=$SCRATCH/Annovardb/humandb_hg19

ANNO_TABLE=$HOME/igp_share/tools/annovar/table_annovar.pl

BUILD="$1"

INPUT="$2"

OUTPUT_NAME="$3"

OUTPUT=$SCRATCH/annoResult/"$OUTPUT_NAME"

ANNO_VAR=$HOME/igp_share/tools/annovar/annotate_variation.pl



#annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/

"$ANNO_TABLE" -buildver "$BUILD" -out "$OUTPUT" -remove -protocol refGene,cytoBand,genomicSuperDups,wgRna,targetScanS,esp6500siv2_all,1000g2015aug_all,avsnp147,dbnsfp30a,clinvar_20161128 -operation g,r,r,r,r,f,f,f,f,f -nastring . -vcfinput "$INPUT" "$HUMANDB_HG19"

if [ -e $SCRATCH/annoResult/*.txt ]
  then
    rm $SCRATCH/annoResult/*.txt
fi

echo "DONE...."




