#!/bin/bash

INPATH="/PATH/TO/fq_files"
OUTPATH="/PATH/TO/OUTPUT"
REFORMATTER="/PATH/TO/bbmap/reformat.sh"
DIAMOND="/PATH/TO/diamond"#I used Diamond 2.0.9
DIAMOND_DB="/PATH/TO/DIAMOND_DATABASE"
BEDTOOLS="/PATH/TO/bedtools"
PROTLIST="/PATH/TO/protein_length.txt"#a file consisted of two columns: protein accessions and protein length, using tab as field separators

ACCESSION="TESTACCFQ"



echo -e "start to merge paired end reads of $ACCESSION at $(date)"

$REFORMATTER in1=$INPATH/$ACCESSION.1.fq.gz in2=$INPATH/$ACCESSION.2.fq.gz out=$OUTPATH/$ACCESSION.merged.fq.gz
#no need to merge if the input fastq file are single-end reads

echo -e "fninishing merging paired end reads of $ACCESSION at $(date), results stored as $OUTPATH/$ACCESSION.merged.fq.gz"

echo -e "start to align merged reads of $ACCESSION at $(date)"

$DIAMOND blastx  -d  $DIAMOND_DB  -q $OUTPATH/$ACCESSION.merged.fq.gz -o $OUTPATH/$ACCESSION.merged.tab -f 6 --threads 32 

echo -e "finishing alignment of $OUTPATH/$ACCESSION.merged.fq.gz, start to genrate coverage at $(date)"

cat $OUTPATH/$ACCESSION.merged.tab | awk '{if($9 < $10){print($2"\t"$9-1"\t"$10)}else{print($2"\t"$10-1"\t"$9)}}' |  sort -k1,1 -k2,2n  > $OUTPATH/$ACCESSION.merged.bed 

$BEDTOOLS  genomecov -i $OUTPATH/$ACCESSION.merged.bed -g $PROTLIST > $OUTPATH/$ACCESSION.merged.cov.txt

rm $OUTPATH/$ACCESSION.merged.fq.gz
echo -e "finishing alignment on $ACCESSION at $(date)"

