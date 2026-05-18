include { FASTQC } from '../../modules/local/fastqc'
include { FASTP  } from '../../modules/local/fastp'

workflow INPUT_CHECK_QC {
    take:
    reads // queue channel: [ val(meta), [ reads ] ]
    
    main:
    // Run FASTQC
    FASTQC ( reads )
    
    // Run FASTP
    FASTP ( reads )
    
    emit:
    reads = FASTP.out.reads // channel: [ val(meta), [ fastp_reads ] ]
    fastqc_html = FASTQC.out.html
    fastqc_zip  = FASTQC.out.zip
    fastp_html  = FASTP.out.html
    fastp_json  = FASTP.out.json
}
