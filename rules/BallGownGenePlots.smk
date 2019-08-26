rule BallGownGeneBoxPlot:
	input:
		"BallGown/filt_gene_expression_table.txt"
	output:
		"Plots/BoxPlotfilt_gene_expression_table.png"
	shell:
		"""
		cd BallGown/; Rscript ../scripts/GeneBoxPlot.R filt_gene_expression_table.txt
		"""
rule BallGownGenePca:
	input:
		"BallGown/filt_gene_expression_table.txt"
	output:
		"Plots/PCA1v2&2v3&3v4filt_gene_expression_table"
	shell:
		"""
		cd BallGown/; Rscript ../scripts/GenePca.R filt_gene_expression_table
		"""
rule BallGownGeneCluster:
	input:
		"BallGown/filt_gene_expression_table.txt"
	output:
		"Plots/filt_gene_expression_tableWard.D.{GeneBootStraps}",
		"Plots/filt_gene_expression_tableWard.D2.{GeneBootStraps}"
		
	shell:
		"""
		cd BallGown/; Rscript ../scripts/GeneCluster.R filt_gene_expression_table.txt {GeneBootStraps} {HcCores}
		"""