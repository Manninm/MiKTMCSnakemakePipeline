rule Picard:
	input:
		"{sample}/{sample}Aligned.sortedByCoord.out.bam"
	output:
		"{sample}/{sample}picardresults.txt"
	params:
		outprefix = "{sample}/{sample}"
	shell:
		"""
		java -jar /opt/programs/picardtools/2.9/picard.jar CollectRnaSeqMetrics REF_FLAT=/opt/programs/picardtools/refFlat.txt STRAND_SPECIFICITY=FIRST_READ_TRANSCRIPTION_STRAND CHART_OUTPUT={params.outprefix}coverage.pdf INPUT={input} OUTPUT={output}
		"""
