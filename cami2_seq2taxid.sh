#!/bin/bash
#SBATCH --job-name=cami2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super004
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

KRAKEN2_BUILD="/home/lunajang/src/kraken2/bin/kraken2-build"

REF_DIR="/fast/lunajang/metabuli/cami2/ref"        
DB_DIR="/fast/lunajang/metabuli/cami2/ref/kraken2"


GCF2TAX="${DB_DIR}/taxonomy/gcf2taxid.tsv"
awk -F '\t' 'NR>1 && $1!~/^#/ && $1!="" && $6!="" {print $1"\t"$6}' "${REF_DIR}"/assembly_summary_refseq.txt \
  | awk -F'\t' '!seen[$1]++' > "${GCF2TAX}"

echo "[INFO] total mappings in summary: $(wc -l < "${GCF2TAX}")"


miss=0; hit=0
while IFS= read -r -d '' f; do
  base=$(basename "$f" .fna.gz)                  
  acc=$(printf "%s\n" "$base" | cut -d'_' -f1-2) 

  taxid=$(awk -F'\t' -v k="$acc" '$1==k {print $2; exit}' "${GCF2TAX}")
  if [ -z "${taxid}" ]; then
    echo "[WARN] TaxID not found in summary for: ${acc} (${f})"
    ((miss++)) || true
    continue
  fi

  zcat "$f" \
    | awk -v T="$taxid" '/^>/{gsub(/^>/,""); print $1"\t"T}' >> "${REF_DIR}/ncbi_taxonomy_accession2taxid/seqid2taxid.map"
  echo "[MAP] $(basename "$f") -> taxid ${taxid}"
  ((hit++)) || true
done < <(find "${REF_DIR}"/ref_seq -type f -name "*.fna.gz" -print0)

echo "[DONE] seqid2taxid.map: ${DB_DIR}/ncbi_taxonomy_accession2taxid/seqid2taxid.map"
echo "[INFO] mapped files: ${hit}, not-found in summary: ${miss}"
