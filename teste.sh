#!/bin/bash

dayArray=(60 75 90 105 120 135 150 165 180 195 210)
ano=`date +%Y`

dateArray=("$ano-08-30" "$ano-09-14" "$ano-09-29" "$ano-10-14" "$ano-10-29" "$ano-11-13" "$ano-11-28" "$ano-12-13" "$ano-12-28" "$ano-01-12" "$ano-01-27")


for ((i=0; i<${#dayArray[@]}; i++)) do

    echo ${dateArray[$i]}
done
