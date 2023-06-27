rule generate_mageckflute_plots:
	input:	genesummary=os.path.join(output_dir,"screen_analysis/{case}_vs_con.gene_summary.txt"),
		sgrnasummary=os.path.join(output_dir,"screen_analysis/{case}_vs_con.sgrna_summary.txt")
	output:	essential_pdf=os.path.join(output_dir,"screen_analysis_plots/{case}_vs_con.mageck_rra.keep_essential_genes.pdf"),
		nonessential_pdf=os.path.join(output_dir,"screen_analysis_plots/{case}_vs_con.mageck_rra.remove_essential_genes.pdf")
	params: out_dir=os.path.join(output_dir,"screen_analysis_plots")
	shell:
		"""
		module load statistical/R/3.6.2/gcc.8.3.1
		mkdir -p {params.out_dir};
		Rscript scripts/mageckflute.R {input.genesummary} {input.sgrnasummary} \
			{output.essential_pdf} {output.nonessential_pdf}
		"""

rule mageck_rra:
	input:	counts=os.path.join(output_dir,"counts_table/all_samples_assigned_count.csv"),
		controlsg=os.path.join(output_dir,"reference/neg_sgrna_control.txt")
	output:	genesummary=os.path.join(output_dir,"screen_analysis/{case}_vs_con.gene_summary.txt"),
		sgrnasummary=os.path.join(output_dir,"screen_analysis/{case}_vs_con.sgrna_summary.txt"),
		pdf=os.path.join(output_dir,"screen_analysis/{case}_vs_con.pdf")
		#indivoutput=(expand("results/screen_analysis/{{case}_vs_con}.{nsample}_vs_{day0}.sgrna_summary.txt",nsample=get_sample_name(config),day0=config["day0label"]) if "day0label" in config else [])
	params:	prefix=os.path.join(output_dir,"screen_analysis/{case}_vs_con"),
		treatment=lambda wildcards: ",".join(CASE_IDS[wildcards.case]),
		control=lambda wildcards: ",".join(CONTROL_IDS),
		#day0=("" if not "day0label" in config else "--day0-label "+config["day0label"]),
		norm=get_norm_method(config),
		#controlsg=("" if not "control_sgrna" in config else "--control-sgrna "+config["control_sgrna"]),
		#cnv_correct=("" if not config["correct_cnv"] else "--cnv-norm "+config["cnv_norm"]+" --cell-line "+config["cnv_cell_line"]),
		additionalparameter=("" if not "additional_rra_parameter" in config else " "+config["additional_rra_parameter"])
	log:	"logs/mageck/rra_{case}.log"
	shell:
		"""
		module load statistical/R/3.6.2/gcc.8.3.1
		mageck test --norm-method {params.norm} \
			--output-prefix {params.prefix} \
			--count-table {input.counts} \
			--control-sgrna {input.controlsg} \
			--treatment-id {params.treatment} \
			--control-id {params.control} \
			{params.additionalparameter} 2> {log}
		"""
