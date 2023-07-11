#!/usr/bin/perl

use strict;
use warnings ;

my $usage = "Usage: $0 <fastq sequence file 1> <fastq sequence file 2>" ;
my $sequence_file1 = shift or die "$usage\n";
my $sequence_file2 = shift or die "$usage\n";


#my $max_count =    50000000; # for oomycetes
#my $max_count =     2500000; # for bacteria
#my $max_count =     3500000; # for bacteria
#my $max_count =     7000000; # for streptomyces
my $max_count = 100000000000000; 


#my $max_count = 1000000000;
#my $max_count =    50000000; # for Aspergillus
my $count=0;

warn "Merging files $sequence_file1 and $sequence_file2; will stop if I reach $max_count reads\n";

open(FILE1, "<$sequence_file1") or die "Failed to open file '$sequence_file1'\n$!\n";
open(FILE2, "<$sequence_file2") or die "Failed to open file '$sequence_file1'\n$!\n";

my ($id1, $seq1);
my ($id2, $seq2);

while (defined (my $id_line = <FILE1>) and
    $count < $max_count) {
    
    if ($id_line =~ m/^@(\S+)/) {
	my $id = $1;
	my $seq_line =<FILE1>;
	chomp $seq_line;
	if ($seq_line =~ m/^([ACGTN]+)/i) {
	    my $seq = $1;
	    my $second_id_line = <FILE1>;
	    if ($second_id_line =~ m/^\+/) {
		my $quality_line = <FILE1>;
		if ($quality_line =~ m/^(\S+)/) {
		    my $quality = $1;
		    
		    $id1 = $id;
		    $seq1 = $seq;
		    
		} else {
		    die "Failed to parse quality line: $quality_line\n";
		}
	    } else {
		die "Failed to parse second id line: $second_id_line\n";
	    }
	} else {
	    die "Failed to parse seq line: $seq_line\n";
	}
    } else {
	die "Failed to parse id line: $id_line\n";
    }
    

    $id_line = <FILE2>;
    if ($id_line =~ m/^@(\S+)/) {
	my $id = $1;
	my $seq_line =<FILE2>;
	chomp $seq_line;
	if ($seq_line =~ m/^([ACGTN]+)/i) {
	    my $seq = $1;
	    my $second_id_line = <FILE2>;
	    if ($second_id_line =~ m/^\+/) {
		my $quality_line = <FILE2>;
		if ($quality_line =~ m/^(\S+)/) {
		    my $quality = $1;
		    
		    $id2 = $id;
		    $seq2 = $seq;
		    
		} else {
		    die "Failed to parse quality line: $quality_line\n";
		}
	    } else {
		die "Failed to parse second id line: $second_id_line\n";
	    }
	} else {
	    die "Failed to parse seq line: $seq_line\n";
	}
    } else {
	die "Failed to parse id line: $id_line\n";
    }

    
    if ( $seq1 =~ m/^[acgt]+/i and
	 $seq2 =~ m/^[acgt]+/i ) {
  	 my $seq2_rc = reverse($seq2);
    	 $seq2_rc =~ tr/ACGTacgt/TGCAtgca/;
	print ">$id1 $id2\n";
	print "$seq1".'NNNNNNNNNN'."$seq2_rc\n";
	$count++;
    } else {
	
    }
}  



