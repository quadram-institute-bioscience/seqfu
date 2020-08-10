---
title: 'SeqFu: a toolkit for sequence manipulation with native support for paired-end libraries'
tags:
  - DNA sequence
  - fasta
  - fastq
  - genomics
  - bioinformatics
authors:
  - name: Andrea Telatin
    affiliation: 2
    orcid: 0000-0001-7619-281X
affiliations:
  - name: Gut Microbes and Health Programme, Quadram Institute Bioscience, Norwich, UK
    index: 1
date: "10 August 2020"
bibliography: paper.bib

---


# Summary

A common task in bioinformatics is the mapping of DNA sequencing reads (produced by "next generation sequencing" experiments) against a reference genome. 
The output of the alignment is commonly encoded in a BAM file [@samformat]. 
For several applications of DNA sequencing it is useful to extract the *depth of coverage* [@coverage] 
at specific positions in the BAM file, 
encoding the output in the standard BED format [@bedtools].

Here we describe *covtobed*, a C++ program designed to extract the depth of coverage per position from a sorted BAM file, 
optionally specifying a range of coverage of interest and a minimum length for the features to be printed in the output BED file. 
Parsing of BAM files is performed using `libbamtools` [@bamtools]. 

The design has been inspired by the UNIX programming philosophy [@phylosophy], and thus *covtobed* performs a single task and supports input and output streams.

# Availability and Installation

*covtobed* is distributed with MIT licence and available from the [GitHub repository](https://github.com/quadram-institute-bioscience/seqfu), 
and can be easily installed via Miniconda from the "bioconda" channel 
(*i. e.* `conda install -c bioconda seqfu`).


# Code (structure and dependencies)

The code is object oriented, including an *Input* class handling reading, parsing and filtering of alignments and an *Output* class handling coverage filtering and writing in different formats.
The main algorithm is based on a *priority_queue* from the standard library and is both fast and memory efficient.

*covtobed* relies on  `libbamtools` [@bamtools] for BAM file parsing, and `cpp-optparse` [@opt] for command line option parsing.

# Documentation

The package documentation is maintained in the [GitHub wiki](https://github.com/telatin/covtobed/wiki). The documentation contains examples of usage, example of produced output and details about the package.

# List of Tools

When performing target enrichment experiments (where the aim is to sequence a set of selected regions of a genome), it's important to detect a lack of coverage or insufficient coverage (*i.e.* the coverage on target is lower than `THRESHOLD`). This information can be obtained by intersecting (using *bedtools*, [@bedtools]) the BED file describing the captured target regions (usually supplied by the company producing the kit) with the output of *covtobed*. 

The tool has been used, for example, in the setup of a *target enrichment* panel targeting 71 human genes [@poloni], in order to detect uncovered regions.

While a tool exists – called *mosdepth* [@mosdepth] – to perform a coverage analysis, *covtobed* was designed with the ability to quickly extract regions between user-defined coverage intervals and, more importantly, with streaming from standard input and to standard output, that Mosdepth doesn't support. *covtobed* is available both for Linux and macOS, while *mosdepth* is only available for Linux, and this makes *covtobed* a suitable building block for diverse pipelines (_e. g._ microbial genomics requires lesser resources and it is not uncommon to perform complete analyses on a laptop).

# Performance



# Acknowledgements

The author gratefully acknowledge the support of the Biotechnology and Biological Sciences Research Council (BBSRC); 
this research was partly supported by the BBSRC Institute Strategic Programme Gut Microbes and Health BB/R012490/1 and its constituent project BBS/E/F/000PR10353. Analyses and benchmark performed using the MRC CLIMB cloud computing environment supported by grant MR/L015080/1.

# References

