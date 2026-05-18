process ANNOVAR {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::annovar=20200608"
    container "quay.io/biocontainers/annovar:20200608--pl5321hdfd78af_0"

    input:
    tuple val(meta), path(vcf), path(tbi)
    path annovar_db

    output:
    tuple val(meta), path("*.hg38_multianno.txt"), emit: txt
    tuple val(meta), path("*.avinput"), emit: avinput

    script:
    """
    convert2annovar.pl -format vcf4 -includeinfo $vcf > ${meta.id}.avinput
    table_annovar.pl ${meta.id}.avinput $annovar_db -buildver hg38 -out ${meta.id} -remove -protocol MitImpact313 -operation f -nastring . -polish -otherinfo
    """
}
