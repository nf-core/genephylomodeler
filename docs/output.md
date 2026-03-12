# nf-core/genephylomodeler: Output

## Introduction

This document describes the output produced by the pipeline. The directories listed below will be created in the results directory after the pipeline has finished. All paths are relative to the top-level results directory.

## Pipeline overview

The pipeline is built using [Nextflow](https://www.nextflow.io/) and runs selection analysis using [HyPhy](https://www.hyphy.org/) with the following methods:

- [aBSREL](#absrel) - Adaptive Branch-Site Random Effects Likelihood
- [BGM](#bgm) - Bayesian Graphical Model
- [BUSTED](#busted) - Branch-Site Unrestricted Statistical Test for Episodic Diversification
- [FADE](#fade) - FUBAR Approach to Directional Evolution
- [FEL](#fel) - Fixed Effects Likelihood
- [FUBAR](#fubar) - Fast Unconstrained Bayesian AppRoximation
- [GARD](#gard) - Genetic Algorithm for Recombination Detection
- [MEME](#meme) - Mixed Effects Model of Evolution
- [RELAX](#relax) - Test for relaxation or intensification of selection
- [SLAC](#slac) - Single-Likelihood Ancestor Counting
- [Pipeline information](#pipeline-information) - Report metrics generated during the workflow execution

### aBSREL

<details markdown="1">
<summary>Output files</summary>

- `absrel/`
  - `*_ABSREL.json`: JSON results file containing per-branch test statistics for episodic diversifying selection.
  - `*_ABSREL_output.txt`: Standard output log from the aBSREL analysis.

</details>

aBSREL (adaptive Branch-Site Random Effects Likelihood) tests each branch on a phylogeny for episodic diversifying selection. It infers the optimal number of omega rate classes for each branch and tests whether a proportion of sites have evolved under positive selection.

### BGM

<details markdown="1">
<summary>Output files</summary>

- `bgm/`
  - `*_BGM.json`: JSON results file containing posterior probabilities for coevolving site pairs.
  - `*_BGM_output.txt`: Standard output log from the BGM analysis.

</details>

BGM (Bayesian Graphical Model) identifies pairs of codon sites that co-evolve using a Bayesian graphical model approach. It detects epistatic interactions between sites by looking for correlated substitution patterns across the phylogeny.

### BUSTED

<details markdown="1">
<summary>Output files</summary>

- `busted/`
  - `*_BUSTED.json`: JSON results file containing gene-wide test statistics for episodic diversifying selection.
  - `*_BUSTED_output.txt`: Standard output log from the BUSTED analysis.

</details>

BUSTED (Branch-Site Unrestricted Statistical Test for Episodic Diversification) provides a gene-wide test for positive selection by asking whether a gene has experienced positive selection at at least one site on at least one branch.

### FADE

<details markdown="1">
<summary>Output files</summary>

- `fade/`
  - `*_FADE.json`: JSON results file containing per-site Bayes factors for directional selection.
  - `*_FADE_output.txt`: Standard output log from the FADE analysis.

</details>

FADE (FUBAR Approach to Directional Evolution) detects directional selection at individual sites, identifying amino acid residues where evolution is biased toward specific substitutions in a designated set of branches. It extends the FUBAR framework to test whether a particular amino acid is being preferentially selected.

### FEL

<details markdown="1">
<summary>Output files</summary>

- `fel/`
  - `*_FEL.json`: JSON results file containing per-site test statistics for pervasive positive or negative selection.
  - `*_FEL_output.txt`: Standard output log from the FEL analysis.

</details>

FEL (Fixed Effects Likelihood) estimates site-specific synonymous and non-synonymous substitution rates using a maximum likelihood approach. It tests each site individually for evidence of pervasive positive or purifying selection, assuming the selection pressure is constant across the entire phylogeny.

### FUBAR

<details markdown="1">
<summary>Output files</summary>

- `fubar/`
  - `*_FUBAR.json`: JSON results file containing posterior probabilities of positive or negative selection per site.
  - `*_FUBAR_output.txt`: Standard output log from the FUBAR analysis.

</details>

FUBAR (Fast Unconstrained Bayesian AppRoximation) uses a Bayesian approach to infer site-specific selection rates. It provides posterior probabilities that each site is under positive or purifying selection and is substantially faster than FEL for large datasets.

### GARD

<details markdown="1">
<summary>Output files</summary>

- `gard/`
  - `*_GARD.json`: JSON results file containing detected recombination breakpoints and segment-specific phylogenies.
  - `*_GARD_output.txt`: Standard output log from the GARD analysis.

</details>

GARD (Genetic Algorithm for Recombination Detection) screens alignments for evidence of recombination breakpoints. It uses a genetic algorithm to search for the placement of breakpoints that maximize the model fit, partitioning the alignment into segments with distinct phylogenetic topologies.

### MEME

<details markdown="1">
<summary>Output files</summary>

- `meme/`
  - `*_MEME.json`: JSON results file containing per-site test statistics for episodic diversifying selection.
  - `*_MEME_output.txt`: Standard output log from the MEME analysis.

</details>

MEME (Mixed Effects Model of Evolution) tests for episodic positive selection at individual sites. Unlike methods that assume the same selection pressure across all lineages, MEME allows the distribution of omega to vary from site to site and from branch to branch.

### RELAX

<details markdown="1">
<summary>Output files</summary>

- `relax/`
  - `*_RELAX.json`: JSON results file containing test statistics for relaxation or intensification of selection.
  - `*_RELAX_output.txt`: Standard output log from the RELAX analysis.

</details>

RELAX is a hypothesis testing framework that asks whether the strength of natural selection has been relaxed or intensified along a specified set of test branches. It uses a parameter K to quantify the extent of relaxation (K < 1) or intensification (K > 1).

### SLAC

<details markdown="1">
<summary>Output files</summary>

- `slac/`
  - `*_SLAC.json`: JSON results file containing per-site counts of synonymous and non-synonymous substitutions.
  - `*_SLAC_output.txt`: Standard output log from the SLAC analysis.

</details>

SLAC (Single-Likelihood Ancestor Counting) is a counting-based method that estimates the number of synonymous and non-synonymous substitutions at each site by reconstructing ancestral sequences via maximum likelihood. It is the fastest site-level selection method and is well-suited for preliminary screening of large datasets.

### Pipeline information

<details markdown="1">
<summary>Output files</summary>

- `pipeline_info/`
  - Reports generated by Nextflow: `execution_report.html`, `execution_timeline.html`, `execution_trace.txt` and `pipeline_dag.dot`/`pipeline_dag.svg`.
  - Reports generated by the pipeline: `pipeline_report.html`, `pipeline_report.txt` and `software_versions.yml`. The `pipeline_report*` files will only be present if the `--email` / `--email_on_fail` parameter's are used when running the pipeline.
  - Reformatted samplesheet files used as input to the pipeline: `samplesheet.valid.csv`.
  - Parameters used by the pipeline run: `params.json`.

</details>

[Nextflow](https://www.nextflow.io/docs/latest/tracing.html) provides excellent functionality for generating various reports relevant to the running and execution of the pipeline. This will allow you to troubleshoot errors with the running of the pipeline, and also provide you with other information such as launch commands, run times and resource usage.
