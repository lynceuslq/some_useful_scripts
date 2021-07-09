#!/bin/bash

MCXLOAD="/hwfssz5/ST_INFECTION/GlobalDatabase/share/software/Miniconda3/envs.multi-user/vcontact2/bin/mcxload"
MCL="/hwfssz5/ST_INFECTION/GlobalDatabase/share/software/Miniconda3/envs.multi-user/vcontact2/bin/mcl"
MCXDUMP="/hwfssz5/ST_INFECTION/GlobalDatabase/share/software/Miniconda3/envs.multi-user/vcontact2/bin/mcxdump"
INPUTabc="test2.blastn.abc"

WORKDIR="/ldfssz1/ST_INFECTION/P20Z10200N0206_pathogendb/liqian6/GPD/MCL_test"

echo -e "start to load abc file at $(date)"

$MCXLOAD  -abc $INPUTabc --stream-mirror  --stream-neg-log10 -stream-tf 'ceil(200)' -write-tab $WORKDIR/$INPUTabc.tab -o $WORKDIR/$INPUTabc.mci

echo -e "start to generate clusters At $(date)"

$MCL $WORKDIR/$INPUTabc.mci -I 1.4


echo -e "start to make tabular results at $(date)"

$MCXDUMP -icl $WORKDIR/out.$INPUTabc.mci.I14 -tabr $WORKDIR/$INPUTabc.tab -o $WORKDIR/$INPUTabc.mci.I14

echo -e "MCL completed at $(date)"
