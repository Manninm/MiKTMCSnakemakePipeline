rule STAR_fq:
    input: 
        R1 = "{sample}/{sample}.R1.fq.gz",
        R2 = "{sample}/{sample}.R2.fq.gz",
        index=STARINDEX,
    output: 
        "{sample}/{sample}Aligned.sortedByCoord.out.bam"
        '{sample}/{sample}Log.final.out'
    params:
        jobname = "{sample}",
        outprefix = "{sample}/{sample}"
    threads:20
	message: "aligning {input} using STAR: {threads} threads"
	shell:
		"""
        STAR --twopassMode Basic --runThreadN {threads} \
        --genomeDir {input.index} --outSAMtype BAM SortedByCoordinate \
        --outBAMcompression 10 --outSAMstrandField intronMotif \
        --outBAMsortingThreadN {SortThreads} \
        --bamRemoveDuplicatesType UniqueIdentical --readFilesCommand gunzip -c --readFilesIn {input.R1} {input.R2} \
        --outFileNamePrefix {params.outprefix}
		"""

rule StarCollect:
    input:
        input=expand('{sample}/{sample}Log.final.out',sample=SAMPLES)
    output:	
        'averageMappedLength.txt',
        'input.txt',
        'mappedPercent.txt',
        'percentMultimappers.txt',
        'unmappedTooShort.txt'
    shell:
        """
		for i in $( find . -maxdepth 2 -name "*Log.final.out" ); do echo $i >> input.txt; cat $i | grep "Number of input reads" >> input.txt; done;
		for i in $( find . -maxdepth 2 -name "*Log.final.out" ); do echo $i >> averageMappedLength.txt; cat $i | grep "Average mapped length" >> averageMappedLength.txt; done;
		for i in $( find . -maxdepth 2 -name "*Log.final.out" ); do echo $i >> percentMultimappers.txt; cat $i | grep "% of reads
		mapped to multiple loci" >> percentMultimappers.txt; done;
		for i in $( find . -maxdepth 2 -name "*Log.final.out" ); do echo $i >> unmappedTooShort.txt; cat $i | grep " % of reads
		unmapped: too short" >> unmappedTooShort.txt; done
		for i in $( find . -maxdepth 2 -name "*Log.final.out" ); do echo $i >> mappedPercent.txt; cat $i | grep "Uniquely mapped
		reads %" >> mappedPercent.txt; done
		"""