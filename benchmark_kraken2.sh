#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

KRAKEN2="/home/lunajang/src/kraken2/bin/kraken2"
DBDIR="/storage/lunajang/metabuli/benchmark/kraken2"

# RESULT_DIR="/storage2/lunajang/workspace/metabuli_query_binning/result/benchmark/species_inclusion_test/kraken2"
# QUERY1=/storage/lunajang/metabuli/benchmark/species-inclusion/query_1.fasta
# QUERY2=/storage/lunajang/metabuli/benchmark/species-inclusion/query_2.fasta

RESULT_DIR="/storage2/lunajang/workspace/metabuli_query_binning/result/benchmark/species_exclusion_test/kraken2"
QUERY1=/storage/lunajang/metabuli/benchmark/species-exclusion/query_1.fasta
QUERY2=/storage/lunajang/metabuli/benchmark/species-exclusion/query_2.fasta

mkdir -p "${RESULT_DIR}"

"${KRAKEN2}" --db "${DBDIR}" \
    --paired  \
    --threads 32 \
    --minimum-hit-groups 3 \
    --report "${RESULT_DIR}"/report.tsv \
    ${QUERY1} ${QUERY2} \
    > "${RESULT_DIR}"/classification.tsv