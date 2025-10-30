#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

METABULI="/home/lunajang/src/Metabuli_work/build/bin/metabuli"
DBDIR="/mnt/scratch/lunajang/metabuli/cami2/metabuli"
# FASTALIST="/fast/lunajang/metabuli/cami2/ref/ref_seq_list.txt"
FASTALIST="/fast/lunajang/metabuli/cami2/ref/temp.txt"
ACCESS2TAXID="/fast/lunajang/metabuli/cami2/ref/ncbi_taxonomy_accession2taxid/accession2taxid"
TAXDUMP="/fast/lunajang/metabuli/cami2/ref/ncbi_taxonomy/taxdump/"

mkdir -p "${DBDIR}"

"${METABULI}" build "${DBDIR}" "${FASTALIST}" "${ACCESS2TAXID}" --taxonomy-path "${TAXDUMP}"