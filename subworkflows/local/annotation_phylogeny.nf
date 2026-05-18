include { ANNOVAR }        from '../../modules/local/annovar'
include { QUALIMAP_BAMQC } from '../../modules/local/qualimap_bamqc'
include { HAPLOGREP3 }     from '../../modules/local/haplogrep3'
include { IQTREE2 }        from '../../modules/local/iqtree2'

workflow ANNOTATION_PHYLOGENY {
    take:
    vcf // channel: [ val(meta), vcf.gz, tbi ]
    bam // channel: [ val(meta), bam, bai ]
    annovar_db // path: annovar database dir
    
    main:
    ANNOVAR ( vcf, annovar_db )
    QUALIMAP_BAMQC ( bam )
    HAPLOGREP3 ( vcf )
    
    // Group all FASTA outputs from HaploGrep3 to run IQ-TREE2
    // IQ-TREE2 only runs if there are enough sequences, but the Nextflow process will just run on the aggregated fastas
    HAPLOGREP3.out.fasta
        .map { meta, fasta -> fasta }
        .collect()
        .set { ch_fasta_files }
    
    IQTREE2 ( ch_fasta_files )
}
