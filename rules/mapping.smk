"""This file contains the rules for trimming raw reads, mapping raw reads to the hg38 reference, and marking duplicates.
May consider adding GATK functions later, but for now this is a simple pipeline build.
"""

# Trimming reads first
rule trim_reads_pe:
    input:
        unpack(get_fastqs)
    output:
        r1="results/trimmed/{sample}-{unit}.1.fastq.gz",
        r2="results/trimmed/{sample}-{unit}.2.fastq.gz",
        r1_unpaired="results/trimmed/{sample}-{unit}.1.unpaired.fastq.gz",
        r2_unpaired="results/trimmed/{sample}-{unit}.2.unpaired.fastq.gz",
        trimlog="results/trimmed/{sample}-{unit}.trimlog.txt"
    log:
        "logs/trimmomatic/{sample}-{unit}.log"
    params:
      trimmer=["LEADING:3", "TRAILING:3", "SLIDINGWINDOW:4:15", "MINLEN:36"],
      extra="",
      compression="-9"
    threads:
        16
    resources:
        mem_mb=1024
    wrapper:
        "v1.7.0/bio/trimmomatic/pe"

# Bwa mem mapping of reads

rule bwa_mem:
    input:
        reads=get_trimmed_reads,
        idx=multiext("genome", ".amb", ".ann", ".bwt", ".pac", ".sa")
    output:
        "results/mapped/{sample}-{unit}.sorted.bam"
    log:
        "logs/bwa/{sample}-{unit}.log"
    params:
        extra=get_read_group,
        sorting="samtools",  # Can be 'none', 'samtools' or 'picard'.
        sort_order="coordinate",  # Can be 'queryname' or 'coordinate'.
        sort_extra=""  # Extra args for samtools/picard.
    threads: 16
    wrapper:
        "v1.7.0/bio/bwa/mem"

rule mark_duplicates:
    input:
        bams="results/mapped/{sample}-{unit}.sorted.bam"
    # optional to specify a list of BAMs; this has the same effect
    # of marking duplicates on separate read groups for a sample
    # and then merging
    output:
        bam="results/dedup/{sample}-{unit}.bam",
        metrics="results/qc/dedup/{sample}-{unit}.metrics.txt"
    log:
        "logs/picard/dedup/{sample}-{unit}.log"
    params:
        extra="--REMOVE_DUPLICATES true"
    resources:
        mem_mb=1024
    wrapper:
        "v1.7.0/bio/picard/markduplicates"

