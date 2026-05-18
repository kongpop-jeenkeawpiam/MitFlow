include { BWA_MEM }                       from '../../modules/local/bwa_mem'
include { SAMTOOLS_VIEW }                 from '../../modules/local/samtools_view'
include { PICARD_ADDORREPLACEREADGROUPS } from '../../modules/local/picard_addorreplacereadgroups'

workflow ALIGNMENT_PICARD {
    take:
    reads // channel: [ val(meta), [ reads ] ]
    fasta // path: fasta
    bwa_index // path: bwa index dir or files
    
    main:
    BWA_MEM ( reads, fasta, bwa_index )
    SAMTOOLS_VIEW ( BWA_MEM.out.sam )
    PICARD_ADDORREPLACEREADGROUPS ( SAMTOOLS_VIEW.out.bam )
    
    emit:
    bam = PICARD_ADDORREPLACEREADGROUPS.out.bam // channel: [ val(meta), bam, bai ]
}
