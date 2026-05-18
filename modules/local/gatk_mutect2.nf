process GATK4_MUTECT2 {
    tag "$meta.id"
    label 'process_high'

    conda "bioconda::gatk4=4.6.0.0"
    container "broadinstitute/gatk:4.6.0.0"

    input:
    tuple val(meta), path(bam), path(bai)
    path fasta
    path fai
    path dict

    output:
    tuple val(meta), path("*.vcf.gz"), path("*.tbi"), emit: vcf
    tuple val(meta), path("*.stats")                , emit: stats

    script:
    def avail_mem = 3
    if (!task.memory) {
        log.info '[GATK Mutect2] Available memory not known - defaulting to 3GB. Specify process memory requirements to change this.'
    } else {
        avail_mem = (task.memory.giga*0.8).intValue()
    }
    """
    gatk --java-options "-Xmx${avail_mem}g" Mutect2 \\
        -R $fasta \\
        -I $bam \\
        -O ${meta.id}.vcf.gz \\
        --mitochondria-mode true
    """
}
