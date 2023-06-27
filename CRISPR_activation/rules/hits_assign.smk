rule assign_hits:
	input:	Counts=expand(os.path.join(output_dir,"alignments_filtered/{replicate}_merged_technical_reps.tsv"), replicate=REPLICATE_IDS),
		Ref=config['library']
	output:	os.path.join(output_dir,"counts_table/all_samples_assigned_count.csv")
	params: q = 10, Q = 30
	run:
		table = {}
		sample_ids = []
		for countF in input.Counts:
			iBase = os.path.basename(countF).split('_merged')[0]
			sample_ids.append(iBase)
		FIRSTLINE=False
		with open(str(input.Ref), 'r+') as f:
			for line in f:
				if FIRSTLINE:
					FIRSTLINE=False
					continue
				line = line.rstrip().split('\t')
				id = str(line[0])
				table[id]={}
				table[id]['sgRNA'] = str(line[0])
				if str(line[0]).startswith('NonTargeting_Human'):
					table[id]['gene'] = 'NonTargeting_Human'
				else:
					table[id]['gene'] = str(line[1])
				for s in sample_ids:
					table[id][s]=0
		print("# construct index and empty table, Done!")
		
		for countF in input.Counts:
			with open(str(countF), 'r+') as f:
				s = os.path.basename(countF).split('_merged')[0]
				for line in f:
					line=line.rstrip().split()
					if line[1]==line[7]:
						if int(line[2])>=int(params.q) or int(line[8])>=int(params.q):
							table[str(line[1])][s] += 1
					else:
						if int(line[2])>=int(params.Q) or int(line[8])>=int(params.Q):
							if int(line[2])>int(line[8]): table[str(line[1])][s] += 1
							else: table[str(line[7])][s] += 1
			print("# loop all read pairs and assign hits of {}, Done!".format(s))

		colnames = ['sgRNA', 'gene'] + sample_ids
		print(','.join(colnames), file=open(str(output), 'a+'))
		for g in table:
			print(','.join(str(table[g][c]) for c in colnames), file=open(str(output), 'a+'))
		print("# output count results for all samples, Done!")


rule merge_technical_replicates:
	input: lambda wildcards: [os.path.join(output_dir,"alignments_filtered/{0}.PEaligns_filtered.tsv".format(technical_id)) \
					for technical_id in config["samples"][wildcards.replicate]]
	output: os.path.join(output_dir,"alignments_filtered/{replicate}_merged_technical_reps.tsv")
	shell:
		"""
		cat {input} > {output}
		"""
