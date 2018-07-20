#!/bin/bash

counter=0
for i in `ls -a tmp/density_*1.tif`; do 
    echo $i;
    name=$(echo "density_"$counter"")
    cp $i sublayers/$name.tif
    counter=$(( counter+1 ))
done;

