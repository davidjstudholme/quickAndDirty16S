#!/usr/bin/perl

use strict ;
use warnings ;
use Bio::SearchIO;
use Bio::SeqIO;

my $min_id_pc = 97;
my %taxon_to_count;


my $file = shift or die;

my $parser = new Bio::SearchIO(-format => 'blast', -file => $file) ; 

while(my $result = $parser->next_result) {
    my $query_acc = $result->query_accession;
    my $query_desc = $result->query_description;

    if (my $hit = $result->next_hit) {
	
	my $coverage = 100 * $hit->frac_aligned_query();
	my $hit_desc = $hit->description();
	my $hit_accession = $hit->accession;
	
	while (my $hsp = $hit->next_hsp) {
	    
	    my $significance = $hsp->significance;
	    my $start = $hsp->start('hit') ;
	    my $end = $hsp->end('hit') ;
	    my $pc_identical = 100 * $hsp->frac_identical; 
	    
	    if ($coverage >= 95 and
		$pc_identical >= $min_id_pc) {
	
		my $taxon = $hit_desc;
		if ($taxon =~ m/(.*)\s*16S ribosomal RNA gene/) {
		    $taxon = $1;
		}
		if ($taxon =~ m/(.*)\s*strain/) {
		    $taxon = $1;
		}
		if ($taxon =~ m/(.*)\s*subsp./) {
		    $taxon = $1;
		}
		
		
		
		$taxon_to_count{$taxon}++;
		#warn "$query_acc\t=>\t$pc_identical\t$taxon\n";
	    }
	}
    }
}

### Calculate total count
my $total_count = 0;
foreach my $taxon (sort keys %taxon_to_count) {
    $total_count += $taxon_to_count{$taxon};
}
warn "total count: $total_count\n";

foreach my $taxon (sort keys %taxon_to_count) {
    my $pc_abundance = 100 * $taxon_to_count{$taxon} / $total_count;
    print "$file\t$taxon\t$taxon_to_count{$taxon}\t$pc_abundance\n";
}
