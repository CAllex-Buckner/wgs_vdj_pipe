"""Sometimes the pipeline throws the error that the conda environment isn't strict enough.
I used the following function to tighten the environment and it seems to work.
conda config --set channel_priority strict
"""

rule all:
    input:
        "results/qc/multiqc.html"

include: "rules/common.smk"
include: "rules/ref.smk"
include: "rules/mapping.smk"
include: "rules/calling.smk"
include: "rules/qc.smk"