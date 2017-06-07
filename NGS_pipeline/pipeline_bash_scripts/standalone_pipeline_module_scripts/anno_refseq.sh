NDB_HG19=$SCRATCH/Annovardb/humandb_hg19

ANNO_TABLE=$HOME/igp_share/tools/annovar/table_annovar.pl

BUILD="$1"

INPUT="$2"

OUTPUT_NAME="$3"

OUTPUT=$SCRATCH/annoResult/"$OUTPUT_NAME"

ANNO_VAR=$HOME/igp_share/tools/annovar/annotate_variation.pl

ANNO_CONVERT=$HOME/igp_share/tools/annovar/convert2annovar.pl

#annotate_variation.pl -buildver hg19 -downdb cytoBand humandb/


STR1="a1.avinput"
OUTPUT_AVI="$OUTPUT$STR1"

if [ "$BUILD"="hg19" ];
    then
    STR2=".hg19_multianno.vcf"
    else
#     STR2=".hg38_multianno.vcf"
#fi

#INPUT_AVI="$OUTPUT$STR2"

"$ANNO_CONVERT" -allsample -withfreq -format vcf4 "$INPUT" > "$OUTPUT_AVI"

#"$ANNO_CONVERT" -format vcf4 "$INPUT_AVI" -outfile "$OUTPUT_AVI" 



echo "DONE...."


