#!/bin/bash

INPATH="/ldfssz1/ST_INFECTION/P20Z10200N0206_pathogendb/liqian6/fece_meta/2017.NM.OB.test.data"
OUTPATH="/jdfssz1/ST_HEALTH/P20Z10200N0206/liqian6/genesharing/vcset4_vcontact2/cl/selected_pc/functionalities/test_diamond"
REFORMATTER="/hwfssz5/ST_INFECTION/GlobalDatabase/user/fengqikai/software/bbmap/reformat.sh"
DIAMOND="/hwfssz5/ST_INFECTION/GlobalDatabase/user/fengqikai/software/Diamond/2.0.9/diamond"
DIAMOND_DB="/jdfssz1/ST_HEALTH/P20Z10200N0206/liqian6/genesharing/vcset4_vcontact2/cl/selected_pc/functionalities/test_clustered.dmnd"
BEDTOOLS="/zfssz2/ST_MCHRI/COHORT/fengqikai/software/bedtools2/bedtools2/bin/bedtools"
PROTLIST="jdfssz1/ST_HEALTH/P20Z10200N0206/liqian6/genesharing/vcset4_vcontact2/cl/selected_pc/functionalities/protein_length.txt"

ACCESSION="TESTACCFQ"

echo -e "start to merge paired end reads of $ACCESSION at $(date)"

$REFORMATTER in1=$INPATH/$ACCESSION.1.fq.gz in2=$INPATH/$ACCESSION.2.fq.gz out=$OUTPATH/$ACCESSION.merged.fq.gz

echo -e "fninishing merging paired end reads of $ACCESSION at $(date), results stored as $OUTPATH/$ACCESSION.merged.fq.gz"

echo -e "start to align merged reads of $ACCESSION at $(date)"

$DIAMOND blastx  -d  $DIAMOND_DB  -q $OUTPATH/$ACCESSION.merged.fq.gz -o $OUTPATH/$ACCESSION.merged.tab -f 6 --threads 32 

echo -e "finishing alignment of $OUTPATH/$ACCESSION.merged.fq.gz, start to genrate coverage at $(date)"

cat $OUTPATH/$ACCESSION.merged.tab | awk '{if($9 < $10){print($2"\t"$9-1"\t"$10)}else{print($2"\t"$10-1"\t"$9)}}' |  sort -k1,1 -k2,2n  > $OUTPATH/$ACCESSION.merged.bed 

$BEDTOOLS  genomecov -i $OUTPATH/$ACCESSION.merged.bed -g $PROTLIST > $OUTPATH/$ACCESSION.merged.cov.txt

rm $OUTPATH/$ACCESSION.merged.fq.gz
echo -e "finishing alignment on $ACCESSION at $(date)"

