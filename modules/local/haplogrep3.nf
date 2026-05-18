process HAPLOGREP3 {
    tag "$meta.id"
    label 'process_low'

    conda "bioconda::haplogrep3=3.2.2"
    container "quay.io/biocontainers/haplogrep3:3.2.2--hdfd78af_0"

    input:
    tuple val(meta), path(vcf), path(tbi)

    output:
    tuple val(meta), path("*.txt"), emit: txt
    tuple val(meta), path("*.fasta"), emit: fasta
    tuple val(meta), path("*.qc"), emit: qc

    script:
    """
    haplogrep3 classify --tree=phylotree-fu-rcrs@1.2 --input=$vcf --output=${meta.id}.txt --write-fasta --write-qc
    """
}
