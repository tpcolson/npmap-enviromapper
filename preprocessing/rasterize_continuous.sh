#!/bin/bash

# Will rasterize all if omitted 
sublayer_name=$1

for i in `ls sublayers/$sublayer_name*0.asc`;
do
    output=$(echo $i | sed 's/\.asc/.tif/g')
    ./asc_to_colored_tif $i color_ramp_pink_0.txt $output
done;

for i in `ls sublayers/$sublayer_name*1.asc`;
do
    output=$(echo $i | sed 's/\.asc/.tif/g')
    ./asc_to_colored_tif $i color_ramp_pink_1.txt $output
done;

for i in `ls sublayers/$sublayer_name*2.asc`;
do
    output=$(echo $i | sed 's/\.asc/.tif/g')
    ./asc_to_colored_tif $i color_ramp_pink_2.txt $output
done;
