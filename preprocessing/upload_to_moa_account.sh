#!/bin/bash

mapbox_user="mahmadza"
dataset_prefix="GRSM"
access_file="secret.txt"
access_token=$(cat $access_file)
gdal_cmd="gdal_translate -of GTiff -a_nodata 0"
upload_cmd="mapbox --access-token $access_token upload"
geotiff_dir="./geotiffs"
ext="tif"

while read line; do
	for sp in $line; do
		sp=${sp%.tif}
		color=${sp##*_}
		species_name=${sp%_*}
		$gdal_cmd $geotiff_dir/$sp\.$ext $geotiff_dir/$sp_blue\.$ext
		$upload_cmd $mapbox_user\.$dataset_prefix\_$color $geotiff_dir/$sp_blue\.$ext
	done
done <<< $(ls $geotiff_dir)
