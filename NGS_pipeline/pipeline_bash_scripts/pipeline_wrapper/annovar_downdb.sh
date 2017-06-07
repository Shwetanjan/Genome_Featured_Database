#!/bin/bash


#PBS -l nodes=1:ppn=8
#PBS -l walltime=1:00:00
#PBS -N anno_ wrapper
#PBS -o anno_wrapper.out.log
#PBS -e anno_wrapper.err.log

#This script helps download Annovar databases
#@params: build(hg19 or hg38), database of interest
#uses the annovar annotate_variation perl script and the -downdb function

#path to the annovar database folder
NDB_HG19=$SCRATCH/IGP/databases/Annovardb/humandb_hg19

#path to annovar perl scripts
ANNO_VAR=$HOME/igp_share/tools/annovar/annotate_variation.pl

BUILD="$1"

DB="$2"

#annovar download database command

"$ANNO_VAR" -buildver "$BUILD" -downdb -webfrom annovar "$DB" "$NDB_HG19"

