#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage:\t ./run.sh <geojson file> <layer name>"
    exit
fi

if [ ! -d tmp ]; then
    mkdir tmp
fi

layer=$2
variable_name=Dens_Class
counter=0
echo -e "Heavy\nMedium\nLight" | 
while read -r line;
do
    echo $line
    line=$(echo $line | dos2unix)
    gdal_rasterize -ot Byte -a_nodata 0 -a OBJECTID -l OGRGeoJSON -ts 3128 1192 -burn 196 -burn 28 -burn 142 -where "$variable_name LIKE '%$line%'" $1 tmp/temp.tif
    line=$(echo $line | sed 's/ /_/g' | sed -E -e 's/[;\,-/]/_/g' | sed 's/__/_/g' | sed 's/[)(]//g' | tr '[:upper:]' '[:lower:]')
    gdal_translate tmp/temp.tif tmp/"$layer"_"$line"_1.tif
    #gdal_translate -a_srs EPSG:4326 tmp/temp.tif tmp/"$layer"_"$line"_1.tif
    counter=$(( counter+1 ))
done;

#counter=0
#echo -e "Heavy\nMedium\nLight" | 
#while read -r line;
#do
#    echo $line
#    line=$(echo $line | dos2unix)
#    gdal_rasterize -ot Byte -a_nodata 0 -a OBJECTID -l OGRGeoJSON -ts 3128 1192 -burn 253 -burn 142 -burn 31 -where "$variable_name LIKE '%$line%'" $1 tmp/temp.tif
#    line=$(echo $line | sed 's/ /_/g' | sed -E -e 's/[;\,-/]/_/g' | sed 's/__/_/g' | sed 's/[)(]//g' | tr '[:upper:]' '[:lower:]')
#    gdal_translate tmp/temp.tif tmp/"$layer"_"$line"_2.tif
#    counter=$(( counter+1 ))
#done;

