from Bio.Seq import Seq


if "sgrnas" in config:
	config["sgrnas"]["adapter"] = Seq(config["sgrnas"]["adapter"])
	config["sgrnas"]["adapter_rv"] = config["sgrnas"]["adapter"].reverse_complement()
	config["sgrnas"]["scaffold"] = Seq(config["sgrnas"]["scaffold"])
	config["sgrnas"]["scaffold_rv"] = config["sgrnas"]["scaffold"].reverse_complement()

if "samples" in config:
	if "paired" in config:
		rule cutadapt_pe:
			input:  R1 = lambda wildcards: config['replicates'][wildcards.sample]['r1'],
				R2 = lambda wildcards: config['replicates'][wildcards.sample]['r2']
			output: R1p = os.path.join(output_dir,"trimmed_reads/{sample}_R1.trim.fastq"),
				R2p = os.path.join(output_dir,"trimmed_reads/{sample}_R2.trim.fastq")
			log:	"logs/cutadapt_pe/{sample}.trim.log"
			threads: CLUSTER["cutadapt_pe"]["cpus-per-task"]
			shell:
				"""
				cutadapt --pair-filter=any -j {threads} -q 15,10 -e 0.1 \
					-g {config[sgrnas][adapter]}...{config[sgrnas][scaffold]} \
					-G {config[sgrnas][scaffold_rv]}...{config[sgrnas][adapter_rv]} \
					-o {output.R1p} -p {output.R2p} {input.R1} {input.R2}
				"""
	else:
		rule cutadapt_se:
			input:  lambda wildcards: config['replicates'][wildcards.sample]['r1']
			output: os.path.join(output_dir, "trimmed_reads/{sample}.trim.fastq")
			log:	"logs/cutadapt_se/{sample}.trim.log"
			threads: CLUSTER["cutadapt_se"]["cpus-per-task"]
			shell:
				"""
				cutadapt --minimum-length=5 -j {threads} -q 15,10 -e 0.1 \
					-g {config[sgrnas][adapter]} -a {config[sgrnas][scaffold]} \
					-o {output} {input}
				"""
