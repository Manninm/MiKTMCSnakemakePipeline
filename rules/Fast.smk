rule fastqc:
	input:
		"{sample}/{sample}.R1.fq.gz",
		"{sample}/{sample}.R2.fq.gz"
	output:
		"{sample}/{sample}.R1_fastqc/Images/duplication_levels.png",
		"{sample}/{sample}.R1_fastqc/Images/per_sequence_gc_content.png",
		"{sample}/{sample}.R1_fastqc/Images/sequence_length_distribution.png",
		"{sample}/{sample}.R1_fastqc/Images/per_base_n_content.png",
		"{sample}/{sample}.R1_fastqc/Images/per_tile_quality.png",
		"{sample}/{sample}.R1_fastqc/Images/kmer_profiles.png",
		"{sample}/{sample}.R1_fastqc/Images/per_base_quality.png",
		"{sample}/{sample}.R1_fastqc/Images/per_base_sequence_content.png",
		"{sample}/{sample}.R1_fastqc/Images/adapter_content.png",
		"{sample}/{sample}.R1_fastqc/Images/per_sequence_quality.png",
		"{sample}/{sample}.R2_fastqc/Images/duplication_levels.png",
		"{sample}/{sample}.R2_fastqc/Images/per_sequence_gc_content.png",
		"{sample}/{sample}.R2_fastqc/Images/sequence_length_distribution.png",
		"{sample}/{sample}.R2_fastqc/Images/per_base_n_content.png",
		"{sample}/{sample}.R2_fastqc/Images/per_tile_quality.png",
		"{sample}/{sample}.R2_fastqc/Images/kmer_profiles.png",
		"{sample}/{sample}.R2_fastqc/Images/per_base_quality.png",
		"{sample}/{sample}.R2_fastqc/Images/per_base_sequence_content.png",
		"{sample}/{sample}.R2_fastqc/Images/adapter_content.png",
		"{sample}/{sample}.R2_fastqc/Images/per_sequence_quality.png"
	threads: 2
	shell:
		"""
		fastqc -t {threads} --extract {input}
		"""
		
rule fastqScreen:
	input:
		Fast1="{sample}/{sample}.R1.fq.gz",
		Fast2="{sample}/{sample}.R2.fq.gz"
	output:
		output1="{sample}/{sample}.fq.gz",
		output2="{sample}/{sample}_screen.png"
	params: 
		outprefix = "{sample}"
	threads: 4
	priority: 3
	shell:
		"""
		cat {input.Fast1} {input.Fast2} > {output.output1} && fastq_screen --quiet --force --threads {threads} {output.output1}
		"""
rule PNGRename:
	input:
		expand("{sample}/{sample}.R1_fastqc/Images/duplication_levels.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/per_sequence_gc_content.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/sequence_length_distribution.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/per_base_n_content.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/per_tile_quality.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/kmer_profiles.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/per_base_quality.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/per_base_sequence_content.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/adapter_content.png", sample=SAMPLES),
		expand("{sample}/{sample}.R1_fastqc/Images/per_sequence_quality.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/duplication_levels.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/per_sequence_gc_content.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/sequence_length_distribution.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/per_base_n_content.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/per_tile_quality.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/kmer_profiles.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/per_base_quality.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/per_base_sequence_content.png",sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/adapter_content.png", sample=SAMPLES),
		expand("{sample}/{sample}.R2_fastqc/Images/per_sequence_quality.png", sample=SAMPLES),
		expand("{sample}/{sample}_screen.png",sample=SAMPLES)
	output:
		output1="QcImages/adapter_content_pngs.pdf",
		output2="QcImages/duplication_levels_pngs.pdf",
		output3="QcImages/kmer_profiles_pngs.pdf",
		output4="QcImages/per_base_quality_pngs.pdf",
		output5="QcImages/per_base_sequence_content_pngs.pdf",
		output6="QcImages/per_sequence_gc_content_pngs.pdf",	
		output7='Screen/screen_pngs.pdf',
	run:
		if not os.path.exists(MainDir+'QcImages'):
			os.mkdir(MainDir+'QcImages')
		imageR1paths=glob.glob(MainDir+'*/*'+'.R1_fastqc/Images/')
		for i in range(len(imageR1paths)):
			files=os.listdir(imageR1paths[i])
			for image in range(len(files)):
				shutil.copyfile(imageR1paths[i]+files[image],MainDir+'QcImages/'+SAMPLES[i]+'.R1_'+files[image])	
		imageR2paths=glob.glob(MainDir+'*/*'+'.R2_fastqc/Images/')
		for i in range(len(imageR2paths)):
			files=os.listdir(imageR2paths[i])
			for image in range(len(files)):
				shutil.copyfile(imageR2paths[i]+files[image],MainDir+'QcImages/'+SAMPLES[i]+'.R2_'+files[image])	
		if not os.path.exists(MainDir+'Screen/'):
			os.mkdir(MainDir+'Screen/')
		for i in range(len(SAMPLES)):
			print(SAMPLES[i]+"/"+SAMPLES[i]+'_screen.png')
			shutil.copyfile(SAMPLES[i]+"/"+SAMPLES[i]+'_screen.png','Screen/'+SAMPLES[i]+'_screen.png')
		shell("cd QcImages/; Rscript ../scripts/RFastQPlot.r && echo 'RFastQPlot.r worked' || echo 'RFastQPlot.r failed'; cd ../Screen/; Rscript ../scripts/RScreenPlot.r  && echo 'RScreenPlotnPlot.r worked' || echo 'RScreenPlot.r failed'; cd ../") 