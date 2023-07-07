# What is this?

Here you can find the code used by Laboratory #7 in the following study:

O'Sullivan, D. M., Doyle, R. M., Temisak, S., Redshaw, N., Whale, A. S., Logan, G., 
Huang, J., Fischer, N., Amos, G., Preston, M. D., Marchesi, J. R., Wagner, J., Parkhill, J., 
Motro, Y., Denise, H., Finn, R. D., Harris, K. A., Kay, G. L., O'Grady, J., Ransom-Jones, E., … Huggett, J. F. (2021). 
An inter-laboratory study to investigate the impact of the bioinformatics component on microbiome analysis using mock communities. 
*Scientific Reports* **11**: 10590. https://doi.org/10.1038/s41598-021-89881-2.

In the [Supplementary Information 4](https://static-content.springer.com/esm/art%3A10.1038%2Fs41598-021-89881-2/MediaObjects/41598_2021_89881_MOESM4_ESM.xlsx) file
from that study, two scripts are mentioned, which are deposited in this repository.

# The analysis 'pipeline'
In the [O'Sullivan paper](https://doi.org/10.1038/s41598-021-89881-2), we present a really simple, quick and dirty analysis 'pipeline' for quantifying
bacteria in a mock community, based on sequencing 16S rDNA amplicons. This is described in [Supplementary Information 4](https://static-content.springer.com/esm/art%3A10.1038%2Fs41598-021-89881-2/MediaObjects/41598_2021_89881_MOESM4_ESM.xlsx) but, for convenience, is repeated here:

We used a relatively crude and straightforward approach of BLASTN searches of sequence reads against the RefSeq RNA database and classifying the read as belonging to the biological species of the best BLASTN hit, if that best hit shares at least 97% sequence identity along at least 95% of the query sequence length. Prior to BLASTN searching, read pairs were assembled into single consensus reads using FLASH v. 1.2.10. Read pairs that FLASH failed to merge were discarded.
 
The RefSeq RNA database was downloaded from ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/  on 26th May 2017 and contains 18,901,573 sequences.

Command lines:
 
## Step 1: Assembling read pairs using [FLASH](https://doi.org/10.1093/bioinformatics/btr507) and convert fastq to fasta
```
for i in MCM2a1_S1_L001 MCM2a2_S2_L001 MCM2a3_S3_L001 MCM2b1_S4_L001 MCM2b2_S5_L001 MCM2b3_S6_L001; do ~/FLASH-1.2.10/flash --output-prefix=$i.12   $i"_R1.12.fastq" $i"_R2.12.fastq"; done
 
for i in MCM2a1_S1_L001 MCM2a2_S2_L001 MCM2a3_S3_L001 MCM2b1_S4_L001 MCM2b2_S5_L001 MCM2b3_S6_L001; do ~/FLASH-1.2.10/flash --output-prefix=$i.456   $i"_R1.456.fastq" $i"_R2.456.fastq"; done
 
for i in *.extendedFrags.fastq ; do echo $i; ./fastq2fasta.pl $i > $i.fasta; done
```
Magoč, T., & Salzberg, S. L. (2011). FLASH: fast length adjustment of short reads to improve genome assemblies. *Bioinformatics* **27**: 2957–2963. https://doi.org/10.1093/bioinformatics/btr507


## Step 2: Performing BLASTN searches:
```
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2a1_S1_L001.12.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2a1_S1_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2a1_S1_L001.456.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2a1_S1_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2a2_S2_L001.12.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2a2_S2_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2a2_S2_L001.456.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2a2_S2_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2a3_S3_L001.12.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2a3_S3_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2a3_S3_L001.456.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2a3_S3_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2b1_S4_L001.12.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2b1_S4_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2b1_S4_L001.456.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2b1_S4_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2b2_S5_L001.12.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2b2_S5_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2b2_S5_L001.456.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2b2_S5_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2b3_S6_L001.12.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2b3_S6_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
blastn -db  complete.rna.fna  -num_alignments 15   -query MCM2b3_S6_L001.456.extendedFrags.fastq.fasta  -evalue 1e-20 -out MCM2b3_S6_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn
```
 
## Step 3: Parse the BLASTN results
```
perl ./get_abundances_from_blastn.pl MCM2a1_S1_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2a1_S1_L001.12.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2a1_S1_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2a1_S1_L001.456.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2a2_S2_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2a2_S2_L001.12.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2a2_S2_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2a2_S2_L001.456.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2a3_S3_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2a3_S3_L001.12.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2a3_S3_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2a3_S3_L001.456.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2b1_S4_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2b1_S4_L001.12.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2b1_S4_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2b1_S4_L001.456.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2b2_S5_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2b2_S5_L001.12.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2b2_S5_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2b2_S5_L001.456.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2b3_S6_L001.12.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2b3_S6_L001.12.extendedFrags.fastq.fasta.abundances.csv
perl ./get_abundances_from_blastn.pl MCM2b3_S6_L001.456.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn > MCM2b3_S6_L001.456.extendedFrags.fastq.fasta.abundances.csv
```

## Step 4: Finally, combine the data for each sample into a single matrix file
``` 
./combine_abundances_into_single_matrix.pl *fasta.abundances.csv > abundances_matrix.csv
```

# What if my paired reads don't overlap?
If the length of the amplicon is greater than the sum of the lengths of the pair of reads, then those two reads will not overlap. That is, there is a gap on unknown sequence separating the pair of reads. Therefore, FLASH will fail to assemble the pair into a single 'read'. In this situation, a possible solution is to concatenate the pair of reads together, with a series of Ns inserted between the two reads to represent the gap of unknown sequence.

To assemble the read pairs by concatenation, use the concatenate-fastq-pairs.pl script:
```
perl concatenate-fastq-pairs.pl fwd_reads_file.fq rev_reads_file.fq > concated_reads_file.fq
```
You may then wish to convert the resulting FASTQ file into FASTA, as a suitable input for BLAST, KRAKEN, etc:
```
perl fastq2fasta.pl concated_reads_file.fq > concated_reads_file.fasta
```
