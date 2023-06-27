# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

#--------------------------------------------------------------------------------------------------------#


if "samples" in config:
    rule fastqc:
        input:
            lambda wildcards: config["replicates"][wildcards.replicate]
        output:
            directory("results/qc/{replicate}_R1")
        log:
            "logs/fastqc/{replicate}.log"
        shell:
            "mkdir -p {output}; rm -rf {output}/*; "
            "fastqc -f fastq --extract -o {output} {input} 2> {log}"


    if "paired" in config:
        rule fastqc_paired:
            input:
                lambda wildcards: config["paired_rep"][wildcards.replicate]
            output:
                directory("results/qc/{replicate}_R2")
            log:
                "logs/fastqc/{replicate}_R2.log"
            shell:
                "mkdir -p {output}; rm -rf {output}/*; "
                "fastqc -f fastq --extract -o {output} {input} 2> {log}"


    if "adapter" in config["sgrnas"]:
        rule cutadapt:
            input:
                lambda wildcards: config["replicates"][wildcards.replicate]
            output:
                "results/trimmed_reads/{replicate}.fastq"
            shell:
                "cutadapt -a {config[sgrnas][adapter]} {input} > {output}"
