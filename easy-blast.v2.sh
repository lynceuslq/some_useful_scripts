#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -t task -d database -q query -e evalue -o Outpath"
   echo "header of tabular outputs: qacc sacc qlen slen pident evalue bitscore mismatch staxids sscinames scomnames sblastnames sskingdoms"
   echo -e "\t-t blast task"
   echo -e "\t-d blast database to retrive"
   echo -e "\t-q query sequence"
   echo -e "\t-e threshould for e-value"
   echo -e "\t-o which directory to write the results"
   exit 1 # Exit script after printing help
}

while getopts "t:d:q:e:o:" opt
do
   case "$opt" in
      t ) task="$OPTARG" ;;
      d ) database="$OPTARG" ;;
      q ) query="$OPTARG" ;;
      e ) evalue="$OPTARG" ;;
      o ) Outpath="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ -z "$database" ] || [ -z "$query" ] || [ -z "$Outpath" ] || [ -z "$task" ] || [ -z "$evalue" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
else
   echo -e "start to $task query sequences $query against database $database at $(date)"

   export PATH=/hwfssz5/ST_INFECTION/GlobalDatabase/user/liqian6/tools/ncbi-blast-2.10.1+/bin:$PATH
   export BLASTDB=$(echo $database | tr "/" "\n" | sed -e '$ d' | tr "\n" "/")
  
   echo $BLASTDB
   $task -db $database  -query $query -evalue $evalue  -num_threads 16 -outfmt "6 qacc sacc qlen slen pident evalue bitscore mismatch staxids sscinames scomnames sblastnames sskingdoms" -out $Outpath

   echo -e "job completed at $(date)"
fi
