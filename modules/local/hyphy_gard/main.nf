process HYPHY_GARD {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"

    input:
    tuple val(meta), path(alignment), path(tree)

    output:
    tuple val(meta), path("*.json"), emit: json
    tuple val(meta), path("*_output.txt"), emit: log
    path "versions.yml",                   emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    hyphy gard \\
        CPU=${task.cpus} \\
        --alignment ${alignment} \\
        ${args} \\
        --output ${prefix}_GARD.json \\
        > ${prefix}_GARD_output.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hyphy: \$(hyphy --version | head -n 1 | sed 's/.*HYPHY //;s/ .*//')
    END_VERSIONS
    """
}
