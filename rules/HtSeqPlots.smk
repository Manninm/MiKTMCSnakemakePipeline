rule HtSeqBoxPlot:
	input:
		"HtSeqCounts/CountsGt0_voom.txt"
	output:
		"Plots/BoxPlotHtSeqVoomGt0.png"
	shell:
		"""
		cd HtSeqCounts/; Rscript ../scripts/GeneBoxPlot.R CountsGt0_voom.txt
		"""
rule HtSeqPca:
	input:
		"HtSeqCounts/CountsGt0_voom_filtered.txt"
	output:
		"Plots/PCA1v2&2v3&3v4CountsGt0_voom_filtered"
	shell:
		"""
		cd HtSeqCounts/; Rscript ../scripts/GenePca.R CountsGt0_voom_filtered.txt
		"""
rule HtSeqCluster:
	input:
		"HtSeqCounts/CountsGt0_voom_filtered.txt"
	output:
		"Plots/Gt0_voom_filteredWard.D.{GeneBootStraps}",
		"Plots/Gt0_voom_filteredWard.D2.{GeneBootStraps}"
		
	shell:
		"""
		cd HtSeqCounts/; Rscript ../scripts/GeneCluster.R CountsGt0_voom_filtered.txt {GeneBootStraps} {HcCores}
		"""