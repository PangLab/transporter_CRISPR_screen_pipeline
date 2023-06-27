rule bwa_index:
        input:  os.path.join(output_dir,"reference/ACT_align_reference.fasta")
        output: os.path.join(output_dir,"reference/ACT_align_reference.fasta.bwt")
        log: "logs/BWA/make_BWA_index"
        shell:"""
                bwa index -a bwtsw {input}
"""


if "paired" in config:
    rule bwa_map:
        input:  R1=os.path.join(output_dir,"trimmed_reads/{sample}_R1.trim.fastq"), 
                R2=os.path.join(output_dir,"trimmed_reads/{sample}_R2.trim.fastq"),
                refBWA=os.path.join(output_dir,"reference/ACT_align_reference.fasta"), 
                refBWAi=os.path.join(output_dir,"reference/ACT_align_reference.fasta.bwt")
        output: os.path.join(output_dir,"alignments/{sample}.sorted.bam")
        log:    "logs/BWA/{sample}.align"
        threads: CLUSTER["bwa_map"]["cpus-per-task"]
        message: "align {input} to fake reference: {threads} threads"
        shell:
                """
                bwa mem -M -t {threads} -k 12 -T 5 -A1 -B1 -O1 -E1 -L0 {input.refBWA} {input.R1} {input.R2} | samtools sort -O BAM -o {output} 2> {log}
                """

    rule index_bam:
        input:  os.path.join(output_dir,"alignments/{sample}.sorted.bam")
        output: os.path.join(output_dir,"alignments/{sample}.sorted.bam.bai")
        log:    "logs/BWA/{sample}.index_bam"
        threads: 1
        message:"index_bam {input}: {threads} threads"
        shell:
                """
                samtools index {input} > {output} 2> {log}
                """

    rule flagstat_bam:
        input:  os.path.join(output_dir,"alignments/{sample}.sorted.bam")
        output: os.path.join(output_dir,"alignments/{sample}.sorted.bam.flagstat")
        log:    "logs/BWA/{sample}.flagstat_bam"
        threads: 1
        message:"flagstat_bam {input}: {threads} threads"
        shell:
                """
                samtools flagstat {input} > {output} 2> {log}
                """
    
#    rule extract_unpaired_alignments:
#        input: os.path.join(output_dir,"alignments/{sample}.sorted.bam")
#        output: os.path.join(output_dir,"alignments_filtered/{sample}.PEaligns_unpaired.tsv")
#        params: tmp = os.path.join(output_dir,"alignments_filtered/{sample}.F2308.bam")
#        log: "logs/bam_filter/{sample}.unpaired"
#        shell:
#                """
#                samtools view -F 2308 -F 2 -b {input} -o {params.tmp} 2> {log};
#                join -1 1 -2 1 -a1 -a2 -e0 --nocheck-order -i -o'0,1.3,1.5,1.6,1.7,1.9,1.10,2.3,2.5,2.6,2.7,2.9,2.10' <(samtools view -f 65 {params.tmp} | sort -k 1bf,1) <(samtools view -f 129 {params.tmp} | sort -k 1bf,1) > {output};
#                rm {params.tmp}
#                """

    rule filter_bam:
        input:  os.path.join(output_dir,"alignments/{sample}.sorted.bam")
        output: os.path.join(output_dir,"alignments_filtered/{sample}.PEaligns_filtered.tsv"),
        params: tmp = os.path.join(output_dir,"alignments_filtered/{sample}.F2308.bam")
        log:    "logs/bam_filter/{sample}.filter_bam"
        threads: 1
        message:"filter_bam {input}: {threads} threads"
        shell:
                """
                samtools view -F 2308 -f 1 -b {input} -o {params.tmp} 2> {log};
                join -1 1 -2 1 -a1 -a2 -e0 --nocheck-order -i -o'0,1.3,1.5,1.6,1.7,1.9,1.10,2.3,2.5,2.6,2.7,2.9,2.10' <(samtools view -f 65 {params.tmp} | sort -k 1bf,1) <(samtools view -f 129 {params.tmp} | sort -k 1bf,1) > {output};
                rm {params.tmp}
                """ 
