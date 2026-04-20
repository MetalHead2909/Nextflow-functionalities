process SPADES {

    tag "${meta.id}"

    conda "bioconda::spades=3.15.5 conda-forge::python=3.9"

    publishDir "${params.outdir}/spades/${meta.id}", mode: 'copy'

    input:
    tuple val(meta), path(reads_1), path(reads_2)

    output:
    path "${meta.id}_spades"

    script:
    def reads = meta.single_end \
        ? "-s ${reads_1}" \
        : "-1 ${reads_1} -2 ${reads_2}"

    """
    spades.py \
        ${reads} \
        -t ${task.cpus} \
        -o ${meta.id}_spades
    """
}
