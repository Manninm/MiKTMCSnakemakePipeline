import os
import glob
import re
from os.path import join
import argparse
from collections import defaultdict
import fastq2json

#Testing for sequence file extension
directory = "."
MainDir = os.path.abspath(directory) + "/"
EXT = defaultdict(lambda: defaultdict(list))
## build the dictionary with full path for each for sequence files
fastq=glob.glob('./*.fastq.gz')
if len(fastq) > 0 :
    print('Sequence file extensions have fastq')
    os.system('./Move.sh')
    fastq2json.fastq_json(MainDir)
else:
    print('File extensions need to be are good')
    if os.path.exists(MainDir+'samples.json'):
        pass
    else:
        fastq2json.fastq_json(MainDir)
            
shell.prefix("set -eo pipefail; echo BEGIN at $(date); ")
shell.suffix("; exitstat=$?; echo END at $(date); echo exit status was $exitstat; exit $exitstat")

configfile: "config.yaml"

FILES = json.load(open(config['SAMPLES_JSON']))

CLUSTER = json.load(open(config['CLUSTER_JSON']))

SAMPLES = sorted(FILES.keys())

MYGTF = config["MYGTF"]

STARINDEX = config["STARINDEX"]

SortThreads = config['SortThreads']

TARGETS = []

## constructe the target if the inputs are fastqs
if config["from_fastq"]:
	ALL_BAM = expand("{sample}/{sample}Aligned.sortedByCoord.out.bam", sample = SAMPLES)
	TARGETS.extend(ALL_BAM)
	
	if config["htseq"]:
		ALL_CNT = expand("{sample}/{sample}_htseq.cnt", sample = SAMPLES)
		TARGETS.extend(ALL_CNT)
    
if not config["from_fastq"]:
	if config["htseq"]:
		ALL_CNT = expand("{sample}/{sample}_htseq.cnt_htseq.cnt", sample = SAMPLES)
		TARGETS.extend(ALL_CNT)

localrules: all
# localrules will let the rule run locally rather than submitting to cluster
# computing nodes, this is for very small jobs

rule all:
	input: TARGETS

rule STAR_fq:
    input: 
        R1 = "{sample}/{sample}.R1.fq.gz",
        R2 = "{sample}/{sample}.R2.fq.gz",
        index=STARINDEX,
    output: 
        "{sample}/{sample}Aligned.sortedByCoord.out.bam"
    params:
        jobname = "{sample}",
        outprefix = "{sample}/{sample}Aligned.sortedByCoord.out.bam"
    threads:22
	message: "aligning {input} using STAR: {threads} threads"
	shell:
		"""
        STAR --twopassMode Basic --runThreadN {threads} \
        --genomeDir {input.index} --outSAMtype BAM SortedByCoordinate \
        --outBAMcompression 10 --outSAMstrandField intronMotif \
        --outBAMsortingThreadN {SortThreads} \
        --bamRemoveDuplicatesType UniqueIdentical --readFilesCommand gunzip -c --readFilesIn {input.R1} {input.R2} \
        --outFileNamePrefix `echo {params.outprefix}`
		"""

rule HTSeq_fq:
	input: "{sample}/{sample}Aligned.sortedByCoord.out.bam"
	output: "{sample}/{sample}_htseq.cnt"
	log: "00log/{sample}_htseq_count.log"
	params: 
		jobname = "{sample}"
	threads: 1
	message: "htseq-count {input} : {threads} threads"
	shell:
		"""
		source activate root
		htseq-count -m intersection-nonempty --stranded=no --idattr gene_id -r name -f bam {input} {MYGTF} > {output} 2> {log}
		"""

