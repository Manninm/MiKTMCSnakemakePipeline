rule BallGownTxBoxPlot:
	input:
		"BallGown/transcript_fpkm.txt"
	output:
		"Plots/BoxPlottranscript_fpkm.png"
	shell:
		"""
		cd BallGown/; Rscript ../scripts/TxBoxPlot.R transcript_fpkm.txt
		"""
rule BallGownTxPca:
	input:
		"BallGown/transcript_fpkm.txt"
	output:
		"Plots/PCA1v2&2v3&3v4transcript_fpkm"
	shell:
		"""
		cd BallGown/; Rscript ../scripts/TxPca.R transcript_fpkm.txt
		"""
rule BallGownTxCluster:
	input:
		"BallGown/transcript_fpkm.txt"
	output:
		"Plots/transcript_fpkmWard.D2.{GeneBootStraps}",
		"Plots/transcript_fpkmWard.D.{GeneBootStraps}"
		
	shell:
		"""
		cd BallGown/; Rscript ../scripts/TxCluster.R transcript_fpkm.txt {GeneBootStraps} {HcCores}
		"""