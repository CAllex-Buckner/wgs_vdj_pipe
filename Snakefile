rule all:
    input:
        "results/qc/multiqc.html"

include: "common.smk"
include: "ref.smk"
include: "mapping.smk"
include: "calling.smk"
include: "qc.smk"