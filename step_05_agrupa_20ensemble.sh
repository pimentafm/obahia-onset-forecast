#!/bin/bash
prefix="daily_onset_"
sufix=".nc"
fname="mes_20ensemble_"

hora=(00 06 12 18)
meses=(07 08 09 10)
#ano=(system)
diasmes=(01 27 28 29 30 31)

ano=`date +%Y`

#ajustar diretorios...
infolder="CFSv2/onsetforecast/" #aa_grid100x100/sem_preench/"
outfolder="CFSv2/onsetforecast/"
        
                
rm $infolder$fname$ano"0801.nc"
rm $infolder$fname$ano"0901.nc"
#rm $infolder$fname$ano"1001.nc"

cdo mergetime $infolder$prefix$ano"0728.nc" $infolder$prefix$ano"0729.nc" $infolder$prefix$ano"0730.nc" $infolder$prefix$ano"0731.nc" $infolder$prefix$ano"0801.nc" $infolder$fname$ano"0801.nc"
cdo mergetime $infolder$prefix$ano"0828.nc" $infolder$prefix$ano"0829.nc" $infolder$prefix$ano"0830.nc" $infolder$prefix$ano"0831.nc" $infolder$prefix$ano"0901.nc" $infolder$fname$ano"0901.nc"
# cdo mergetime $infolder$prefix$ano"0927.nc" $infolder$prefix$ano"0928.nc" $infolder$prefix$ano"0929.nc" $infolder$prefix$ano"0930.nc" $infolder$prefix$ano"1001.nc" $infolder$fname$ano"1001.nc"

# cdo mergetime $infolder$prefix$ano"0801.nc" $infolder$prefix$ano"0802.nc" $infolder$prefix$ano"0803.nc" $infolder$prefix$ano"0804.nc" $infolder$prefix$ano"0731.nc" $infolder$fname$ano"0801.nc"
# cdo mergetime $infolder$prefix$ano"0831.nc" $infolder$prefix$ano"0901.nc" $infolder$prefix$ano"0902.nc" $infolder$prefix$ano"0903.nc" $infolder$prefix$ano"0904.nc" $infolder$fname$ano"0901.nc"
# cdo mergetime $infolder$prefix$ano"0930.nc" $infolder$prefix$ano"1001.nc" $infolder$prefix$ano"1002.nc" $infolder$prefix$ano"1003.nc" $infolder$prefix$ano"1004.nc" $infolder$fname$ano"1001.nc"
