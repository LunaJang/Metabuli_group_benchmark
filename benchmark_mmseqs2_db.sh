#!/bin/bash
#SBATCH --job-name=mmseqs2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 16
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super004
#SBATCH --output=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

source ~/.bashrc
conda init
conda activate rust

MMSEQS2="/home/lunajang/src/MMseqs2/build/bin/mmseqs"

FASTA_FILE="/storage/lunajang/metabuli/benchmark/reference/database-genome.fna"
GTDB_TAXDUMP="/storage/lunajang/metabuli/gtdb-taxdump/R220"
MAPPING_FILE="/storage/lunajang/metabuli/benchmark/reference/seqid2taxid.map"
DBDIR="/storage/lunajang/metabuli/benchmark/db/mmseqs/benchmarkDB"

"${MMSEQS2}" createdb \
        "${FASTA_FILE}" \
        "${DBDIR}"

"${MMSEQS2}" createtaxdb \
        "${DBDIR}" \
        /mnt/scratch/lunajang/ \
        --ncbi-tax-dump "${GTDB_TAXDUMP}" \
        --tax-mapping-file "${MAPPING_FILE}"