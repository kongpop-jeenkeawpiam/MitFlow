process QUALIMAP_BAMQC {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::qualimap=2.3"
    container "quay.io/biocontainers/qualimap:2.3--hdfd78af_0"

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("${meta.id}_qualimap"), emit: results

    script:
    def avail_mem = 3072
    if (!task.memory) {
        log.info '[QualiMap BamQC] Available memory not known - defaulting to 3GB.'
    } else {
        avail_mem = (task.memory.mega*0.8).intValue()
    }
    """
    qualimap bamqc -bam $bam -nt $task.cpus -outdir ${meta.id}_qualimap -outformat html --java-mem-size=${avail_mem}M
    """
}
