#!/bin/bash

######################################################defining arguements here###################################################################
MCXLOAD="/PATH/TO/mcxload"
MCL="/PATH/TO/mcl"
MCXDUMP="/PATH/TO/mcxdump"

#####################################################you do not need to change anything below###################################################
INPUTabc="test2.blastn.abc"
WORKDIR="/lPATH/TO/WORKING?DIRECTORY"

echo -e "start to load abc file at $(date)"

$MCXLOAD  -abc $INPUTabc --stream-mirror  --stream-neg-log10 -stream-tf 'ceil(200)' -write-tab $WORKDIR/$INPUTabc.tab -o $WORKDIR/$INPUTabc.mci

echo -e "start to generate clusters At $(date)"

$MCL $WORKDIR/$INPUTabc.mci -I 1.4


echo -e "start to make tabular results at $(date)"

$MCXDUMP -icl $WORKDIR/out.$INPUTabc.mci.I14 -tabr $WORKDIR/$INPUTabc.tab -o $WORKDIR/$INPUTabc.mci.I14

echo -e "MCL completed at $(date)"
