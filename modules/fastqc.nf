process FASTQC {
	tag "${meta.id}"

	conda "bioconda::fastqc=0.12.1"

  publishDir "${params.outdir}/fastqc/${meta.id}", mode: 'copy' 

	input:
    	tuple val(meta), path(r1), path(r2)
	
	output:
    	tuple val(meta), path("*.zip"),  emit: zip
    	tuple val(meta), path("*.html"), emit: html
	
	script:
    	"""
    	fastqc --threads ${task.cpus} ${r1} ${r2}
    	"""
}
