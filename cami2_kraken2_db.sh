#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

KRAKEN2_BUILD="/home/lunajang/src/kraken2/bin/kraken2-build"
DBDIR="/mnt/scratch/lunajang/metabuli/cami2/kraken2"

mkdir -p "${DBDIR}"/taxonomy

cp "/fast/lunajang/metabuli/cami2/ref/ncbi_taxonomy/taxdump/"* "${DBDIR}"/taxonomy/
cp /fast/lunajang/metabuli/cami2/ref/ncbi_taxonomy_accession2taxid/seqid2taxid.map "${DBDIR}"

find /fast/lunajang/metabuli/cami2/ref/ref_seq/unzip/ -name "*.fna" -print0 \
  | xargs -0 -I{} \
  "${KRAKEN2_BUILD}" --add-to-library {} --db "${DBDIR}"

"${KRAKEN2_BUILD}" --build --db "${DBDIR}" --threads 32