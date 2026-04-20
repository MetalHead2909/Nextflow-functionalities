process SEQKIT_STATS {

    tag "${meta.id}"

    conda "bioconda::seqkit=2.6.1 conda-forge::python=3.9"

    publishDir "${params.outdir}/seqkit/${meta.id}", mode: 'copy'

    input:
    tuple val(meta), path(reads_1), path(reads_2)

    output:
    path "${meta.id}_seqkit.txt"

    script:
    def inputs = meta.single_end \
        ? "${reads_1}" \
        : "${reads_1} ${reads_2}"

    """
    seqkit stats ${inputs} > ${meta.id}_seqkit.txt
    """
}
