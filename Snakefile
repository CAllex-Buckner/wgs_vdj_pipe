rule all:
    input:
        "results/qc/multiqc.html"

include: "rules/calling.smk"
include: "rules/calling.smk"
include: "rules/calling.smk"
include: "rules/calling.smk"
include: "rules/calling.smk"