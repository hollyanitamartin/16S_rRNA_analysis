#! /usr/bin/env nextflow
nextflow.enable.dsl=2

process fastqc {

	publishDir params.outdir, mode: 'copy'

	input:
	path rawdata

	output:
	path "*.{zip,html}", emit: fastqc_output

	script:
	"""
	fastqc -t ${params.threads} ${rawdata}
	"""
}
