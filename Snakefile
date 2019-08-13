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
	ALL_STRING = expand("{sample}/{sample}_onlyKnown.gtf",sample=SAMPLES)
	TARGETS.extend(ALL_STARLOG)
	TARGETS.extend(ALL_BAM)
	TARGETS.extend(ALL_STRING)

    
	#if config["htseq"]:
	#	ALL_CNT = expand("{sample}/{sample}_htseq.cnt", sample = SAMPLES)
	#	TARGETS.extend(ALL_CNT)


localrules: all
# localrules will let the rule run locally rather than submitting to cluster
# computing nodes, this is for very small jobs

rule all:
	input: 
		TARGETS,
			'Reports/averageMappedLength.txt',
			'Reports/input.txt',
			'Reports/mappedPercent.txt',
			'Reports/percentMultimappers.txt',
			'Reports/unmappedTooShort.txt',
			"QcImages/adapter_content_pngs.pdf",
			"QcImages/duplication_levels_pngs.pdf",
			"QcImages/kmer_profiles_pngs.pdf",
			"QcImages/per_base_quality_pngs.pdf",
			"QcImages/per_base_sequence_content_pngs.pdf",
			"QcImages/per_sequence_gc_content_pngs.pdf",	
			'Screen/screen_pngs.pdf',
			"Reports/picard_classifications.txt",
			"HtSeqCounts/CountsGt0.txt",
			"HtSeqCounts/allCounts.txt",
			"HtSeqCounts/CountsGt0_voom.txt",
			"HtSeqCounts/CountsGt0_voom_filtered.txt",
			"BallGown/gene_expression_table.txt",
			"BallGown/transcript_fpkm.txt",
			"BallGown/transcript_cov.txt",
			"BallGown/whole_tx_table.txt",
			"BallGown/filt_gene_expression_table.txt",
			"BallGown/filt_transcript_fpkm.txt",
			"BallGown/filt_transcript_cov.txt",
			"BallGown/filt_whole_tx_table.txt",

#		"""
 
#Load rules for modularity

include: "rules/Star_Map.smk"
include: "rules/Fast.smk"
include: "rules/Picard.smk"
include: "rules/HtSeq.smk"
include: "rules/Reports.smk"
include: "rules/StringTie.smk"
include: "rules/BallGown.smk"
#if config["Plots"]:
	#include: "rules/Cluster.smk"
