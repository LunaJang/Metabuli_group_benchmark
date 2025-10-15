#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super002
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

DB_DIR=/fast/lunajang/metabuli/cami2/ref/kraken2
REF_DIR=/fast/lunajang/metabuli/cami2/ref/ref_seq

# 각 파일의 첫 헤더 accession을 매핑 테이블에서 찾아보기
while IFS= read -r -d '' f; do
  acc=$(zcat "$f" 2>/dev/null | awk '/^>/{print $1; exit}' | sed 's/^>//')
  if [ -z "$acc" ]; then
    echo "[NO_HDR] $f"
    continue
  fi
  if zgrep -m1 -F "$acc" "$DB_DIR"/taxonomy/nucl_*.accession2taxid.gz >/dev/null 2>&1; then
    echo "[MAP OK] $acc  <-- $f"
  else
    echo "[NO MAP] $acc  <-- $f"
  fi
done < <(find "$REF_DIR" -type f -name '*.fna.gz' -print0)
