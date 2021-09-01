#!/usr/bin/perl

use strict ;
use warnings ;

my %taxon_to_sample_to_abundance;
my %samples;

### Read the input files
while (my $infile = shift) {
    open(INFILE, "<$infile") or die "$!";
    while (<INFILE>) {
	chomp;
	my ($sample, $taxon, $count, $percentage) = split /\t/;
	$sample =~ s/\.extendedFrags.fastq.fasta.versus.complete.rna.fna.blastn//;
	$taxon_to_sample_to_abundance{$taxon}{$sample} = $percentage;
	$samples{$sample}++;
    }
}

### Print header line
print "Taxon";
foreach my $sample (sort keys %samples) {
    print "\t";
    print "$sample";
}
print "\n";



### Print the output matrix
foreach my $taxon (sort keys %taxon_to_sample_to_abundance) {
    print "$taxon";
    foreach my $sample (sort keys %samples) {
	my $abundance = $taxon_to_sample_to_abundance{$taxon}{$sample};
	$abundance = 0 unless defined $abundance;
	print "\t";
	print "$abundance";
    }
    print "\n";
}
