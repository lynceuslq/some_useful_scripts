#!/bin/bash

######################################################defining arguements here###################################################################
MCXLOAD="/PATH/TO/mcxload"
MCL="/PATH/TO/mcl"
MCXDUMP="/PATH/TO/mcxdump"

#####################################################you do not need to change anything below###################################################
helpFunction()
{
   echo ""
   echo "Usage: $0 -i Blast.tabular.result -c Column_numbers -o Outpath"
   echo -e "\t-i tabular output of blast"
   echo -e "\t-c number of columns resembling qacc, sacc and evalue, should be separated in comma"
   echo -e "\t-o which directory to write the results"
   exit 1 # Exit script after printing help
}

while getopts "i:c:t:" opt
do
   case "$opt" in
      i ) INPUT="$OPTARG" ;;
      c ) COL="$OPTARG" ;;
      o ) WORKDIR="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ -z "$INPUT" ] || [ -z "$COL" ] || [ -z "$WORKDIR" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction

else
   
   cut -f ${COL// /} $INPUT > $WORKDIR/tmp.blast.abc
   
   INPUTabc="tmp.blast.abc"

   echo -e "start to load abc file at $(date)"

   $MCXLOAD  -abc $INPUTabc --stream-mirror  --stream-neg-log10 -stream-tf 'ceil(200)' -write-tab $WORKDIR/$INPUTabc.tab -o $WORKDIR/$INPUTabc.mci

   echo -e "start to generate clusters At $(date)"

   $MCL $WORKDIR/$INPUTabc.mci -I 1.4


   echo -e "start to make tabular results at $(date)"

   $MCXDUMP -icl $WORKDIR/out.$INPUTabc.mci.I14 -tabr $WORKDIR/$INPUTabc.tab -o $WORKDIR/$INPUTabc.mci.I14

   echo -e "MCL completed at $(date)"
   
fi
