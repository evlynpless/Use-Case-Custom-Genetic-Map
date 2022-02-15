#Processing Selscan output from Nama genetic map test

module load R
module load bedtools2/2.29.2

export HOME=/share/hennlab/users/espless/Selection/NamaGeneticMap
export GENES=/share/hennlab/users/aeckburg

for i in `seq 22`;

  do

    awk -v var=${i} '{print var" "$0}' $HOME/SelscanOut/Nama_pruned_maf0.05_chr1_CombinedGM.ihs.out.100bins.norm > $HOME/SelscanOut/Nama_pruned_maf0.05_chr1_CombinedGM_withChr.ihs.out.100bins.norm
    awk -v var=${i} '{print var" "$0}' $HOME/SelscanOut/Nama_pruned_maf0.05_chr1_NamaGM.ihs.out.100bins.norm > $HOME/SelscanOut/Nama_pruned_maf0.05_chr1_NamaGM_withChr.ihs.out.100bins.norm

  done

cat $HOME/SelscanOut/*CombinedGM_withChr.ihs.out.100bins.norm > $HOME/SelscanOut/Nama_pruned_maf0.05_merged_CombinedGM_withChr.ihs.out.100bins.norm
cat $HOME/SelscanOut/*NamaGM_withChr.ihs.out.100bins.norm > $HOME/SelscanOut/Nama_pruned_maf0.05_merged_NamaGM_withChr.ihs.out.100bins.norm
