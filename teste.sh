#!/bin/bash

dayArray=(60 75 90 105 120 135 150 165 180 195 210)

dateArray=("2019-08-30" "2019-09-14" "2019-09-29" "2019-10-14" "2019-10-29" "2019-11-13" "2019-11-28" "2019-12-13" "2019-12-28" "2020-01-12" "2020-01-27")


for ((i=0; i<${#dayArray[@]}; i++)) do

    echo ${dateArray[$i]}
done