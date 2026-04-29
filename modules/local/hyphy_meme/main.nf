process HYPHY_MEME {
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
    hyphy meme \\
        CPU=${task.cpus} \\
        --alignment ${alignment} \\
        --tree ${tree} \\
        ${args} \\
        --output ${prefix}_MEME.json \\
        > ${prefix}_MEME_output.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        hyphy: \$(hyphy --version | head -n 1 | sed 's/.*HYPHY //;s/ .*//')
    END_VERSIONS
    """
}
