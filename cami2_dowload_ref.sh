#!/bin/bash
#SBATCH --job-name=download_cami2_reads
#SBATCH --nodes=1
#SBATCH --nodelist=super003
#SBATCH --ntasks=1
#SBATCH --time=1-12:00:00
#SBATCH --output=/fast/lunajang/metabuli/cami2/download_logs/%j.out   
#SBATCH --error=/fast/lunajang/metabuli/cami2/download_logs/%j.err      

# 작업 디렉토리 (필요시 수정)
cd /fast/lunajang/metabuli/cami2/db

# 다운로드 루프
wget -c "https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/CAMI_2_DATABASES/ncbi_taxonomy_accession2taxid.tar"
wget -c "https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/CAMI_2_DATABASES/RefSeq_genomic_20190108.tar"
wget -c "https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/CAMI_2_DATABASES/ncbi_taxonomy.tar"
wget -q https://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt


echo "All downloads completed."