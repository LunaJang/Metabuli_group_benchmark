#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

KRAKEN2_BUILD="/home/lunajang/src/kraken2/bin/kraken2-build"
FASTA_LIST="/storage/lunajang/metabuli/benchmark/reference/database-genome-paths.txt"
DBDIR="/storage/lunajang/metabuli/benchmark/db/kraken2"

mkdir -p "${DBDIR}"/taxonomy

cp /storage/lunajang/metabuli/gtdb-taxdump/R220/*.dmp "${DBDIR}"/taxonomy
cp /storage/lunajang/metabuli/benchmark/reference/seqid2taxid.map "${DBDIR}"

cat "${FASTA_LIST}" \
    | xargs -I{} \
    "${KRAKEN2_BUILD}" --add-to-library {} --db "${DBDIR}"

"${KRAKEN2_BUILD}" --build --db "${DBDIR}" --threads 32