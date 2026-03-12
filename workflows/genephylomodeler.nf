/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { HYPHY_ABSREL            } from '../modules/local/hyphy_absrel/main'
include { HYPHY_BGM            } from '../modules/local/hyphy_bgm/main'
include { HYPHY_BUSTED            } from '../modules/local/hyphy_busted/main'
include { HYPHY_FEL               } from '../modules/local/hyphy_fel/main'
include { HYPHY_FUBAR             } from '../modules/local/hyphy_fubar/main'
include { HYPHY_GARD               } from '../modules/local/hyphy_gard/main'
include { HYPHY_MEME              } from '../modules/local/hyphy_meme/main'
include { HYPHY_RELAX             } from '../modules/local/hyphy_relax/main'
include { HYPHY_SLAC             } from '../modules/local/hyphy_slac/main'
include { softwareVersionsToYAML  } from '../subworkflows/nf-core/utils_nfcore_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow GENEPHYLOMODELER {

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
                bgm: meta.suite == 'hyphy' && meta.tool == 'bgm'
                busted: meta.suite == 'hyphy' && meta.tool == 'busted'
                fel:    meta.suite == 'hyphy' && meta.tool == 'fel'
                fubar:  meta.suite == 'hyphy' && meta.tool == 'fubar'
                gard:    meta.suite == 'hyphy' && meta.tool == 'gard'
                meme:   meta.suite == 'hyphy' && meta.tool == 'meme'
                relax:  meta.suite == 'hyphy' && meta.tool == 'relax'
                slac:  meta.suite == 'hyphy' && meta.tool == 'slac'
        }
        .set { ch_branched }

    //
    // MODULE: aBSREL - Adaptive Branch-Site Random Effects Likelihood
    //
    HYPHY_ABSREL ( ch_branched.absrel )
    ch_versions = ch_versions.mix(HYPHY_ABSREL.out.versions.first())

    //
    // MODULE: BGM - Bayesian Graphical Model
    //
    HYPHY_BGM ( ch_branched.bgm )
    ch_versions = ch_versions.mix(HYPHY_BGM.out.versions.first())

    //
    // MODULE: BUSTED - Branch-Site Unrestricted Statistical Test
    //
    HYPHY_BUSTED ( ch_branched.busted )
    ch_versions = ch_versions.mix(HYPHY_BUSTED.out.versions.first())

    //
    // MODULE: FEL - Fixed Effects Likelihood
    //
    HYPHY_FEL ( ch_branched.fel )
    ch_versions = ch_versions.mix(HYPHY_FEL.out.versions.first())

    //
    // MODULE: FUBAR - Fast, Unconstrained Bayesian AppRoximation
    //
    HYPHY_FUBAR ( ch_branched.fubar )
    ch_versions = ch_versions.mix(HYPHY_FUBAR.out.versions.first())
    
    // MODULE: GARD - Genetic Algorithm for Recombination Detection
    //
    HYPHY_GARD ( ch_branched.gard )
    ch_versions = ch_versions.mix(HYPHY_GARD.out.versions.first())

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
    // MODULE: SLAC - Single-Likelihood Ancestor Counting
    //
    HYPHY_SLAC ( ch_branched.slac )
    ch_versions = ch_versions.mix(HYPHY_SLAC.out.versions.first())

    //
    // Collate and save software versions
    //
    softwareVersionsToYAML(ch_versions)
        .collectFile(
            storeDir: "${params.outdir}/pipeline_info",
            name: 'nf_core_'  +  'genephylomodeler_software_'  + 'mqc_'  + 'versions.yml',
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
