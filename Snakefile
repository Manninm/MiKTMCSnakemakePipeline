import os
import glob
import re
from os.path import join
import argparse
from collections import defaultdict
import fastq2json
from itertools import chain, combinations
import shutil
from shutil import copyfile
#Testing for sequence file extension
directory = "."
MainDir = os.path.abspath(directory) + "/"
## build the dictionary with full path for each for sequence files
fastq=glob.glob(MainDir+'*/*'+'R[12]'+'**fastq.gz')
if len(fastq) > 0 :
    print('Sequence file extensions have fastq')
    os.system('scripts/Move.sh')
    fastq2json.fastq_json(MainDir)
else:
    print('File extensions  are good')
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
    ALL_STARLOG = expand("{sample}/{sample}Log.final.out", sample = SAMPLES)
    TARGETS.extend(ALL_STARLOG)
    TARGETS.extend(ALL_BAM)
    print(TARGETS)
    
	#if config["htseq"]:
	#	ALL_CNT = expand("{sample}/{sample}_htseq.cnt", sample = SAMPLES)
	#	TARGETS.extend(ALL_CNT)
    
if not config["from_fastq"]:
	if config["htseq"]:
		ALL_CNT = expand("{sample}/{sample}_htseq.cnt_htseq.cnt", sample = SAMPLES)
		TARGETS.extend(ALL_CNT)

localrules: all
# localrules will let the rule run locally rather than submitting to cluster
# computing nodes, this is for very small jobs

rule all:
    input: 
        TARGETS,
        'averageMappedLength.txt',
        'input.txt',
        'mappedPercent.txt',
        'percentMultimappers.txt',
        'unmappedTooShort.txt',
		    "QcImages/adapter_content_pngs.pdf",
		    "QcImages/duplication_levels_pngs.pdf",
		    "QcImages/kmer_profiles_pngs.pdf",
		    "QcImages/per_base_quality_pngs.pdf",
		    "QcImages/per_base_sequence_content_pngs.pdf",
		    "QcImages/per_sequence_gc_content_pngs.pdf",	
		    'Screen/screen_pngs.pdf',
#rule HTSeq_fq:
#	input: "{sample}/{sample}Aligned.sortedByCoord.out.bam"
#	output: "{sample}/{sample}_htseq.cnt"
#	log: "00log/{sample}_htseq_count.log"
#	params: 
#		jobname = "{sample}"
#	threads: 1
#	message: "htseq-count {input} : {threads} threads"
#	shell:
#		"""
#		source activate root
#		htseq-count -m intersection-nonempty --stranded=no --idattr gene_id -r name -f bam {input} {MYGTF} > {output} 2> {log}
#		"""
 
#Load rules for modularity

include: "rules/Star_Map.smk"
include: "rules/Fast.smk"
