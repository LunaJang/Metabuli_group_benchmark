#!/bin/bash
#SBATCH --job-name=centrifuge
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

CENTRIFUGE="/home/lunajang/src/centrifuge/centrifuge-build"

GTDB_TAXDUMP="/storage/lunajang/metabuli/gtdb-taxdump/R220"
FASTA_FILE="/storage/lunajang/metabuli/benchmark/database-genome.fna"

DBDIR="/storage/lunajang/metabuli/benchmark/centrifuge"

mkdir -p "${DBDIR}"/taxonomy

"${CENTRIFUGE}" --threads 32 \
                --conversion-table "${GTDB_TAXDUMP}"/conversion-table.tsv \
                --taxonomy-tree "${GTDB_TAXDUMP}"/nodes.dmp \
                --name-table "${GTDB_TAXDUMP}"/names.dmp \
                "${FASTA_FILE}" \
                "${DBDIR}"/benchmark