rule generate_reference:
	input: RAW = config['library']	
	output: CONTROL = os.path.join(output_dir,"reference/neg_sgrna_control.txt"),
		REF = os.path.join(output_dir,"reference/ACT_align_reference.fasta")
	threads: 1
	run:
		FIRSTLINE = False
        	with open(str(input.RAW), 'r+') as f:
                	for line in f:
                        	line=line.rstrip().split('\t')
                        	if FIRSTLINE:
                                	FIRSTLINE = False
                                	continue
                       		id = line[0]
                        	if "NonTargeting" in id:
                                	gene = "NonTargeting_Human"
                                	print(id, file=open(str(output.CONTROL), 'a+'))
                        	else:
                                	gene = line[1]
                        	seq = line[2]
                        	print('>'+id, file=open(str(output.REF), 'a+'))
                        	print('NNN'+seq+'NNN', file=open(str(output.REF), 'a+'))


