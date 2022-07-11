rule bcftools_mpileup:
    input:
        index="resources/genome.fasta.fai",
        ref="resources/genome.fasta", # this can be left out if --no-reference is in options
        alignments="results/dedup/{sample}-{unit}.bam"
    output:
        pileup="pileups/{sample}-{unit}.pileup.bcf"
    params:
        options="--max-depth 100 --min-BQ 15"
    log:
        "logs/bcftools_mpileup/{sample}-{unit}.log"
    wrapper:
        "v1.7.0/bio/bcftools/mpileup"

rule varscan_indel_call:
    input:
        "pileups/{sample}-{unit}.pileup.bcf"
    output:
        "vcf/{sample}-{unit}.indel.vcf"
    message:
        "Calling Indel with Varscan2"
    threads:  # Varscan does not take any threading information
        1     # However, mpileup might have to be unzipped.
              # Keep threading value to one for unzipped mpileup input
              # Set it to two for zipped mipileup files
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    log:
        "logs/varscan_{sample}-{unit}.indel.log"
    wrapper:
        "v1.7.0/bio/varscan/mpileup2indel"

rule varscan_snp_call:
    input:
        "pileups/{sample}-{unit}.pileup.bcf"
    output:
        "vcf/{sample}-{unit}.snp.vcf"
    message:
        "Calling SNP with Varscan2"
    threads:  # Varscan does not take any threading information
        1     # However, mpileup might have to be unzipped.
              # Keep threading value to one for unzipped mpileup input
              # Set it to two for zipped mipileup files
    # optional specification of memory usage of the JVM that snakemake will respect with global
    # resource restrictions (https://snakemake.readthedocs.io/en/latest/snakefiles/rules.html#resources)
    # and which can be used to request RAM during cluster job submission as `{resources.mem_mb}`:
    # https://snakemake.readthedocs.io/en/latest/executing/cluster.html#job-properties
    resources:
        mem_mb=1024
    log:
        "logs/varscan_{sample}-{unit}.snp.log"
    wrapper:
        "v1.7.0/bio/varscan/mpileup2snp"
