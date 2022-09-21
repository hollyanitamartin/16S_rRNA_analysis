#! /usr/bin/env nextflow
nextflow.enable.dsl=2

process fastp_test {

	publishDir params.trimmed, mode: 'copy'
	params.data = "./data/*.fastq.gz"
	fastqs = Channel
		.fromPath(params.data)
		.flatten()
	sample_id = Channel
		.fromFilePairs("${params.rawdir}/*_L001_R{1,2}_001.fastq.gz")
		.flatten()
		.view()
 	r1 = Channel
		.fromPath("${params.rawdir}/*_L001_R1_001.fastq.gz")
	r2 = Channel
		.fromPath("${params.rawdir}/*_L001_R2_001.fastq.gz")

	input:
	val(sample_id)

	output:
	path(fastqs), emit: trim_reads

	script:
  """
	R1=\$(basename $r1)
	R2=\$(basename $r2)
	fastp \
  	--thread ${params.threads} \
  	-i "${params.rawdir}/\${R1}" \
  	-o "${params.trimmed}/\${R1%.fastq.gz}_trim.fastq.gz " \
  	-I "${params.rawdir}/\${R2}" \
  	-O "${params.trimmed}/\${R2%.fastq.gz}_trim.fastq.gz" \
  	--unpaired1 "!{params.trimmed}/\${R1%.fastq.gz}.orphans.fastq.gz" \
 	 --unpaired2 "!{params.trimmed}/\${R2%.fastq.gz}.orphans.fastq.gz" \
  	--cut_right --cut_window_size 4 --cut_mean_quality 20 --length_required 50
 """
}
