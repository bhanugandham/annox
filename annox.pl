#!/usr/bin/perl

############THIS SCRIPT IS FULLY ANNOTATED BACTERIAL GENOME ANNOTATION PIPELINE##########
############FOR DETAILS REFER README#####################################################
############AUTHORS: SHASHIDHAR, XIN, MARZIA, BHANU######################################

use strict;
use Term::ANSIColor;

#####################INPUTS FROM USER IF THE FIRST OR SECOND LINE OF ANNOTATION IS REQUIRED#########
print "Please enter <FIRST> for first line of annotation or <ALL> for all annotations\n";
chomp(my $opt = <STDIN>);
#####################INPUTS FROM USER FOR ABSOLUTE PATH OF OUTPUT DIRECTORY#########
print "Enter enter absolute path to output directory\n";
chomp(my $outdir = <STDIN>);

######################SAMPLE NAMES SHOULD BE IN A TEXT FILE, ONE SAMPLE IN ONE LINE; FILE SHOULD BE IN SAME FOLDER AS THE SCRIPT#############
my $samplenamesfile = 'samplenames.txt';
open(FILE, $samplenamesfile);
chomp(my @samplenames = <FILE>);
close FILE;
###################samples_nm and samples_hi are sample names seperated based on NM and HM species######
my $samples_nm = 'samples_nm';
open(FILE, $samples_nm);
chomp(my @samples_nm = <FILE>);
close FILE;

my $samples_hi = 'samples_hi';
open(FILE, $samples_hi);
chomp(my @samples_hi = <FILE>);
close FILE;

##################First line of annotation###################
if(lc $opt eq 'first')
{
    goto FIRST;
}
########################Second line of annotation############
elsif(lc $opt eq 'all')
{
    goto ALL;
}
else
{
    print "Error input option\n";
    die;
}
############Prokka pipeline script##########
`perl /home/xwu302/scripts/prokkaAuto.pl $outdir`;
FIRST:
foreach my $x (@samplenames)
{
#############Crispr script#########
`perl /home/sravishankar9/CRISPR/find_crispr.pl -i /data/assembly/SPADES/$y-SPADES-contig.fa -o $outdir/crispr -r /home/sravishankar9/CRISPR/crispr_db/DR_database`;
#########################Operon Script#########
`perl /home/srizvi34/OperonFiles/find_Operons.pl $x $outdir`;
}
exit;
ALL:
`makeblastdb -dbtype nucl -in $outdir/VFs.ffn`;
foreach my $x (@samplenames)
{
#############Crispr script#####################
`perl /home/sravishankar9/CRISPR/find_crispr.pl -i /data/assembly/SPADES/$y-SPADES-contig.fa -o $outdir/crispr -r /home/sravishankar9/CRISPR/crispr_db/DR_database`;
#########################Operon Script######### 
`perl /home/srizvi34/OperonFiles/find_Operons.pl $x $outdir`;
#########################VFDB##################
`blastn -db $outdir/VFs.ffn -query /data/assembly/SPADES/$y-SPADES-contig.fa -outfmt 6 > $outdir/virulenceFactors/$x`;
#########################Signalp###############
`signalp -t gram- -f short $outdir/prokka/$x/$x.faa > $outdir/signalp/$x-signalp-out`;
####################Interproscan###############
`interproscan.sh -i $outdir/prokka/$x/$x.faa -f gff3 -d $outdir/interproscan/`;
#########################TMHMM#################
`/home/sravishankar9/MembraneProteins/find_tm.pl $x $x /home/bgandham3/annoxOUT/tmhmm`;

}
#########Kobas run for NM species######
foreach my $y ($samples_nm)
{
`blastp -db /home/mli373/kobas/blastdb/nm/nm.pep.fasta -query /data/assembly/SPADES/$y-SPADES-contig.fa -outfmt 6 $y_blasttab.out`;
`annotate.py -i $y_blasttab.out -s nm -t blastout::tab -o $y_kobas_out.txt`;
}
#########Kobas run for HI species######
foreach my $z ($samples_hi)
{
`blastp -db /home/mli373/kobas/blastdb/hi/hi.pep.fasta -query /data/assembly/SPADES/$z-SPADES-contig.fa -outfmt 6 $z_blasttab.out`;
`annotate.py -i $z_blasttab.out -s hi -t blastout::tab -o $z_kobas_out.txt`;
}
