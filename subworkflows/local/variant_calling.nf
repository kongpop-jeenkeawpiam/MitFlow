include { GATK4_MUTECT2 }                  from '../../modules/local/gatk_mutect2'
include { GATK4_FILTERMUTECTCALLS }        from '../../modules/local/gatk_filter_mutect_calls'
include { GATK4_LEFTALIGNANDTRIMVARIANTS } from '../../modules/local/gatk_leftalignandtrimvariants'

workflow VARIANT_CALLING {
    take:
    bam   // channel: [ val(meta), bam, bai ]
    fasta // path: fasta
    fai   // path: fasta.fai
    dict  // path: fasta.dict
    
    main:
    GATK4_MUTECT2 ( bam, fasta, fai, dict )
    
    // Join VCF and Stats for filtering
    vcf_and_stats = GATK4_MUTECT2.out.vcf.join(GATK4_MUTECT2.out.stats)
    
    GATK4_FILTERMUTECTCALLS ( vcf_and_stats, fasta, fai, dict )
    
    GATK4_LEFTALIGNANDTRIMVARIANTS ( GATK4_FILTERMUTECTCALLS.out.vcf, fasta, fai, dict )
    
    emit:
    vcf = GATK4_LEFTALIGNANDTRIMVARIANTS.out.vcf // channel: [ val(meta), vcf.gz, tbi ]
}
