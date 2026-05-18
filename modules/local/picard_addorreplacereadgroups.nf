process PICARD_ADDORREPLACEREADGROUPS {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::picard=3.0.0"
    container "quay.io/biocontainers/picard:3.0.0--hdfd78af_1"

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("*.sort.bam"), path("*.sort.bam.bai"), emit: bam

    script:
    def avail_mem = 3072
    if (!task.memory) {
        log.info '[Picard AddOrReplaceReadGroups] Available memory not known - defaulting to 3GB. Specify process memory requirements to change this.'
    } else {
        avail_mem = (task.memory.mega*0.8).intValue()
    }
    """
    picard -Xmx${avail_mem}M AddOrReplaceReadGroups \\
        I=$bam \\
        O=${meta.id}.sort.bam \\
        SORT_ORDER=coordinate \\
        RGID=${params.project_title} \\
        RGLB=lib-${meta.id} \\
        RGPL=illumina \\
        RGPU=HiSeq \\
        RGSM=${meta.id} \\
        CREATE_INDEX=true
    """
}
