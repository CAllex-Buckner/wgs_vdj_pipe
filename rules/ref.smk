"""This file is for the downloading and reference building for bwa mapping and downstream processes.
This may be updated in the future to account for variant files and other reference files.
"""

rule get_genome:
    output:
        "resources/genome.fasta"
    params:
        species="homo_sapiens",
        datatype="dna",
        build="GRCh38",
        release="106"
    log:
        "logs/reference/get_genome.log"
    cache: True  # save space and time with between workflow caching (see docs)
    wrapper:
        "v1.7.0/bio/reference/ensembl-sequence"

rule bwa_index:
    input:
        "resources/genome.fasta"
    output:
        idx=multiext("{genome}", ".amb", ".ann", ".bwt", ".pac", ".sa")
    log:
        "logs/bwa_index/{genome}.log"
    params:
        algorithm="bwtsw"
    wrapper:
        "v1.7.0/bio/bwa/index"

rule samtools_index:
    input:
        "resources/genome.fasta"
    output:
        "resources/genome.fasta.fai"
    log:
        "logs/samtools_faidx/genome.log"
    params:
        extra=""  # optional params string
    wrapper:
        "v1.7.0/bio/samtools/faidx"

