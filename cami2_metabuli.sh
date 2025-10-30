#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

METABULI="/home/lunajang/src/Metabuli_work/build/bin/metabuli"

QUERY1=/mnt/scratch/lunajang/metabuli/cami2/marine/split/reads/R1.fq
QUERY2=/mnt/scratch/lunajang/metabuli/cami2/marine/split/reads/R2.fq
DBDIR="/mnt/scratch/lunajang/metabuli/cami2/metabuli"
OUTPUT="/mnt/scratch/lunajang/metabuli/cami2/result/marine/metabuli"

mkdir -p "${OUTPUT}"

ORI_OUTPUT="${OUTPUT}"
if [ ! -d "${ORI_OUTPUT}" ]; then
  echo "Directory does not exist, creating it now..."
  mkdir -p "${ORI_OUTPUT}"
else
  echo "Directory already exists."
fi

"${METABULI}" classify --seq-mode 2 --threads 32 "${QUERY1}" "${QUERY2}" "${DBDIR}" "${OUTPUT}" 1 