#!/bin/bash

counter=0
    i="tmp/density_light_1.tif"
    echo $i;
    name=$(echo "density_"$counter"")
    cp $i sublayers/$name.tif
    counter=$(( counter+1 ))

    i="tmp/density_medium_1.tif"
    echo $i;
    name=$(echo "density_"$counter"")
    cp $i sublayers/$name.tif
    counter=$(( counter+1 ))

    i="tmp/density_heavy_1.tif"
    echo $i;
    name=$(echo "density_"$counter"")
    cp $i sublayers/$name.tif
    counter=$(( counter+1 ))
