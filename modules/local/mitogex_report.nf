process MITOGEX_REPORT {
    label 'process_low'

    conda "bioconda::bash=5.1.16"
    // Container would be a basic bash/alpine container or ubuntu
    container "ubuntu:22.04"

    input:
    path web_scripts_dir
    path annovar_outputs
    path haplogrep_outputs
    path phylogenetic_outputs

    output:
    path "*.html", emit: html_reports

    script:
    """
    # Assuming scripts are provided and adapted for Nextflow
    bash ${web_scripts_dir}/web_index.sh . > index.html
    
    # Generate HTML reports for each sample
    for FILE in *.hg38_multianno.txt; do
        BASENAME=\$(basename "\$FILE" .hg38_multianno.txt)
        bash ${web_scripts_dir}/web_sample.sh . "\$BASENAME" > "sample_\${BASENAME}.html"
        bash ${web_scripts_dir}/web_variants.sh . "\$BASENAME" > "variants_\${BASENAME}.html"
    done
    
    bash ${web_scripts_dir}/web_haplogroup.sh . > haplogroup.html
    """
}
