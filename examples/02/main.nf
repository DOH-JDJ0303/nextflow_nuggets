#!/usr/bin/env Nextflow

nextflow.enable.dsl = 2

workflow {
    Channel.fromPath(params.input)
        .splitCsv(header: true)
        .set{ ch_input }

    // ch_input
    //     .filter{ it.Legendary == "True" }
    //     .view()

    // ch_input
    //     .map{ fix_bool(it) }
    //     .set{ ch_fixed }

    // // Branch
    // ch_fixed
    //     .filter{ it.legendary }
    //     .set{ ch_legendary }
    // ch_fixed
    //     .filter{ ! it.legendary }
    //     .set{ ch_not_legendary }

    // ch_fixed
    //     .branch{ it ->
    //         legendary: it.legendary
    //         not_legendary: ! it.legendary
    //         }
    //     .set{ ch_branch }
    // ch_branch.legendary.view()
    // ch_branch.not_legendary.view()

    // // Buffer vs Collate
    // ch_input.buffer(size: 10).view()
    // ch_input.collate(10).view()

    // // Join vs Combine
    ch_input.map{ [ it.Name, it."Type 1", it."Type 2" ] }.take(10).set{ ch_name }
    ch_input.map{ [ it."Type 1", it.HP, it."Type 2" ] }.take(20).unique().set{ ch_stats }
    
    // ch_name.map{ name, type1, type2 -> [ type1, name, type2 ] }.join(ch_stats, by: [0,2], remainder: true).view()
    // ch_name.map{ name, type1, type2 -> [ type1, name, type2 ] }.combine(ch_stats, by: [0,2]).view()
    // ch_name.map{ name, type1, type2 -> [ type1, name, type2 ] }.combine(ch_stats.groupTuple(by: [0,2]), by: [0,2]).view()    

    // // Transpose
    // ch_name
    //     .map{ name, type1, type2 -> [ type1, name, type2 ] }
    //     .combine(ch_stats.groupTuple(by: [0,2]), by: [0,2])
    //     .transpose()
    //     .view()

    
    // // Flatten
    // ch_name
    //     .map{ name, type1, type2 -> [ type1, name, type2 ] }
    //     .combine(ch_stats.groupTuple(by: [0,2]), by: [0,2])
    //     .flatten()
    //     .view()

    // Collect
    // ch_input
    //     .map{ [ it.Name ] }
    //     .view()
    // ch_input
    //     .map{ [ it.Name ] }
    //     .collect()
    //     .view()

    // Collect
    ch_input
        .map{ [ it.Name ] }
        .dump(tag: 'nextflow_nuggets', pretty: true)
}

def fix_bool(LinkedHashMap row){
    def result = [ name: row.Name, legendary: row.Legendary == "True" ? true : false ]
    return result
}


