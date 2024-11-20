#!/usr/bin/env Nextflow

nextflow.enable.dsl = 2

workflow {
    Channel.fromPath(params.input)
        .splitCsv(header: true)
        .set{ ch_input }

    ch_input
        .filter{ it.Legendary == "True" }
        .view()

    ch_input
        .map{ fix_bool(it) }
        .set{ ch_fixed }

    ch_fixed
        .map{ it.keySet().join(',') }
        .first()
        .concat(ch_fixed.map{ it.values().join(',') })
        .collectFile(name: "fixed.csv", newLine: true, sort: 'index')
        .subscribe{ file(it).copyTo(file(params.outdir).resolve("fixed.csv")) }
    
}

def fix_bool(LinkedHashMap row){
    def result = [ name: row.Name, legendary: row.Legendary == "True" ? true : false ]
    return result
}


