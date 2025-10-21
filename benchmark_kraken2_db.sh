#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

KRAKEN2_BUILD="/home/lunajang/src/kraken2/bin/kraken2-build"
DBDIR="/mnt/scratch/lunajang/metabuli/benchmark/kraken2"

mkdir -p "${DBDIR}"/taxonomy

cp /fast/jaebeom/benchmark/20250420-family-exclusion-set/databases/metabuli/R220/*.dmp "${DBDIR}"/taxonomy
cp /fast/jaebeom/benchmark/20250420-family-exclusion-set/databases/metabuli/R220/taxid.accession2taxid "${DBDIR}"
tail -n +2 "${DBDIR}"/taxid.accession2taxid \
    | awk '{print $1"\t"$3; print $2"\t"$3}' \
    | sort -u > "${DBDIR}"/seqid2taxid.map
rm "${DBDIR}"/taxid.accession2taxid

cat /fast/jaebeom/benchmark/20250420-family-exclusion-set/databases/database-genome-paths.txt \
    | xargs -I{} \
    "${KRAKEN2_BUILD}" --add-to-library {} --db "${DBDIR}"

"${KRAKEN2_BUILD}" --build --db "${DBDIR}" --threads 32