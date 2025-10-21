#!/bin/bash
#SBATCH --job-name=cami2
#SBATCH --nodes=1
#SBATCH --nodelist=super003
#SBATCH --ntasks=1
#SBATCH --time=1-12:00:00
#SBATCH --output=/fast/lunajang/metabuli/cami2/download_logs/%j.out   
#SBATCH --error=/fast/lunajang/metabuli/cami2/download_logs/%j.err      

cd /fast/lunajang/metabuli/cami2/ref

wget -c "https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/CAMI_2_DATABASES/ncbi_taxonomy_accession2taxid.tar" 
wget -c "https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/CAMI_2_DATABASES/RefSeq_genomic_20190108.tar"
wget -c "https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/CAMI_2_DATABASES/ncbi_taxonomy.tar"
wget -c https://ftp.ncbi.nlm.nih.gov/genomes/refseq/assembly_summary_refseq.txt


echo "All downloads completed."