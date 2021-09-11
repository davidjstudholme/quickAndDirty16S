##!/usr/bin/perl

use strict;
use warnings ;
use Bio::SeqIO ;

my $sequence_file = shift or die "Usage: $0 <sequence file>\n" ;

my $inseq = Bio::SeqIO->new('-file' => "<$sequence_file",
                            '-format' => 'fasta' ) ;

my $outfile_its = "$sequence_file.ITS.fna";
my $outfile_16s = "$sequence_file.16S.fna";

open(OUTFILE_ITS, '>', "./$outfile_its") or die $!;
open(OUTFILE_16S, '>', "./$outfile_16s") or die $!;

while (my $seq_obj = $inseq->next_seq ) {
  
    my $id = $seq_obj->id ;
    my $seq = $seq_obj->seq ;
    my $desc = $seq_obj->description ;
    
    my $rev_16S = "GGACTAC..GGGT.TCTAAT";
    my $fwd_16S = "GTG.CAGC.GCCGCGGTAA";
  
    my $rev_its = "GCTGCGTTCTTCATCGATGC";
    my $fwd_its = "CTTGGTCATTTAGAGGAAGTAA";
  
    my $is_its = 0;
    my $is_16s = 0;
  
  
    if ($seq =~ m/$fwd_16S.*$rev_16S/i ) {
        $is_16s = 1;
    }
    if ($seq =~ m/$fwd_its.*$rev_its/i ) {
        $is_its = 1;
    }


    if ($is_its) {
        print OUTFILE_ITS ">$id $desc\n$seq\n";
    }
    if ($is_16s) {
        print OUTFILE_16S ">$id $desc\n$seq\n";    
    }
    
}


close OUTFILE_16S;
close OUTFILE_ITS;