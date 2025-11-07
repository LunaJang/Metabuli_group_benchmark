#!/bin/bash
#SBATCH --job-name=metabuli_group
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_output.log
#SBATCH --error=/storage2/lunajang/workspace/metabuli_query_binning/benchmark_logs/%j_error.log

NEW_METABULI="/home/lunajang/src/Metabuli/build/bin/metabuli"

REF_DB="/storage/lunajang/metabuli/benchmark/metabuli"

# SCRATCH_OUTPUT="/mnt/scratch/lunajang/benchmark/species_inclusion_test/metabuli"
# OUTPUT="/storage2/lunajang/workspace/metabuli_query_binning/result/benchmark/species_inclusion_test/metabuli"
# QUERY1=/storage/lunajang/metabuli/benchmark/species-inclusion/query_1.fasta
# QUERY2=/storage/lunajang/metabuli/benchmark/species-inclusion/query_2.fasta

SCRATCH_OUTPUT="/mnt/scratch/lunajang/benchmark/species_exclusion_test/metabuli"
OUTPUT="/storage2/lunajang/workspace/metabuli_query_binning/result/benchmark/species_exclusion_test/metabuli"
QUERY1=/storage/lunajang/metabuli/benchmark/species-exclusion/query_1.fasta
QUERY2=/storage/lunajang/metabuli/benchmark/species-exclusion/query_2.fasta


if [ ! -d "${SCRATCH_OUTPUT}" ]; then
  echo "Directory does not exist, creating it now..."
  mkdir -p "${SCRATCH_OUTPUT}"
else
  echo "Directory already exists."
fi

if [ ! -d "${OUTPUT}" ]; then
  echo "Directory does not exist, creating it now..."
  mkdir -p "${OUTPUT}"
else
  echo "Directory already exists."
fi


"${NEW_METABULI}" classify --seq-mode 2 --threads 32 "${QUERY1}" "${QUERY2}" "${REF_DB}" "${SCRATCH_OUTPUT}" 1 

TAX_DB_GRADE="/storage/lunajang/metabuli/gtdb-taxdump/R220"
TAX_ANSWER="/storage/lunajang/metabuli/gtdb-taxdump/R220/taxid.map"

RESULT="${SCRATCH_OUTPUT}"/result.txt
ANSWER="${SCRATCH_OUTPUT}"/answer.txt
GRADE="${SCRATCH_OUTPUT}"/grade.txt
echo "${SCRATCH_OUTPUT}"/1_classifications.tsv > "${RESULT}"
echo "${TAX_ANSWER}" > "${ANSWER}"

"${NEW_METABULI}" grade "${RESULT}" "${ANSWER}" "${TAX_DB_GRADE}" --test-type gtdb --threads 3 > "${GRADE}"
echo "---------------------------------------------------------------------------"
rsync -av --delete "${SCRATCH_OUTPUT}"/ "${OUTPUT}"/