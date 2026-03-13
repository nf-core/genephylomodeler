/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { HYPHY_ABSREL            } from '../modules/local/hyphy_absrel/main'
include { HYPHY_BUSTED            } from '../modules/local/hyphy_busted/main'
include { HYPHY_MEME              } from '../modules/local/hyphy_meme/main'
include { HYPHY_FADE            } from '../modules/local/hyphy_fade/main'
include { HYPHY_RELAX             } from '../modules/local/hyphy_relax/main'
include { softwareVersionsToYAML  } from '../subworkflows/nf-core/utils_nfcore_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow PHYLOANALYSIS {

    take:
    ch_samplesheet // channel: [ val(meta), path(alignment), path(tree) ]

    main:

    ch_versions = Channel.empty()

    //
    // Branch input channel by suite and tool specified in meta
    //
    ch_samplesheet
        .branch {
            meta, alignment, tree ->
                absrel: meta.suite == 'hyphy' && meta.tool == 'absrel'
                busted: meta.suite == 'hyphy' && meta.tool == 'busted'
                meme:   meta.suite == 'hyphy' && meta.tool == 'meme'
                relax:  meta.suite == 'hyphy' && meta.tool == 'relax'
                fade:   meta.suite == 'hyphy' && meta.tool == 'fade'
        }
        .set { ch_branched }

    //
    // MODULE: aBSREL - Adaptive Branch-Site Random Effects Likelihood
    //
    HYPHY_ABSREL ( ch_branched.absrel )
    ch_versions = ch_versions.mix(HYPHY_ABSREL.out.versions.first())

    //
    // MODULE: BUSTED - Branch-Site Unrestricted Statistical Test
    //
    HYPHY_BUSTED ( ch_branched.busted )
    ch_versions = ch_versions.mix(HYPHY_BUSTED.out.versions.first())

    //
    // MODULE: MEME - Mixed Effects Model of Evolution
    //
    HYPHY_MEME ( ch_branched.meme )
    ch_versions = ch_versions.mix(HYPHY_MEME.out.versions.first())

    //
    // MODULE: RELAX - Relaxed Selection Test
    //
    HYPHY_RELAX ( ch_branched.relax )
    ch_versions = ch_versions.mix(HYPHY_RELAX.out.versions.first())

    //
    // MODULE: FADE - FUBAR Approach to Directional Evolution
    //
    HYPHY_FADE ( ch_branched.fade )
    ch_versions = ch_versions.mix(HYPHY_FADE.out.versions.first())

    //
    // Collate and save software versions
    //
    softwareVersionsToYAML(ch_versions)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info",
            name: 'nf_core_'  +  'phyloanalysis_software_'  + 'mqc_'  + 'versions.yml',
            sort: true,
            newLine: true
        ).set { ch_collated_versions }

    emit:
    versions = ch_versions // channel: [ path(versions.yml) ]
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
