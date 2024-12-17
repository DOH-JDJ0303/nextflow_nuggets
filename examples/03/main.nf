#!/usr/bin/env Nextflow

workflow {

    // load input
    Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map{ [ it.sample, file(it.assembly) ] }
        .set{ ch_input }

    // Get sequence length using process
    SEQ_LEN (
        ch_input
    )

}

process SEQ_LEN {
    publishDir "${params.outdir}/length/"

    input:
    tuple val(sample), path(seq)

    output:
    tuple val(sample), path("*-length.txt"), emit: length_file

    script:
    """
    seq-len.sh ${seq} ${sample}
    """
}
