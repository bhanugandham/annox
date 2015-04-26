#!/usr/bin/env perl
use strict;
use warnings;

# runs prokka on all assemblies, includes annotation of protein, rRNA, tRNA, signal peptides and other ncRNAs

my $assemblyDIR = "/home/xwu302/processedAssemblies"; # assembly directory
my $resultDIR = "/home/bgandham3/annoxOUT/prokka"; # output directory for Prokka results

# export necessary binaries to user PATH
system('export PATH=$PATH:/home/xwu302/bin'); system('export PATH=$PATH:/home/xwu302/prokka-1.11/bin');

opendir(DIR, $assemblyDIR) or die "could not open directory containing assemblies\n";

# iteratr through all assemblies in the assembly directory and runs Prokka on these assemblies
while (my $filename = readdir(DIR)) {
	if ($filename =~ m/(.*)\.contig/) {
		my $sampleID = $1; # sample ID of assembly
		my $inputContig = "$assemblyDIR/$filename"; # path to assembly
		my $outDIR = "$resultDIR/$sampleID"; # path to output directory
		system("prokka --force --outdir $outDIR --prefix $sampleID --rfam $inputContig"); # runs prokka for assembly
	}
}
