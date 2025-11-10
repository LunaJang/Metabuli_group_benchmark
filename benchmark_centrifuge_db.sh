#!/bin/bash
#SBATCH --job-name=centrifuge
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 16
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super004
#SBATCH --output=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

source ~/.bashrc
conda init

CENTRIFUGE_BUILD="/home/lunajang/src/centrifuge/centrifuge-build"

CONV_TABLE="/storage/lunajang/metabuli/benchmark/reference/conversion-table.tsv"
GTDB_TAXDUMP="/storage/lunajang/metabuli/gtdb-taxdump/R220"
FASTA_FILE="/storage/lunajang/metabuli/benchmark/reference/database-genome.fna"
DBDIR="/storage/lunajang/metabuli/benchmark/db/centrifuge/benchmark"

"${CENTRIFUGE_BUILD}" --threads 16 \
                      --conversion-table "${CONV_TABLE}" \
                      --taxonomy-tree "${GTDB_TAXDUMP}"/nodes.dmp \
                      --name-table "${GTDB_TAXDUMP}"/names.dmp \
                      "${FASTA_FILE}" \
                      "${DBDIR}"