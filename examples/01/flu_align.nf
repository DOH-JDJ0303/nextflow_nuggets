#!/usr/bin/env Nextflow

def input_file = params.input

workflow {

    // load input
    Channel
        .fromPath(input_file)
        .splitCsv(header: true)
        .map{ [ it.sample, file(it.assembly) ] }
        .set{ ch_input }

    // // Get sequence length using process
    // SEQ_LEN (
    //     ch_input
    // )

    // // // Different outputs
    // SEQ_LEN
    //     .out
    //     .length_file
    //     .subscribe{ sample, result -> println "path: ${sample}\t${result}" }

    // SEQ_LEN
    //     .out
    //     .length_env
    //     .subscribe{ sample, result -> println "env: ${sample}\t${result}" }
    
    // // Get sequence length using Groovy
    // ch_input
    //     .splitFasta(elem: 1, decompress: true, record: [id: true, seqString: true])
    //     .map{ sample, line -> [ sample, line.seqString.length() ] }
    //     .set{ ch_length_groovy }

    // // // Compare output
    // // SEQ_LEN
    // //     .out
    // //     .length_env
    // //     .join(ch_length_groovy, by: 0)
    // //     .subscribe{ sample, length_process, length_groovy ->
    // //                 println "Sample: ${sample}\tProcess Length: ${length_process}\tGroovy Length: ${length_groovy}"  
    // //               }

    // // Align all seuqences
    // SEQ_ALIGN (
    //     ch_input.map{ sample, assembly -> assembly }.collect()
    // )

    // SEQ_ALIGN.out.alignment.view()
}

process SEQ_LEN {
    publishDir "${params.outdir}/length/"

    input:
    tuple val(sample), path(seq)

    output:
    tuple val(sample), path("*-length.txt"), emit: length_file
    tuple val(sample), env(len), emit: length_env

    script:
    """
    # get sequence length and save to text file
    zcat ${seq} | grep -v '>' | tr -d '\n\r\t ' | wc -c | tr -d '\n' > ${sample}-length.txt
    # get sequence length and save to variable
    len=\$(zcat ${seq} | grep -v '>' | tr -d '\n\r\t ' | wc -c)
    """
}

process SEQ_ALIGN {
    container "docker.io/staphb/mafft:latest"
    publishDir "${params.outdir}/alignment/"

    input:
    path sequences

    output:
    path "alignment.fa", emit: alignment

    script:
    """
    # combine all sequences
    zcat ${sequences} > seqs.fa
    # align sequences
    mafft --auto seqs.fa > alignment.fa
    """
}