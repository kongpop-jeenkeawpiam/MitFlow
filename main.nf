#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Print pipeline info
log.info """\
    M I T O G E X   N E X T F L O W   P I P E L I N E
    =================================================
    input        : ${params.input}
    outdir       : ${params.outdir}
    """
    .stripIndent()

workflow {
    // Pipeline implementation will go here
}
