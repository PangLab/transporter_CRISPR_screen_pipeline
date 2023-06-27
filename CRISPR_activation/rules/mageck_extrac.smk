rule generate_mageckflute_plots_extra:
	input:	genesummary=os.path.join(output_dir,"screen_analysis/extra_results/{extra}_vs_con.gene_summary.txt"),
		sgrnasummary=os.path.join(output_dir,"screen_analysis/extra_results/{extra}_vs_con.sgrna_summary.txt")
	output:	essential_pdf=os.path.join(output_dir,"screen_analysis_plots/extra_results/{extra}_vs_con.rra.keep_essential_genes.pdf"),
		nonessential_pdf=os.path.join(output_dir,"screen_analysis_plots/extra_results/{extra}_vs_con.rra.remove_essential_genes.pdf")
	params: out_dir=os.path.join(output_dir,"screen_analysis_plots/extra_results")
	log:	"logs/{extra}_generate_mageckflute_plots_extra.log"
	shell:
		"""
		module load statistical/R/3.6.2/gcc.8.3.1
		mkdir -p {params.out_dir};
		Rscript scripts/mageckflute.R {input.genesummary} {input.sgrnasummary} \
			{output.essential_pdf} {output.nonessential_pdf} 2> {log}
		"""
