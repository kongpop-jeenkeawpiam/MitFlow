process SAMTOOLS_VIEW {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::samtools=1.17"
    container "quay.io/biocontainers/samtools:1.17--h00cdaf9_0"

    input:
    tuple val(meta), path(sam)

    output:
    tuple val(meta), path("*.bam"), emit: bam

    script:
    """
    samtools view -@ $task.cpus -bS $sam > ${meta.id}.bam
    """
}
