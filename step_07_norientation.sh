#!/bin/bash

infolder="CFSv2/geotiff/"
outfolder="CFSv2/norientation/"

for i in $(ls $infolder*".nc.tif"); do
    FILENAME=$(echo $i|sed 's/.*\///')
    FILENAME=$(echo $FILENAME|sed -r 's/.nc.tif//g')

    gdalwarp -overwrite $i $outfolder$FILENAME".tif"
done


