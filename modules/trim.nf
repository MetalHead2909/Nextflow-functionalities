process TRIMMOMATIC {
	
	tag "${meta.id}"
	
	conda "bioconda::trimmomatic=0.39"
	
	publishDir "${params.outdir}/trimmomatic/${meta.id}", mode: 'copy'

	input:
    	tuple val(meta), path(r1), path(r2)
	
	output:
	tuple val(meta),
          path("${meta.id}_R1_trimmed.fastq.gz"),
          path("${meta.id}_R2_trimmed.fastq.gz")
	
	script:
	def prefix = meta.id
	def adapter = params.adapter_seq ?: "AGATCGGAAGAGC"
	"""
    echo "[TRIM] Starting Trimmomatic for ${prefix}" >&2

    trimmomatic PE \\
        -threads 4 \\
        -phred33 \\
        ${r1} ${r2} \\
        ${prefix}_R1_trimmed.fastq.gz \\
        ${prefix}_unpaired_R1.fastq.gz \\
        ${prefix}_R2_trimmed.fastq.gz \\
        ${prefix}_unpaired_R2.fastq.gz \\
        ILLUMINACLIP:${adapter}:2:30:10:2:keepBothReads \\
        LEADING:3 \\
        TRAILING:3 \\
        SLIDINGWINDOW:4:15 \\
        MINLEN:36 \\
        2> ${prefix}_trimmomatic.log

    echo "[TRIM] Done. Log written to ${prefix}_trimmomatic.log" >&2
    """
}
