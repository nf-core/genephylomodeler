process PAML_CODEML {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"

    input:
    tuple val(meta), path(alignment), path(tree), path(control_file)

    output:
    tuple val(meta), path("*_output.txt"),    emit: output
    tuple val(meta), path("${prefix}.log"),    emit: log
    path "versions.yml",                   emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${meta.id}"
    """
    sed -E "s|^\s*outfile\s*=.*|outfile = ${prefix}_CODEML_output.txt|" ${control_file} > run.ctl
    codeml run.ctl > ${prefix}.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        codeml: \$(grep 'paml version' ${prefix}.log | sed 's/.*version //;s/,.*//')
    END_VERSIONS
    """
}
