#!/bin/bash

counter=0
for i in `ls -a tmp/cat_type_disturbance_*1.tif`; do 
    echo $i;
    name=$(echo "dist_"$counter"_1")
    cp $i sublayers/$name.tif
    counter=$(( counter+1 ))
done;

counter=0
for i in `ls -a tmp/cat_type_disturbance_*2.tif`; do 
    echo $i;
    name=$(echo "dist_"$counter"_2")
    cp $i sublayers/$name.tif
    counter=$(( counter+1 ))
done;
