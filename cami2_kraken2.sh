#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

KRAKEN2="/home/lunajang/src/kraken2/bin/kraken2"
DBDIR="/mnt/scratch/lunajang/metabuli/cami2/kraken2"

RESULT_DIR="/mnt/scratch/lunajang/metabuli/cami2/result/marine/kraken2"
cd /fast/lunajang/metabuli/cami2/marine/short_read

mkdir -p "${RESULT_DIR}"

"${KRAKEN2}" --db "${DBDIR}" \
    --paired  \
    --threads 32 \
    --minimum-hit-groups 3 \
    --report "${RESULT_DIR}"/report.tsv \
    <(for f in marmgCAMI2_sample_*_reads.tar.gz; do
            tar -I pigz -xOf "$f" --wildcards '*_R1_*.fastq.gz' | pigz -dc;
        done) \
    <(for f in marmgCAMI2_sample_*_reads.tar.gz; do
            tar -I pigz -xOf "$f" --wildcards '*_R2_*.fastq.gz' | pigz -dc;
        done) \
    > "${RESULT_DIR}"/classification.tsv