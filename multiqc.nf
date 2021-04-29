#! /usr/bin/env nextflow
nextflow.enable.dsl=2

process multiqc {

	publishDir params.multiqc, mode: 'copy'

	input:
	path fastqc_output

	script:
	"""
	multiqc -fq -o ${params.multiqc} ${params.outdir}
	"""
}
