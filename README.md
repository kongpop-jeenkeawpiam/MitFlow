# MitoGEx Nextflow Pipeline (MitFlow)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A523.04.0-23aa62.svg)](https://www.nextflow.io/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with conda](https://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)

The **Mitochondrial Genome Explorer (MitoGEx) Nextflow Pipeline** is a comprehensive bioinformatics workflow for the alignment, variant calling, annotation, and phylogenetic analysis of mitochondrial genomes. It adheres to strict nf-core standards for reproducibility and portability.

## Prerequisites

To run this pipeline, you need to install:

1. [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html) (`>=23.04.0`)
2. One of the following container/package management systems:
   * [Docker](https://docs.docker.com/engine/installation/)
   * [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html)

## Quick Start (Test Profile)

You can run the pipeline using the built-in `test` profile to ensure everything is functioning correctly on your system. This profile will automatically download a minimal test dataset.

```bash
nextflow run main.nf -profile test,docker
```

## Running the Pipeline

A typical command for running the pipeline on your own data looks like this:

```bash
nextflow run main.nf \
    -profile docker \
    --input samplesheet.csv \
    --fasta reference.fasta \
    --bwa_index bwa_index_dir/ \
    --fai reference.fasta.fai \
    --dict reference.dict \
    --annovar_db annovar_db_dir/ \
    --outdir results/
```

### Input Samplesheet

The `--input` parameter expects a CSV file containing your sample information and paths to your FASTQ reads.

Example `samplesheet.csv`:
```csv
sample_id,fastq_1,fastq_2
sample1,reads/sample1_R1.fastq.gz,reads/sample1_R2.fastq.gz
sample2,reads/sample2_R1.fastq.gz,reads/sample2_R2.fastq.gz
```

## Key Parameters

| Parameter | Description | Required | Default |
| :--- | :--- | :---: | :--- |
| `--input` | Path to comma-separated samplesheet | Yes | |
| `--outdir` | The output directory where the results will be saved | No | `results` |
| `--fasta` | Path to the reference genome FASTA file | Yes | |
| `--bwa_index` | Path to directory containing the BWA index for the reference genome | Yes | |
| `--fai` | Path to the FASTA index (`.fai`) for the reference genome | Yes | |
| `--dict` | Path to the sequence dictionary (`.dict`) for the reference genome | Yes | |
| `--annovar_db` | Path to the Annovar database directory | Yes | |
| `--qc_tool` | Tool to use for quality control | No | `fastp` |
| `--project_title`| Title of the project for generated reports | No | `MitoGEx_Project` |

> **Note:** To see a full list of all available parameters, run `nextflow run main.nf --help`.

## Output Structure

The pipeline generates organized outputs in the directory specified by `--outdir` (default: `results/`):

* `results/QC/` - Quality control metrics (FASTQC, FASTP, Qualimap).
* `results/alignment/` - Processed BAM files and indices.
* `results/variant_calling/` - VCF files containing mitochondrial variants (GATK Mutect2).
* `results/annotation/` - Annotated variants using Annovar and HaploGrep3.
* `results/phylogeny/` - Phylogenetic trees built using IQ-TREE2.
* `results/reports/` - Final HTML reports aggregating the pipeline's findings.

## Credits

This pipeline was developed by the MitoGEx Team. For any citations, please refer to the `CITATION.md` file included in this repository.
