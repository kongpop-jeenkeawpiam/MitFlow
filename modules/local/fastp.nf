process FASTP {
    tag "$meta.id"
    label 'process_medium'
    
    conda "bioconda::fastp=0.23.4"
    container "quay.io/biocontainers/fastp:0.23.4--h5f740d0_0"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.fastp.fastq.gz") , emit: reads
    tuple val(meta), path("*.json")           , emit: json
    tuple val(meta), path("*.html")           , emit: html
    
    script:
    """
    fastp -i ${reads[0]} -I ${reads[1]} -o ${meta.id}_1.fastp.fastq.gz -O ${meta.id}_2.fastp.fastq.gz -w $task.cpus --json ${meta.id}.fastp.json --html ${meta.id}.fastp.html
    """
}
