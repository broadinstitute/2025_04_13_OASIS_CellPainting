# Imports
import os
import preprocessing as pp
import classifier as cl
import concresponse as cr
import visualize as vs

features = config["features"]
scenario = config["workflow"]
name = config["name"]

# Rules 
rule compute_negcon_stats:
    input:
        f"inputs/profiles/{features}/raw.parquet",
    output:
        f"outputs/{features}/{name}/profiles/neg_stats.parquet",
    run:
        pp.stats.compute_negcon_stats(*input, *output)


rule select_variant_feats:
    input:
        f"inputs/profiles/{features}/raw.parquet",
        f"outputs/{features}/{name}/profiles/neg_stats.parquet",
    output:
        f"outputs/{features}/{name}/profiles/variant_feats.parquet",
    run:
        pp.stats.select_variant_features(*input, *output)


rule compute_norm_stats:
    input:
        f"outputs/{features}/{name}/profiles/mad.parquet",
    output:
        f"outputs/{features}/{name}/profiles/norm_stats.parquet",
    run:
        pp.stats.compute_stats(*input, *output)


rule iqr_outliers:
    input:
        f"outputs/{features}/{name}/profiles/mad.parquet",
        f"outputs/{features}/{name}/profiles/norm_stats.parquet",
    output:
        f"outputs/{features}/{name}/profiles/outliers.parquet",
    run:
        pp.outliers.iqr(config["iqr_scale"], *input, *output)