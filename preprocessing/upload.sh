#!/bin/bash

for i in `ls sublayers/vegetation_*.tif`; do
    name=`basename $i .tif`
    echo $name
    mapbox --access-token sk.eyJ1IjoibWFobWFkemEiLCJhIjoiY2pnYmh0eW4wMmpwYjJxcm41d3d6NjQwYiJ9.zNAoZXxx7qiXw-rLAGILeQ upload mahmadza.GRSM_$name $i
done;
