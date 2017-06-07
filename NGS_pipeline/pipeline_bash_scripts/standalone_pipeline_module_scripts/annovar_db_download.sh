#!/bin/bash

HUMANDB_HG19=$SCRATCH/IGP/databases/Annovardb/humandb_hg19

ANNO_VAR=$HOME/igp_share/tools/annovar/annotate_variation.pl

BUILD="$1"

DB="$2"

"$ANNO_VAR" -buildver "$BUILD" -downdb -webfrom annovar "$DB" "$HUMANDB_HG19"


