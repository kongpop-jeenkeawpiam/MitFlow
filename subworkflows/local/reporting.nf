include { MITOGEX_REPORT } from '../../modules/local/mitogex_report'

workflow REPORTING {
    take:
    web_scripts_dir
    annovar_outputs
    haplogrep_outputs
    phylogenetic_outputs
    
    main:
    MITOGEX_REPORT(web_scripts_dir, annovar_outputs, haplogrep_outputs, phylogenetic_outputs)
    
    emit:
    html = MITOGEX_REPORT.out.html_reports
}
