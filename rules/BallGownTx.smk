rule BallGownTxBoxPlot:
	input:
		"BallGown/transcript_fpkm.txt"
	output:
		"Plots/transcript_fpkmBoxPlot.png"
	shell:
		"""
		cd BallGown/; Rscript ../scripts/TxBoxPlot.R transcript_fpkm.txt
		"""
rule BallGownTxPca:
	input:
		"BallGown/transcript_fpkm.txt"
	output:
		"Plots/transcript_fpkmPCA1v2&2v3&3v4.pdf"
	shell:
		"""
		cd BallGown/; Rscript ../scripts/TxPca.R transcript_fpkm.txt
		"""
rule BallGownTxCluster:
	input:
		"BallGown/transcript_fpkm.txt"
	output:
		"Plots/transcript_fpkm.Ward.D2.{TxBootStraps}.pdf",
		"Plots/transcript_fpkm.Ward.D.{TxBootStraps}.pdf"
		
	shell:
		"""
		cd BallGown/; Rscript ../scripts/TxCluster.R transcript_fpkm.txt {HcCores} {TxBootStraps} 
		"""