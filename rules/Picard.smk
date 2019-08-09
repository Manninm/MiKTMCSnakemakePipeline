rule Picard:
	input:
		"{sample}/{sample}Aligned.sortedByCoord.out.bam"
	output:
		"{sample}/{sample}picardresults.txt"
	shell:
		"""
		java -jar /opt/programs/picardtools/2.9/picard.jar CollectRnaSeqMetrics REF_FLAT=/opt/programs/picardtools/refFlat.txt STRAND_SPECIFICITY=FIRST_READ_TRANSCRIPTION_STRAND CHART_OUTPUT=./coverage.pdf INPUT={input} OUTPUT={output}
		"""
rule PicardGather:
	input:
		expand("{sample}/{sample}picardresults.txt",sample=SAMPLES)
	output:
		"Reports/picard_classifications.txt"
	shell:
		"""
		for i in $( find . -maxdepth 2 -wholename "*picardresults.txt" -type f ); do echo $i >> Reports/picard_classifications.txt; head -n 8 $i |tail -n 2 >> picard_classifications.txt; done
		"""