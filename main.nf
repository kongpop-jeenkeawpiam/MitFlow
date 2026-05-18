#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Include subworkflows
include { INPUT_CHECK_QC }   from './subworkflows/local/input_check_qc.nf'
include { ALIGNMENT_PICARD } from './subworkflows/local/alignment_picard.nf'
include { VARIANT_CALLING }  from './subworkflows/local/variant_calling.nf'

// Print pipeline info
log.info """\
    M I T O G E X   N E X T F L O W   P I P E L I N E
    =================================================
    input        : ${params.input}
    outdir       : ${params.outdir}
    """
    .stripIndent()

workflow {
    if (params.input) {
        ch_input = Channel.fromFilePairs(params.input, checkIfExists: true)
            .map { id, reads -> 
                def meta = [:]
                meta.id = id
                [meta, reads]
            }
        
        INPUT_CHECK_QC(ch_input)
        
        // Ensure params.fasta and params.bwa_index are provided for this step
        if (params.fasta && params.bwa_index) {
            ALIGNMENT_PICARD(INPUT_CHECK_QC.out.reads, file(params.fasta), file(params.bwa_index))
            
            if (params.fai && params.dict) {
                VARIANT_CALLING(ALIGNMENT_PICARD.out.bam, file(params.fasta), file(params.fai), file(params.dict))
            }
        }
    } else {
        log.error "Please provide an input with --input"
        exit 1
    }
}
