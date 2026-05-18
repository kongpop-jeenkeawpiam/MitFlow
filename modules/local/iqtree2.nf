process IQTREE2 {
    label 'process_high'

    conda "bioconda::iqtree=2.2.6"
    container "quay.io/biocontainers/iqtree:2.2.6--h21ec9f0_0"

    input:
    path fasta_files

    output:
    path "${params.project_title}.fasta.contree", emit: contree
    path "${params.project_title}.fasta.*"      , emit: all_files

    script:
    """
    cat $fasta_files > ${params.project_title}.fasta
    iqtree2 -s ${params.project_title}.fasta -m MFP -B 1000 -T AUTO
    """
}
