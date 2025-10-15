#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super002
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

KRAKEN2_BUILD="/home/lunajang/src/kraken2/bin/kraken2-build"

mkdir -p /fast/lunajang/metabuli/cami2/ref/kraken2/taxonomy

cp "/fast/lunajang/metabuli/cami2/ref/ncbi_taxonomy/taxdump/"* /fast/lunajang/metabuli/cami2/ref/kraken2/taxonomy/
cp /fast/lunajang/metabuli/cami2/ref/ncbi_taxonomy_accession2taxid/nucl_wgs.accession2taxid.gz /fast/lunajang/metabuli/cami2/ref/kraken2/taxonomy/
cp /fast/lunajang/metabuli/cami2/ref/seqid2taxid.map /fast/lunajang/metabuli/cami2/ref/kraken2/taxonomy/
cp /fast/lunajang/metabuli/cami2/ref/ncbi_taxonomy_accession2taxid/nucl_gb.accession2taxid.gz /fast/lunajang/metabuli/cami2/ref/kraken2/taxonomy/

find /fast/lunajang/metabuli/cami2/ref/ref_seq -name "*.fna.gz" -print0 \
  | xargs -0 -I{} \
  "${KRAKEN2_BUILD}" --add-to-library {} --db /fast/lunajang/metabuli/cami2/ref/kraken2

"${KRAKEN2_BUILD}" --build --db /fast/lunajang/metabuli/cami2/ref/kraken2 \
    --threads 32