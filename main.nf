#! /usr/bin/env nextflow
nextflow.enable.dsl=2

log.info """\
			Amplicon Sequencing Workflow
			============================

			reads:		${params.reads}
			outdir:		${params.outdir}
			threads:	${params.threads}
			multiqc:	${params.multiqc}
			baseDir:	${baseDir}
			"""
			.stripIndent()

params.data = "./data/*.fastq.gz"
rawdata = Channel.fromPath(params.data)

include { fastqc } from './fastqc.nf'
include { multiqc } from './multiqc.nf'

workflow {
	fastqc(rawdata)
	multiqc(fastqc.out)
}
