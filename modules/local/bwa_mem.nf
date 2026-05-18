process BWA_MEM {
    tag "$meta.id"
    label 'process_high'

    conda "bioconda::bwa=0.7.17"
    container "quay.io/biocontainers/bwa:0.7.17--h5bf99c6_8"

    input:
    tuple val(meta), path(reads)
    path fasta
    path bwa_index

    output:
    tuple val(meta), path("*.sam"), emit: sam

    script:
    """
    bwa mem -t $task.cpus -M $fasta ${reads[0]} ${reads[1]} > ${meta.id}.sam
    """
}
