#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Include nf-validation plugin features
include { validateParameters; paramsHelp; paramsSummaryLog } from 'plugin/nf-validation'

// Include subworkflows
include { INPUT_CHECK_QC }       from './subworkflows/local/input_check_qc.nf'
include { ALIGNMENT_PICARD }     from './subworkflows/local/alignment_picard.nf'
include { VARIANT_CALLING }      from './subworkflows/local/variant_calling.nf'
include { ANNOTATION_PHYLOGENY } from './subworkflows/local/annotation_phylogeny.nf'
include { REPORTING }            from './subworkflows/local/reporting.nf'

// Print help message if requested
if (params.help) {
    def String command = "nextflow run main.nf --input samplesheet.csv --fasta ref.fa -profile docker"
    log.info paramsHelp(command)
    exit 0
}

// Validate parameters against the schema
validateParameters()

// Print parameter summary
log.info paramsSummaryLog(workflow)

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
                
                if (params.annovar_db) {
                    ANNOTATION_PHYLOGENY(VARIANT_CALLING.out.vcf, ALIGNMENT_PICARD.out.bam, file(params.annovar_db))
                    
                    if (params.web_scripts_dir) {
                        ch_annovar = ANNOTATION_PHYLOGENY.out.txt.map { meta, txt -> txt }.collect()
                        ch_haplogrep = ANNOTATION_PHYLOGENY.out.qc.map { meta, qc -> qc }.collect() // Just to wait for it
                        ch_iqtree = ANNOTATION_PHYLOGENY.out.contree
                        
                        REPORTING(file(params.web_scripts_dir), ch_annovar, ch_haplogrep, ch_iqtree)
                    }
                }
            }
        }
    } else {
        log.error "Please provide an input with --input"
        exit 1
    }
}
