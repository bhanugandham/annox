#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;
use Getopt::Long;
use List::MoreUtils qw(uniq);
sub findOperons
{
    my$inputFileName=$ARGV[0];##Name of the input file
    my $dir=$ARGV[1];##Name of the input Directory
    my  $inputFile="$dir/prokka/$inputFileName/$inputFileName.fna";##goes into directories to get to the file whose name has been sepcified in $inputFileName

    `blastn -query $inputFile -db allOPDB.fna -out /$dir/operon/$inputFileName'.blast' -evalue 1e-10 -outfmt "6 qseqid sseqid qstart qend sstart send length bitscore evalue qcovs pident"`;#run blast against operon sequenecs obtained from DOORS 
    my $fileOfInterest="$inputFileName.blast";#Name of the blast result file
    my $readBlastFile="/$dir/operon/$fileOfInterest";##Go into directories to getto the blast result file whose name has been specified in $fileOfInterest
  
#####################Open Blast Result File and read its data in blastData Array######################
    unless ( open(INFILE, $readBlastFile) )
    {
	print "Could not open file!\nCheck spellings and try again\n\t. ";
	exit;
    }
    chomp(my @blastData=(<INFILE>));
    close INFILE;
####################Parse the balstData array (basically going through each line in the blast ouput file), and generate output file##########################
   open OUTFILE, ">/$dir/operon/$fileOfInterest.operons" or die $!;#Open outputfile
   my @OPs;my $i=0;my $x=0;
    print OUTFILE "QueryID\tSubjectID\tQstart\tQend\tPrediction\n";#print header line in output file
   foreach my $value (@blastData)
   { 

   	 my @string=split ("\t", $value);#split each entry at tab to get values for all columns as members of array called string
	 
	 if ($string[9]>=80 && $string[10]>=80)#check if qcovs and pident (last two columns) clear set threshold.Here threshold is 80% for both
	 {
	    push (@OPs, "$string[0]\t$string[1]\t$string[2]\t$string[3]\tPutativeOperon");  #if threshold cleared, add say it is putative operon, and add to array called OP 
	 }
	 else
	 {
	     push (@OPs, "$string[0]\t$string[1]\t$string[2]\t$string[3]\t-");#if threshold not cleared, do not make a prediction i.e. say '-', also add to array called OP
	 }
    }
  
    my @unique_OPs = uniq @OPs;##make sure there is no redundancy in blast results  extracted from input file                                                 
    foreach my$value(@unique_OPs)
    {
	print OUTFILE "$value\n"; #write to output
    }

    close (OUTFILE);
}
#########################Main######################  

main 
{
    findOperons();
 
    exit();
}
