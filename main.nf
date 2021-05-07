#! /usr/bin/env nextflow
nextflow.enable.dsl=2

log.info """\

			Amplicon Sequencing Workflow
			============================
			baseDir:	${baseDir}
			reads:		${params.reads}
			outdir:		${params.outdir}
			multiqc:	${params.multiqc}
			threads:	${params.threads}

			"""
			.stripIndent()


//include { fastqc } from './fastqc.nf'
//include { multiqc } from './multiqc.nf'
include { fastp_test } from "${baseDir}/fastp_test.nf"

workflow {
	//fastqc(rawdata)
	//multiqc(fastqc.out)
	params.data = "./data/*.fastq.gz"
	fastqs = Channel
								.fromPath(params.data)
								.flatten()
	sample_id = Channel
										.fromFilePairs("${params.data}/*_L001_R{1,2}_001.fastq.gz")
										.flatten()
										.view()
	r1 = Channel
							.fromPath("${params.data}/*_L001_R1_001.fastq.gz")
	r2 = Channel
							.fromPath("${params.data}/*_L001_R2_001.fastq.gz")
	fastp_test(sample_id)
}
