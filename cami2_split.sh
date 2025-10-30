#!/bin/bash
#SBATCH --job-name=kraken2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task 32
#SBATCH --time=10-23
#SBATCH --partition=compute
#SBATCH --nodelist=super001
#SBATCH --output=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_output.log
#SBATCH --error=/home/lunajang/workspace/metabuli_query_binning/cami2_logs/%j_error.log

set -euo pipefail

BASE="/mnt/scratch/lunajang/metabuli/cami2/marine/simulation_short_read"
OUTBASE="/mnt/scratch/lunajang/metabuli/cami2/marine/split"
mkdir -p "$OUTBASE"

find "$BASE" -type f -name "anonymous_reads.fq.gz" | while IFS= read -r IN; do
    SAMPLE="$(basename "$(dirname "$IN")")"
    OUTDIR="$OUTBASE/$SAMPLE"
    mkdir -p "$OUTDIR"
    echo "[INFO] Processing $SAMPLE"
    
    gzip -cd "$IN" | awk -v r1="$OUTDIR/R1.fq" -v r2="$OUTDIR/R2.fq" '
        BEGIN { r=0 }
        {
            h=$0
            if ((getline s) <= 0 )|| ((getline p) <= 0) || ((getline q) <= 0) { exit 1 }
            r++
            if (r%2==1) {
                print h >> r1; print s >> r1; print p >> r1; print q >> r1
            } else {
                print h >> r2; print s >> r2; print p >> r2; print q >> r2
            }
        }
        END {
            close(r1); close(r2)
        }
    '

done
