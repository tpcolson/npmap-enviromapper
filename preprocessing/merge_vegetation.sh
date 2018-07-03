#!/bin/bash

for color in {1..2}; do
    j=0
    cp tmp/vegetation_alluvial_vegetation_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_chestnut_oak_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    /usr/bin/python $(which gdal_merge.py) -n 0 -a_nodata 0 -o sublayers/vegetation_"$j"_"$color".tif tmp/vegetation_ericaceous_*"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_floodplain_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_hemlock_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_high_elevation_beech_red_oak_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_high_elevation_red_oak_white_oak_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_montane_cove_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_montane_oak_hickory_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_northern_hardwood_acid_hardwood_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_northern_hardwood_boulderfield_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_spruce_fir_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    /usr/bin/python $(which gdal_merge.py) -n 0 -a_nodata 0 -o sublayers/vegetation_"$j"_"$color".tif tmp/vegetation_successional_*"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_white_pine_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));

    cp tmp/vegetation_yellow_pine_forests_"$color".tif sublayers/vegetation_"$j"_"$color".tif
    j=$(( j + 1 ));
done

