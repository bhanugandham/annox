#!/usr/bin/perl
use strict;
use warnings;

# obtain prokka result statistics for all samples (number of CDS, tRNA, ncRNA)

my $resultDIR = '/home/xwu302/prokkaResults';
my $output = '/home/xwu302/prokkaResults/resultstats.txt';

opendir(DIR, $resultDIR) or die "could not open prokka results directory\n";
open(OUTPUT, ">$output") or die "could not open output file\n";

# print header for output file
print OUTPUT "sampleID\tCDS\ttRNA\tncRNA\n";

# iterate through all sample folders 

while (my $sampleDIR = readdir(DIR)) {
	if ($sampleDIR =~ m/(M\d+)/) {
		my $sampleID = $1;
		open(INPUT, "$resultDIR/$sampleID/$sampleID.txt") or die "could not open sample $sampleID results table\n";
		my ($CDS, $ncRNA, $tRNA);
		while (my $row = <INPUT>) {
			chomp $row;
			if ($row =~ m/CDS.*?(\d+)/) {
				$CDS = $1;
			} elsif ($row =~ m/misc_RNA.*?(\d+)/) {
				$ncRNA = $1;
			} elsif ($row =~ m/tRNA.*?(\d+)/) {
				$tRNA = $1;
			} else {
				next;
			}
		}
		print OUTPUT "$sampleID\t$CDS\t$tRNA\t$ncRNA\n";
	}
}
