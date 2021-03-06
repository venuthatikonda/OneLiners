

# Combine regions based on a column value - BedTools

cat A.bed

chr1 1  10 2
chr1 10 20 3
chr1 20 30 3

result

chr1 1  10 2
chr1 10 30 3

cat A.bed | sort -k4,4 -k2,2 -k3,3n | groupBy -g 1,4 -c 2,3 -o min,max -full | awk -v OFS="\t" ' { print $1,$5,$6,$4}' 


# make 1MB bins of reference genome

https://www.biostars.org/p/70577/


# calculate all exon lengths of all genes 

wget "ftp://ftp.ensembl.org/pub/release-84/gtf/homo_sapiens/Homo_sapiens.GRCh38.84.gtf.gz"

zcat Homo_sapiens.GRCh38.84.gtf.gz | awk '{if($3=="exon") print $10"\t"$5-$4}' | sed -e 's/"//g' -e 's/;//' | bedtools groupby -i - -g 1 -c 2 -o sum > Exon_lengths.txt

# Execute commands on all files paralelly - install `parallel`

(wget -O - pi.dk/3 || curl pi.dk/3/ || fetch -o - http://pi.dk/3) | bash

#parallel example with TopHat bam2fastx
#converts BAM to fastq parallelly 

parallel 'bam2fastx --fastq {} > {.}.fq' ::: *.bam

## GATK - Broad's hg19 build (for compatibility issues, we use this)

wget ftp://ftp.broadinstitute.org/pub/seq/references/Homo_sapiens_assembly19.fasta

# This build is compatible with dbSNP vcf file

wget ftp://ftp.ncbi.nlm.nih.gov/snp/organisms/human_9606/VCF/00-All.vcf.gz

# 1K Genome - Phase-3 VCF

 wget "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.vcf.gz"

# SAM file processing

#Get only mapped reads from SAM/bam
samtools view -b -F 4 file.bam > mapped.bam

#for Unmapped
samtools view -b -f 4 file.bam > unmapped.bam



#Generate a vcf.gz along with its tabix indexed file
#To use with vcftools

bgzip -c file.vcf > file.vcf.gz
tabix -p vcf file.vcf.gz

tabix -h vcf_file.vcf.gz chr1:1000-1000 # make a subset of VCF file along with header

#Compare two VCF files and list out variants present in file1 only

vcf-isec -c file1.vcf.gz file2.vcf.gz file3.vcf.gz | bgzip -c > file1_only.vcf.gz

# Common variants in 2 VCF files

vcf-isec -n +2 file1.vcf.gz file2.vcf.gz | bgzip -c > CommonVar.vcf.gz

#Average depth from a VCF file

zcat file.vcf.gz | grep -v '^#' | grep -oP "DP=\w+" | sed 's/DP=//' | awk '{s += $1}END{print s/NR}'

# FIlter any VCF file based on arbitrary terms, snpsift.jar

java -jar ~/seq-tools/snpEff/SnpSift.jar filter "(QUAL>30) & (AF > 0.15) & (AO > 4) & (DP > 10) & (STB < 0.95)" in.vcf 

#VCF processing for SciClone input (Tumor heterogeneity)
#VCF V4.1, Ion Proton variant caller generated vcf 

cut -f 1,2,8 vcf_file.vcf | sed 's/;/\t/g' | cut -f 1,2,4,5 | awk '{print $1"\t"$2"\t"$4"\t"$3}' | sed 's/DP=//' | sed 's/AO=//' | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$3-$4"\t"$4"\t"$4/$3*100}' | cut -f 1,2,5-7 > sciclone_input.txt

