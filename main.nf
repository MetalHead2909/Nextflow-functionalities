#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Importing modules

include { FASTQC            } from './modules/fastqc'
include { TRIMMOMATIC       } from './modules/trim'
include { SPADES }       from './modules/spades'
include { SEQKIT_STATS } from './modules/seqkit'

workflow {

	log.info """
        Genomics Pipeline
        =======================
        samplesheet : ${params.samplesheet}
        genome      : ${params.genome}
        outdir      : ${params.outdir}
    """.stripIndent()

	ch_reads = Channel
        .fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map { row ->
            def meta = [
                id         : row.sample,
                condition  : row.condition,
                single_end : row.single_end.toBoolean()
            ]
            def fastq_1 = file(row.fastq_1)
            def fastq_2 = row.single_end.toBoolean() ? [] : file(row.fastq_2)
            return [ meta, fastq_1, fastq_2 ]
        }

	ch_reads.view { meta, r1, r2 -> "LOADED: ${meta.id} | ${meta.condition} | SE:${meta.single_end}" }

	// FastQC
	FASTQC(ch_reads)

	// Trimmomatic
	ch_trimmed = TRIMMOMATIC(ch_reads)

  ch_trimmed.subscribe { println "TRIM OUTPUT: $it" }
	// SeqKit stats (parallel)
        SEQKIT_STATS(ch_trimmed)

        // SPAdes assembly (parallel)
    	SPADES(ch_trimmed)	
}
