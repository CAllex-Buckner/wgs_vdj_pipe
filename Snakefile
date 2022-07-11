rule all:
    input:
        "results/qc/multiqc.html"

include: "rules/common.smk"
include: "rules/ref.smk"
include: "rules/mapping.smk"
include: "rules/calling.smk"
include: "rules/qc.smk"