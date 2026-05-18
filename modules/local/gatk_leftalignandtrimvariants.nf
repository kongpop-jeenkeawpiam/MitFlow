process GATK4_LEFTALIGNANDTRIMVARIANTS {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::gatk4=4.6.0.0"
    container "broadinstitute/gatk:4.6.0.0"

    input:
    tuple val(meta), path(vcf), path(tbi)
    path fasta
    path fai
    path dict

    output:
    tuple val(meta), path("*.aligned.vcf.gz"), path("*.aligned.vcf.gz.tbi"), emit: vcf

    script:
    def avail_mem = 3
    if (!task.memory) {
        log.info '[GATK LeftAlignAndTrimVariants] Available memory not known - defaulting to 3GB.'
    } else {
        avail_mem = (task.memory.giga*0.8).intValue()
    }
    """
    gatk --java-options "-Xmx${avail_mem}g" LeftAlignAndTrimVariants \\
        -R $fasta \\
        -V $vcf \\
        -O ${meta.id}.aligned.vcf.gz \\
        --split-multi-allelics \\
        --dont-trim-alleles \\
        --keep-original-ac
    """
}
