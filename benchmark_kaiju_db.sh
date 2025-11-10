#!/bin/bash
#SBATCH --job-name=kaiju
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 16
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super004
#SBATCH --output=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

KAIJU="/home/lunajang/src/kaiju/src"

FASTA_FILE="/storage/lunajang/metabuli/benchmark/reference/database-genome.taxid.fna"
DBDIR="/storage/lunajang/metabuli/benchmark/db/kaiju/benchmarkDB"

"${KAIJU}"/bwt/mkbwt -n 16 \
                     -a ARNDCQEGHILKMFPOSUTWYVBZXJ \
                     -o "${DBDIR}" \
                     "${FASTA_FILE}"

"${KAIJU}"/bwt/mkfmi "${DBDIR}"