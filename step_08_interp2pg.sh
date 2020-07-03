#!/bin/bash

infolder="CFSv2/norientation/"
outfolder="CFSv2/shapefiles/"

dayArray=(60 75 90 105 120 135 150 165 180 195 210)
dateArray=("2019-08-30" "2019-09-14" "2019-09-29" "2019-10-14" "2019-10-29" "2019-11-13" "2019-11-28" "2019-12-13" "2019-12-28" "2020-01-12" "2020-01-27")

for i in $(ls $infolder*".tif"); do
    FILENAME=$(echo $i|sed 's/.*\///')
    FILENAME=$(echo $FILENAME|sed -r 's/.tif//g')

    r.in.gdal -o input=$i output=$FILENAME

    g.region raster=$FILENAME 

    r.reclass --overwrite input=$FILENAME output="reclass" rules="utils/reclassify.txt"

    r.to.vect --overwrite -s input="reclass" output="shape" type="area" column="onset"

    v.db.addcolumn map="shape" columns="date VARCHAR(10)"

    for ((j=0; j<${#dayArray[@]}; j++)) do
        v.db.update map=shape column="date" value=${dateArray[$j]} where="onset= ${dayArray[$j]}"
    done

    v.generalize --overwrite input="shape" type="area" output="lang" method="lang" threshold=1

    v.generalize --overwrite input="lang" output="chaiken" method="chaiken" threshold=1

    db.login --overwrite driver=pg database=obahia user=geonode password=uppQAOFa host=obahia.dea.ufv.br port=5432
    v.out.postgis --overwrite input="chaiken" type="area" output=PG:dbname=obahia output_layer=vector.$FILENAME options="SRID=4326"

    #v.out.ogr --overwrite -s -e input="chaiken" type="area" output=$outfolder$FILENAME".shp" format="ESRI_Shapefile"
done
