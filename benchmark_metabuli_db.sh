#!/bin/bash
#SBATCH --job-name=metabuli
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

METABULI="/home/lunajang/src/Metabuli/build/bin/metabuli"

DBDIR="/storage/lunajang/metabuli/benchmark/metabuli"
FASTA_LIST="/storage/lunajang/metabuli/benchmark/database-genome-paths.txt"
GTDB_TAXDUMP="/storage/lunajang/metabuli/gtdb-taxdump/R220"

mkdir -p "${DBDIR}"/taxonomy

"${METABULI}" build --gtdb 1 \
                    "${DBDIR}" \
                    "${FASTA_LIST}" \
                    "${GTDB_TAXDUMP}/taxid.map" \
                    --taxonomy-path "${GTDB_TAXDUMP}" \
                    --threads 32