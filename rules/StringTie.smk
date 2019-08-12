rule String_Tie:
	input:
		"{sample}/{sample}Aligned.sortedByCoord.out.bam"
	output:
		"{sample}/{sample}_onlyKnown.gtf"

	shell:
		"""
		stringtie -p 24 -eB -G {MYGTF} -o {output} {input}
		"""
