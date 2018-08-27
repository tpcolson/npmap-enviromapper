#!/bin/bash

for i in 0 1 2; do 
    mv sublayers/con_direct_solar_radiation_$i.tif sublayers/con_solar_rad_$i.tif
done;
