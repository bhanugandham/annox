# annox
We developed a pipeline, ANNOX, to combine multiple functional annotation tools into one streamlined process. Available pipelines, such a Prokka and BG7, only contain a limited number of functional annotation tools. We aimed to create a pipeline that contained a larger variety of functional annotation tools to cover as many features as possible. There are two levels of functional annotation in ANNOX. The first level contains the tools that were identified to be most helpful for further species identification. These tools annotate the coding region, CRISPRs, and OPERONS. The second level of annotation adds additional functional annotation tools which may be of interest to the researcher. The second level annotation contains tools for transmembrane proteins, tRNAs, signal peptides, domains/motifs, pathways, and virulence factors. The requirement that the individual tools within the pipeline be command-line interface was often the largest limitation in choosing a tool.

CompGenomics 2015 Genome Annotation

prokkaAuto.pl: Runs prokka on all spades assemblies

prokkaResultStats.pl: Obtains result statitics of Prokka output
