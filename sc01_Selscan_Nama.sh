#Selection scan for Nama genotype array data using custom genetic map vs. standard genetic map resource

export MAP=/share/hennlab/reference/recombination_maps/maps_GeraldEeden_Aug2021 #custom map
export HOME=/share/hennlab/users/espless/Selection/NamaGeneticMap

module load plink/1.90p
module load selscan/1.3.0
module load shapeit/2.r904
module load vcftools


for i in {1..22}

do

    #Remove related and admixed individuals

    shapeit -convert --input-haps $HOME/ShapeItOut/oriented_omni2.5-8_gdafpr_20141016.gencall.smajor_nama108_IDsFixed_noContamination102_dbsnp138_flip_autosomes_exclude_chr${i} --output-vcf $HOME/ShapeItOut/Nama_Omni2.5_chr${i}.vcf

    vcftools --vcf $HOME/ShapeItOut/Nama_Omni2.5_chr${i}.vcf --keep $HOME/Nama_unrelated.txt --remove $HOME/AdmixedToRemove.txt --recode --recode-INFO-all --out $HOME/NoRelativesOrAdmixed/Nama_pruned_chr${i}

    vcftools --vcf $HOME/NoRelativesOrAdmixed/Nama_pruned_chr${i}.recode.vcf --maf 0.05 --recode --recode-INFO-all --out $HOME/NoRelativesOrAdmixed/Nama_pruned_maf0.05_chr${i}

    #Make map files for Selscan

    plink --vcf $HOME/NoRelativesOrAdmixed/Nama_pruned_maf0.05_chr${i}.recode.vcf --recode --make-bed --out $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}

    plink --bfile $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i} --cm-map $MAP/nama_chr${i}.map ${i} --make-bed --out $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_NamaGM

    plink --bfile $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i} --cm-map $MAP/combined_chr${i}.map ${i} --make-bed --out $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_CombinedGM

    plink --bfile $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_NamaGM --recode tab --out $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_NamaGM

    plink --bfile $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_CombinedGM --recode tab --out $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_CombinedGM

    #Generate normalized iHS scores using Selscan

    selscan --ihs --vcf $HOME/NoRelativesOrAdmixed/Nama_pruned_maf0.05_chr${i}.recode.vcf --map $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_NamaGM.map --out $HOME/SelscanOut/Nama_pruned_maf0.05_chr${i}_NamaGM --threads 4

    norm --ihs --bins 100 --files $HOME/SelscanOut/Nama_pruned_maf0.05_chr${i}_NamaGM.ihs.out

    selscan --ihs --vcf $HOME/NoRelativesOrAdmixed/Nama_pruned_maf0.05_chr${i}.recode.vcf --map $HOME/GeneticMapsPlink/Nama_pruned_maf0.05_chr${i}_CombinedGM.map --out $HOME/SelscanOut/Nama_pruned_maf0.05_chr${i}_CombinedGM --threads 4;

    norm --ihs --bins 100 --files $HOME/SelscanOut/Nama_pruned_maf0.05_chr${i}_CombinedGM.ihs.out

    done
