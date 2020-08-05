#!/bin/bash

inputdata="CFSv2/grb2/"
outputdata="CFSv2/netcdf/"

gridfile="utils/grid.txt"

cp $inputdata*.grb2 CFSv2/grb2_backup

for i in $(ls $inputdata*.grb2); do
  FILEDATE=$(echo $i|sed 's/.*\///')
  FILEDATE=$(echo $FILEDATE|sed -r 's/prate.01.//g')
  FILEDATE=$(echo $FILEDATE|sed -r 's/.daily.grb2//g')
  FILEDATE=$FILEDATE"0000"

  date="${FILEDATE:0:4}-${FILEDATE:4:2}-${FILEDATE:6:2}"
  hour="${FILEDATE:8:2}:${FILEDATE:10:2}:${FILEDATE:12:2}"

  grib_to_netcdf $i -o $i".converted.nc"
  cdo setgrid,$gridfile $i".converted.nc" $i".translated.nc"
  cdo sellonlatbox,-83.9066462049297286,-35.1567006578632473,-17.9527409283651238,-0.0000199766622649 $i".translated.nc" $i".sliced.nc"
  cdo -b F32 -mulc,3600 $i".sliced.nc" $i".mmday.nc"
  ncrename -h -O -v "prate","PRATE_P0_L1_GGA0" $i".mmday.nc"
  cdo settaxis,$date,$hour $i".mmday.nc" $i".reassignedatetime.nc"
  cdo setunit,"mm*d-1" $i".reassignedatetime.nc" $i".nc"
done

# # Remove unused data
shopt -s extglob
rm -f $inputdata!(*.grb2.nc)

# # Change files to netcdf directory
mv  $inputdata*.nc $outputdata
