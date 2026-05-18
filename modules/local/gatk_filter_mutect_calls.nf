process GATK4_FILTERMUTECTCALLS {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::gatk4=4.6.0.0"
    container "broadinstitute/gatk:4.6.0.0"

    input:
    tuple val(meta), path(vcf), path(tbi), path(stats)
    path fasta
    path fai
    path dict

    output:
    tuple val(meta), path("*.filtered.vcf.gz"), path("*.filtered.vcf.gz.tbi"), emit: vcf

    script:
    def avail_mem = 3
    if (!task.memory) {
        log.info '[GATK FilterMutectCalls] Available memory not known - defaulting to 3GB.'
    } else {
        avail_mem = (task.memory.giga*0.8).intValue()
    }
    """
    gatk --java-options "-Xmx${avail_mem}g" FilterMutectCalls \\
        -R $fasta \\
        -V $vcf \\
        -O ${meta.id}.filtered.vcf.gz \\
        --stats $stats \\
        --mitochondria-mode true
    """
}
