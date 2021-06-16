#!/bin/bash

infolder="CFSv2/norientation/"
outfolder="CFSv2/shapefiles/"

year=2020

v.in.ogr -o input="utils/clipextent.shp" output="clipextent"

for i in $(ls $infolder*".tif"); do
    FILENAME=$(echo $i|sed 's/.*\///')
    FILENAME=$(echo $FILENAME|sed -r 's/.tif//g')

    DATE=${FILENAME:15:23}

    r.in.gdal --overwrite -o input="utils/mae_onset.tif" output="MAE"

    r.in.gdal --overwrite -o input=$i output=$FILENAME

    g.region raster=$FILENAME

    g.region -p n="-9.98124965694444" s="-15.6471882777778" e="-42.9304164219444" w="-46.8329164333333" align=$FILENAME

    r.clip --overwrite input=$FILENAME output="clip"

    r.out.gdal --overwrite input="clip" output=$outfolder"onset.tif"

done
