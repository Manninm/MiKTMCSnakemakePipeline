if not config["GroupdFile"]:
	print("No Group File provided!")
	os.system('scripts/Table.R')
rule Ball_Gown:
	input:
		expand("{sample}/{sample}_onlyKnown.gtf",sample=SAMPLES)
	output:
		"BallGown/gene_expression_table.txt",
		"BallGown/transcript_fpkm.txt",
		"BallGown/transcript_cov.txt",
		"BallGown/whole_tx_table.txt",
		"BallGown/filt_gene_expression_table.txt",
		"BallGown/filt_transcript_fpkm.txt",
		"BallGown/filt_transcript_cov.txt",
		"BallGown/filt_whole_tx_table.txt",
	shell:
		"""
		Rscript scripts/BallGown.R
		"""